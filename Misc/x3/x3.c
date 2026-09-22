#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <libgen.h>
#include <ftw.h>
#include <signal.h>
#include <fnmatch.h>
#include <ctype.h>
#include <dirent.h>
#include <termios.h>
#include <errno.h>
#include <sys/time.h>
#include <sys/select.h>
#include <fcntl.h>

#define TMP_TEMPLATE "/tmp/x3-XXXXXX"
#define BUF_SIZE 8192
#define MAX_RESULTS 2048
#define MAX_PATTERNS 32
#define MAX_KEYWORDS 32
#define MAX_HISTORY 100

typedef struct {
    char *patterns[MAX_PATTERNS];
    int pattern_count;
    char *keywords[MAX_KEYWORDS];
    int keyword_count;
    char *or_patterns[MAX_PATTERNS];
    int or_count;
    char *exclude_patterns[MAX_PATTERNS];
    int exclude_count;
    char *path_keywords[MAX_KEYWORDS];
    int path_keyword_count;
    char *name_patterns[MAX_PATTERNS];
    int name_pattern_count;
    char *ext_patterns[MAX_PATTERNS];
    int ext_count;
    char *dir_keywords[MAX_KEYWORDS];
    int dir_keyword_count;
} search_query_t;

static char g_tmpdir[sizeof(TMP_TEMPLATE)];
static int g_tmpdir_created = 0;
static char *g_root = NULL;
static pid_t g_child_pid = -1;

static struct termios g_saved_termios;
static int g_have_saved_termios = 0;
static int g_terminal_raw = 0;

static char *results[MAX_RESULTS];
static int result_count = 0;
static int selected = 0;
static char *current_dir = NULL;
static char *history[MAX_HISTORY];
static int history_count = 0;

static void reset_results(void);
static void restore_terminal(void);
static void force_terminal_sane(void);

static int unlink_cb(const char *fpath, const struct stat *sb, int t, struct FTW *ftw)
{
    (void)sb;
    (void)t;
    (void)ftw;
    return remove(fpath);
}

static void cleanup(void)
{
    force_terminal_sane();

    if (g_child_pid > 0) {
        killpg(g_child_pid, SIGTERM);
        usleep(200000);
        int status;
        if (waitpid(g_child_pid, &status, WNOHANG) == 0) {
            killpg(g_child_pid, SIGKILL);
            waitpid(g_child_pid, NULL, 0);
        }
        g_child_pid = -1;
    }

    if (g_tmpdir_created) {
        nftw(g_tmpdir, unlink_cb, 64, FTW_DEPTH | FTW_PHYS);
        g_tmpdir_created = 0;
    }

    reset_results();
    if (current_dir) {
        free(current_dir);
        current_dir = NULL;
    }
    if (g_root) {
        free(g_root);
        g_root = NULL;
    }

    for (int i = 0; i < history_count; i++) {
        free(history[i]);
        history[i] = NULL;
    }
    history_count = 0;

    force_terminal_sane();
}

static void signal_handler(int sig)
{
    if (g_have_saved_termios)
        tcsetattr(STDIN_FILENO, TCSANOW, &g_saved_termios);
    _exit(128 + sig);
}

static void save_terminal(void)
{
    if (!isatty(STDIN_FILENO))
        return;

    if (tcgetattr(STDIN_FILENO, &g_saved_termios) == -1) {
        perror("[x3] tcgetattr");
        return;
    }

    g_have_saved_termios = 1;
}

static int raw_terminal(void)
{
    if (!g_have_saved_termios)
        return 0;
    if (g_terminal_raw)
        return 1;

    struct termios t = g_saved_termios;

    t.c_lflag &= ~(ICANON | ECHO | ISIG);
    t.c_cc[VMIN] = 1;
    t.c_cc[VTIME] = 0;

    if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &t) == -1) {
        perror("[x3] tcsetattr raw");
        return 0;
    }

    g_terminal_raw = 1;
    return 1;
}

static void restore_terminal(void)
{
    if (!g_have_saved_termios)
        return;

    while (tcsetattr(STDIN_FILENO, TCSANOW, &g_saved_termios) == -1) {
        if (errno != EINTR) {
            perror("[x3] tcsetattr restore");
            break;
        }
    }
    g_terminal_raw = 0;
}

static void force_terminal_sane(void)
{
    restore_terminal();
    if (!isatty(STDIN_FILENO))
        return;

    struct termios t;
    if (tcgetattr(STDIN_FILENO, &t) == -1)
        return;

    t.c_lflag |= ECHO | ICANON | ISIG;
    tcsetattr(STDIN_FILENO, TCSANOW, &t);
}

static void open_file_manager(const char *path)
{
    setsid();
    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);
    open("/dev/null", O_RDONLY);
    open("/dev/null", O_WRONLY);
    open("/dev/null", O_WRONLY);
    
    const char *fm = getenv("XDG_FILE_MANAGER");
    if (fm) {
        execlp(fm, fm, path, NULL);
    }
    execlp("xdg-open", "xdg-open", path, NULL);
    execlp("thunar", "thunar", path, NULL);
    execlp("nautilus", "nautilus", "--no-desktop", path, NULL);
    execlp("dolphin", "dolphin", path, NULL);
    _exit(1);
}

static void ensure_tmpdir_and_fm(void)
{
    if (g_tmpdir_created && g_child_pid > 0)
        return;

    if (!g_tmpdir_created) {
        strcpy(g_tmpdir, TMP_TEMPLATE);
        if (!mkdtemp(g_tmpdir)) {
            perror("mkdtemp");
            return;
        }
        g_tmpdir_created = 1;
    }

    if (g_child_pid <= 0) {
        g_child_pid = fork();
        if (g_child_pid == 0) {
            setpgid(0, 0);
            open_file_manager(g_tmpdir);
        } else if (g_child_pid < 0) {
            perror("fork");
        } else {
            setpgid(g_child_pid, g_child_pid);
            usleep(500000);
            pid_t min_pid = fork();
            if (min_pid == 0) {
                setsid();
                close(STDIN_FILENO);
                close(STDOUT_FILENO);
                close(STDERR_FILENO);
                open("/dev/null", O_RDONLY);
                open("/dev/null", O_WRONLY);
                open("/dev/null", O_WRONLY);
                execlp("xdotool", "xdotool", "search", "--class", "Thunar", "windowminimize", NULL);
                execlp("xdotool", "xdotool", "search", "--class", "Nautilus", "windowminimize", NULL);
                execlp("xdotool", "xdotool", "search", "--class", "dolphin", "windowminimize", NULL);
                                    execlp("wmctrl", "wmctrl", "-r", g_tmpdir, "-b", "add,hidden", NULL);
                _exit(0);
            }
        }
    }
}

static int copy_file(const char *src, const char *dst)
{
    FILE *in = fopen(src, "rb");
    if (!in) {
        perror(src);
        return 0;
    }

    FILE *out = fopen(dst, "wb");
    if (!out) {
        perror(dst);
        fclose(in);
        return 0;
    }

    char buf[BUF_SIZE];
    size_t n;
    int success = 1;
    
    while ((n = fread(buf, 1, sizeof(buf), in)) > 0) {
        if (fwrite(buf, 1, n, out) != n) {
            perror("fwrite");
            success = 0;
            break;
        }
    }

    if (ferror(in)) {
        perror("fread");
        success = 0;
    }

    fclose(in);
    fclose(out);
    
    if (success) {
        chmod(dst, 0444);
    } else {
        unlink(dst);
    }
    
    return success;
}

static char *unique_dest(const char *base)
{
    char *name = strdup(base);
    if (!name) return NULL;
    
    char *ext = strrchr(name, '.');
    char *path = NULL;
    int n = 1;
    int has_ext = (ext != NULL && ext != name);

    if (has_ext) {
        *ext = '\0';
        char *ext_part = ext + 1;
        if (asprintf(&path, "%s/%s.%s", g_tmpdir, name, ext_part) < 0)
            path = NULL;
    } else {
        if (asprintf(&path, "%s/%s", g_tmpdir, name) < 0)
            path = NULL;
    }

    while (path && access(path, F_OK) == 0) {
        free(path);
        path = NULL;
        if (has_ext) {
            if (asprintf(&path, "%s/%s_%d.%s", g_tmpdir, name, ++n, ext + 1) < 0)
                path = NULL;
        } else {
            if (asprintf(&path, "%s/%s_%d", g_tmpdir, name, ++n) < 0)
                path = NULL;
        }
    }

    free(name);
    return path;
}

static int has_glob(const char *s)
{
    for (; *s; s++)
        if (*s == '*' || *s == '?' || *s == '[')
            return 1;
    return 0;
}

static void free_search_query(search_query_t *q)
{
    for (int i = 0; i < q->pattern_count; i++)
        free(q->patterns[i]);
    for (int i = 0; i < q->keyword_count; i++)
        free(q->keywords[i]);
    for (int i = 0; i < q->or_count; i++)
        free(q->or_patterns[i]);
    for (int i = 0; i < q->exclude_count; i++)
        free(q->exclude_patterns[i]);
    for (int i = 0; i < q->path_keyword_count; i++)
        free(q->path_keywords[i]);
    for (int i = 0; i < q->name_pattern_count; i++)
        free(q->name_patterns[i]);
    for (int i = 0; i < q->ext_count; i++)
        free(q->ext_patterns[i]);
    for (int i = 0; i < q->dir_keyword_count; i++)
        free(q->dir_keywords[i]);
    memset(q, 0, sizeof(*q));
}

static void parse_search_query(const char *input, search_query_t *q)
{
    memset(q, 0, sizeof(*q));
    
    if (!input || !*input)
        return;
    
    char *query = strdup(input);
    if (!query) return;
    
    char *token = query;
    
    while (*token) {
        while (*token && isspace(*token)) token++;
        if (!*token) break;
        
        int is_or = 0;
        int is_exclude = 0;
        
        if (*token == '|') {
            is_or = 1;
            token++;
            while (*token && isspace(*token)) token++;
        } else if (*token == '!') {
            is_exclude = 1;
            token++;
            while (*token && isspace(*token)) token++;
        }
        
        if (!*token) break;
        
        char *start = token;
        while (*token && !isspace(*token) && *token != '|' && *token != '!') token++;
        int len = token - start;
        
        if (len == 0) continue;
        
        char *term = strndup(start, len);
        if (!term) continue;
        
        if (strncmp(term, "path:", 5) == 0) {
            if (q->path_keyword_count < MAX_KEYWORDS) {
                q->path_keywords[q->path_keyword_count++] = strdup(term + 5);
            }
        } else if (strncmp(term, "name:", 5) == 0) {
            if (q->name_pattern_count < MAX_PATTERNS) {
                q->name_patterns[q->name_pattern_count++] = strdup(term + 5);
            }
        } else if (strncmp(term, "ext:", 4) == 0) {
            if (q->ext_count < MAX_PATTERNS) {
                char *ext = term + 4;
                if (*ext == '.') ext++;
                q->ext_patterns[q->ext_count++] = strdup(ext);
            }
        } else if (strncmp(term, "dir:", 4) == 0) {
            if (q->dir_keyword_count < MAX_KEYWORDS) {
                q->dir_keywords[q->dir_keyword_count++] = strdup(term + 4);
            }
        } else if (is_or) {
            if (q->or_count < MAX_PATTERNS) {
                q->or_patterns[q->or_count++] = term;
                term = NULL;
            }
        } else if (is_exclude) {
            if (q->exclude_count < MAX_PATTERNS) {
                q->exclude_patterns[q->exclude_count++] = term;
                term = NULL;
            }
        } else {
            if (has_glob(term)) {
                if (q->pattern_count < MAX_PATTERNS) {
                    q->patterns[q->pattern_count++] = term;
                    term = NULL;
                }
            } else {
                if (q->keyword_count < MAX_KEYWORDS) {
                    q->keywords[q->keyword_count++] = term;
                    term = NULL;
                }
            }
        }
        
        if (term) free(term);
    }
    
    free(query);
}

static int matches_search_query(const char *filename, const char *full_path, search_query_t *q)
{
    if (!q) return 1;
    
    const char *bn = basename((char *)filename);
    int matched = 0;
    int has_conditions = 0;
    
    if (q->pattern_count > 0 || q->keyword_count > 0 || q->name_pattern_count > 0 || 
        q->ext_count > 0 || q->or_count > 0) {
        has_conditions = 1;
    }
    
    if (q->or_count > 0) {
        for (int i = 0; i < q->or_count; i++) {
            if (has_glob(q->or_patterns[i])) {
                if (fnmatch(q->or_patterns[i], bn, FNM_CASEFOLD) == 0) {
                    matched = 1;
                    break;
                }
            } else {
                if (strcasestr(bn, q->or_patterns[i]) != NULL) {
                    matched = 1;
                    break;
                }
            }
        }
    } else {
        matched = 1;
        
        for (int i = 0; i < q->pattern_count; i++) {
            if (fnmatch(q->patterns[i], bn, FNM_CASEFOLD) != 0) {
                matched = 0;
                break;
            }
        }
        
        for (int i = 0; i < q->keyword_count; i++) {
            if (strcasestr(bn, q->keywords[i]) == NULL && 
                strcasestr(full_path, q->keywords[i]) == NULL) {
                matched = 0;
                break;
            }
        }
        
        for (int i = 0; i < q->name_pattern_count; i++) {
            if (has_glob(q->name_patterns[i])) {
                if (fnmatch(q->name_patterns[i], bn, FNM_CASEFOLD) != 0) {
                    matched = 0;
                    break;
                }
            } else {
                if (strcasestr(bn, q->name_patterns[i]) == NULL) {
                    matched = 0;
                    break;
                }
            }
        }
        
        for (int i = 0; i < q->ext_count; i++) {
            const char *ext = strrchr(bn, '.');
            if (!ext || strcasecmp(ext + 1, q->ext_patterns[i]) != 0) {
                matched = 0;
                break;
            }
        }
    }
    
    if (q->path_keyword_count > 0) {
        int path_match = 0;
        for (int i = 0; i < q->path_keyword_count; i++) {
            if (strcasestr(full_path, q->path_keywords[i]) != NULL) {
                path_match = 1;
                break;
            }
        }
        if (!path_match) matched = 0;
    }
    
    if (q->dir_keyword_count > 0) {
        int dir_match = 0;
        char *dir_path = strdup(full_path);
        if (dir_path) {
            char *dir = dirname(dir_path);
            for (int i = 0; i < q->dir_keyword_count; i++) {
                if (strcasestr(dir, q->dir_keywords[i]) != NULL) {
                    dir_match = 1;
                    break;
                }
            }
            free(dir_path);
        }
        if (!dir_match) matched = 0;
    }
    
    if (matched && q->exclude_count > 0) {
        for (int i = 0; i < q->exclude_count; i++) {
            if (has_glob(q->exclude_patterns[i])) {
                if (fnmatch(q->exclude_patterns[i], bn, FNM_CASEFOLD) == 0 ||
                    fnmatch(q->exclude_patterns[i], full_path, FNM_CASEFOLD) == 0) {
                    matched = 0;
                    break;
                }
            } else {
                if (strcasestr(bn, q->exclude_patterns[i]) != NULL ||
                    strcasestr(full_path, q->exclude_patterns[i]) != NULL) {
                    matched = 0;
                    break;
                }
            }
        }
    }
    
    if (!has_conditions) return 1;
    return matched;
}

static void reset_results(void)
{
    for (int i = 0; i < result_count; i++)
        free(results[i]);
    result_count = 0;
    selected = 0;
}

static void collect_non_recursive(const char *pattern)
{
    const char *search_dir = current_dir ? current_dir : g_root;
    DIR *d = opendir(search_dir);
    if (!d) {
        perror(search_dir);
        return;
    }

    search_query_t query;
    parse_search_query(pattern, &query);

    struct dirent *de;
    while ((de = readdir(d)) && result_count < MAX_RESULTS) {
        if (de->d_name[0] == '.')
            continue;

        char *full_path;
        if (asprintf(&full_path, "%s/%s", search_dir, de->d_name) >= 0) {
            if (matches_search_query(de->d_name, full_path, &query)) {
                char *abs_path = realpath(full_path, NULL);
                if (abs_path) {
                    free(full_path);
                    results[result_count++] = abs_path;
                } else {
                    results[result_count++] = full_path;
                }
            } else {
                free(full_path);
            }
        }
    }

    closedir(d);
    free_search_query(&query);
}

static int is_directory(const char *path)
{
    struct stat st;
    if (stat(path, &st) == 0 && S_ISDIR(st.st_mode)) {
        return 1;
    }
    return 0;
}

static void list_directory(const char *dir)
{
    reset_results();
    
    if (current_dir) {
        free(current_dir);
    }
    current_dir = strdup(dir);
    
    collect_non_recursive(NULL);
}

static void navigate_up(void)
{
    if (!current_dir) {
        return;
    }
    
    char *parent = strdup(current_dir);
    if (!parent) return;
    
    char *last_slash = strrchr(parent, '/');
    
    if (last_slash && last_slash != parent) {
        *last_slash = '\0';
        list_directory(parent);
    } else if (last_slash == parent) {
        list_directory(g_root);
    } else {
        list_directory(g_root);
    }
    
    free(parent);
}

static void walk_directory(const char *dir, search_query_t *query)
{
    DIR *d = opendir(dir);
    if (!d) {
        return;
    }
    
    struct dirent *de;
    errno = 0;
    while ((de = readdir(d)) != NULL) {
        if (de->d_name[0] == '.' && 
            (de->d_name[1] == '\0' || (de->d_name[1] == '.' && de->d_name[2] == '\0')))
            continue;
        
        char *full_path;
        size_t dir_len = strlen(dir);
        if (dir_len > 0 && dir[dir_len - 1] == '/') {
            if (asprintf(&full_path, "%.*s%s", (int)(dir_len - 1), dir, de->d_name) < 0)
                continue;
        } else {
            if (asprintf(&full_path, "%s/%s", dir, de->d_name) < 0)
                continue;
        }
        
        struct stat st;
        if (stat(full_path, &st) == 0) {
            if (S_ISREG(st.st_mode)) {
                if (result_count < MAX_RESULTS) {
                    if (matches_search_query(de->d_name, full_path, query)) {
                        char *abs_path = realpath(full_path, NULL);
                        if (abs_path) {
                            results[result_count++] = abs_path;
                        } else {
                            if (full_path[0] == '/') {
                                results[result_count++] = strdup(full_path);
                            } else {
                                char *abs;
                                if (asprintf(&abs, "%s/%s", g_root, full_path) >= 0) {
                                    results[result_count++] = abs;
                                }
                            }
                        }
                    }
                }
            } else if (S_ISDIR(st.st_mode)) {
                walk_directory(full_path, query);
            }
        }
        
        free(full_path);
    }
    
    closedir(d);
}

static void collect_recursive(const char *pattern)
{
    result_count = 0;
    
    struct stat st;
    if (stat(g_root, &st) != 0 || !S_ISDIR(st.st_mode)) {
        return;
    }
    
    size_t root_len = strlen(g_root);
    char *root_clean = (char *)g_root;
    if (root_len > 1 && g_root[root_len - 1] == '/') {
        root_clean = strdup(g_root);
        root_clean[root_len - 1] = '\0';
    }
    
    search_query_t query;
    parse_search_query(pattern, &query);
    
    walk_directory(root_clean, &query);
    
    free_search_query(&query);
    
    if (root_clean != g_root) {
        free(root_clean);
    }
}

static void draw(const char *mode)
{
    printf("\033[2J\033[H");
    const char *dir_display = current_dir ? current_dir : g_root;
    printf("[x3] %s  (↑ ↓ select, → enter dir, ← go back, Enter copy, q quit)\n", mode);
    printf("Path: %s\n\n", dir_display);

    int start = 0;
    int end = result_count;
    int max_lines = 20;
    
    if (result_count > max_lines) {
        if (selected > max_lines / 2) {
            start = selected - max_lines / 2;
            end = start + max_lines;
            if (end > result_count) {
                end = result_count;
                start = end - max_lines;
            }
        } else {
            end = max_lines;
        }
    }

    if (start > 0)
        printf("... (%d more above)\n", start);

    for (int i = start; i < end; i++) {
        const char *marker = (i == selected) ? ">" : " ";
        const char *path = results[i];
        int is_dir = is_directory(path);
        printf("%s %s%s\n", marker, path, is_dir ? "/" : "");
    }

    if (end < result_count)
        printf("... (%d more below)\n", result_count - end);
    
    if (result_count == 0)
        printf("(no results)\n");
}

static void selector(const char *mode)
{
    if (!raw_terminal())
        return;
    draw(mode);

    while (1) {
        char c;
        if (read(STDIN_FILENO, &c, 1) != 1)
            break;

        if (c == 'q' || c == 3) {
            restore_terminal();
            if (c == 3) {
                printf("\n^C\n");
                fflush(stdout);
            }
            if (g_child_pid > 0) {
                killpg(g_child_pid, SIGTERM);
                usleep(200000);
                int status;
                if (waitpid(g_child_pid, &status, WNOHANG) == 0) {
                    killpg(g_child_pid, SIGKILL);
                    waitpid(g_child_pid, NULL, 0);
                }
                g_child_pid = -1;
            }
            break;
        }

        if (c == '\n' && result_count > 0) {
            if (!is_directory(results[selected])) {
                    if (!g_tmpdir_created) {
                        strcpy(g_tmpdir, TMP_TEMPLATE);
                        if (mkdtemp(g_tmpdir)) {
                            g_tmpdir_created = 1;
                        }
                    }
                    
                    if (g_tmpdir_created) {
                        char *dst = unique_dest(basename(results[selected]));
                        if (dst) {
                            if (copy_file(results[selected], dst)) {
                                printf("\n[x3] Copied -> %s\n", basename(dst));
                                
                                if (g_child_pid <= 0) {
                                    g_child_pid = fork();
                                    if (g_child_pid == 0) {
                                        setpgid(0, 0);
                                        open_file_manager(g_tmpdir);
                                    } else if (g_child_pid > 0) {
                                        setpgid(g_child_pid, g_child_pid);
                                        usleep(500000);
                                        pid_t min_pid = fork();
                                        if (min_pid == 0) {
                                            setsid();
                                            close(STDIN_FILENO);
                                            close(STDOUT_FILENO);
                                            close(STDERR_FILENO);
                                            open("/dev/null", O_RDONLY);
                                            open("/dev/null", O_WRONLY);
                                            open("/dev/null", O_WRONLY);
                                            execlp("xdotool", "xdotool", "search", "--class", "Thunar", "windowminimize", NULL);
                                            execlp("xdotool", "xdotool", "search", "--class", "Nautilus", "windowminimize", NULL);
                                            execlp("xdotool", "xdotool", "search", "--class", "dolphin", "windowminimize", NULL);
                                            execlp("wmctrl", "wmctrl", "-r", g_tmpdir, "-b", "add,hidden", NULL);
                                            _exit(0);
                                        }
                                    }
                                }
                            } else {
                                printf("\n[x3] Failed to copy %s\n", basename(results[selected]));
                            }
                            free(dst);
                            sleep(1);
                        }
                    }
                }
        }
        else if (c == 27) {
            char a, b;
            if (read(STDIN_FILENO, &a, 1) != 1) continue;
            if (a != '[') continue;
            if (read(STDIN_FILENO, &b, 1) != 1) continue;

            if (b == 'A' && selected > 0)
                selected--;
            else if (b == 'B' && selected < result_count - 1)
                selected++;
            else if (b == 'C' && result_count > 0) {
                if (is_directory(results[selected])) {
                    list_directory(results[selected]);
                    selected = 0;
                }
            }
            else if (b == 'D') {
                navigate_up();
                selected = 0;
            }
            else if (b == '5' || b == '6') {
                if (read(STDIN_FILENO, &c, 1) != 1) continue;
                if (b == '5' && c == '~' && selected > 0)
                    selected = (selected > 10) ? selected - 10 : 0;
                else if (b == '6' && c == '~' && selected < result_count - 1)
                    selected = (selected < result_count - 11) ? selected + 10 : result_count - 1;
            }
        }

        draw(mode);
    }

    restore_terminal();
}

static int read_line_with_history(char *buf, size_t size)
{
    if (!raw_terminal())
        return 0;
    
    int pos = 0;
    int hist_idx = -1;
    buf[0] = '\0';
    
    printf("\n[x3] / or // (q to exit): ");
    fflush(stdout);
    
    while (1) {
        char c;
        ssize_t n = read(STDIN_FILENO, &c, 1);
        if (n != 1) {
            restore_terminal();
            printf("\n");
            return 0;
        }
        
        if (c == '\n') {
            buf[pos] = '\0';
            restore_terminal();
            printf("\n");
            return 1;
        }
        else if (c == 3) {
            restore_terminal();
            printf("^C\n");
            fflush(stdout);
            return 0;
        }
        else if (c == 4) {
            restore_terminal();
            printf("\n");
            fflush(stdout);
            return 0;
        }
        else if (c == 27) {
            char a = 0, b = 0;
            fd_set readfds;
            struct timeval timeout;
            
            FD_ZERO(&readfds);
            FD_SET(STDIN_FILENO, &readfds);
            timeout.tv_sec = 0;
            timeout.tv_usec = 100000;
            
            if (select(STDIN_FILENO + 1, &readfds, NULL, NULL, &timeout) > 0 && FD_ISSET(STDIN_FILENO, &readfds)) {
                if (read(STDIN_FILENO, &a, 1) == 1 && a == '[') {
                    FD_ZERO(&readfds);
                    FD_SET(STDIN_FILENO, &readfds);
                    timeout.tv_sec = 0;
                    timeout.tv_usec = 100000;
                    
                    if (select(STDIN_FILENO + 1, &readfds, NULL, NULL, &timeout) > 0 && FD_ISSET(STDIN_FILENO, &readfds)) {
                        if (read(STDIN_FILENO, &b, 1) == 1) {
                            if (b == 'A') {
                                if (hist_idx == -1) {
                                    hist_idx = history_count - 1;
                                } else if (hist_idx > 0) {
                                    hist_idx--;
                                }
                                
                                if (hist_idx >= 0 && history[hist_idx]) {
                                    int len = strlen(history[hist_idx]);
                                    printf("\r[x3] / or // (q to exit): %s", history[hist_idx]);
                                    for (int i = len; i < pos; i++) printf(" ");
                                    printf("\r[x3] / or // (q to exit): %s", history[hist_idx]);
                                    fflush(stdout);
                                    strncpy(buf, history[hist_idx], size - 1);
                                    buf[size - 1] = '\0';
                                    pos = len;
                                }
                            }
                            else if (b == 'B') {
                                if (hist_idx >= 0) {
                                    hist_idx++;
                                    if (hist_idx >= history_count) {
                                        hist_idx = -1;
                                        printf("\r[x3] / or // (q to exit): ");
                                        for (int i = 0; i < pos; i++) printf(" ");
                                        printf("\r[x3] / or // (q to exit): ");
                                        fflush(stdout);
                                        buf[0] = '\0';
                                        pos = 0;
                                    } else if (history[hist_idx]) {
                                        int len = strlen(history[hist_idx]);
                                        printf("\r[x3] / or // (q to exit): %s", history[hist_idx]);
                                        for (int i = len; i < pos; i++) printf(" ");
                                        printf("\r[x3] / or // (q to exit): %s", history[hist_idx]);
                                        fflush(stdout);
                                        strncpy(buf, history[hist_idx], size - 1);
                                        buf[size - 1] = '\0';
                                        pos = len;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        else if (c == 127 || c == '\b') {
            if (pos > 0) {
                pos--;
                buf[pos] = '\0';
                printf("\b \b");
                fflush(stdout);
            }
        }
        else if (c >= 32 && c < 127) {
            if (pos < (int)(size - 1)) {
                buf[pos++] = c;
                buf[pos] = '\0';
                printf("%c", c);
                fflush(stdout);
            }
        }
    }
}

static void add_to_history(const char *cmd)
{
    if (!cmd || !*cmd) return;
    
    if (history_count > 0 && history[history_count - 1] && 
        strcmp(history[history_count - 1], cmd) == 0) {
        return;
    }
    
    if (history_count >= MAX_HISTORY) {
        free(history[0]);
        for (int i = 0; i < history_count - 1; i++) {
            history[i] = history[i + 1];
        }
        history_count--;
    }
    
    history[history_count++] = strdup(cmd);
}

static void interactive(void)
{
    char buf[256];

    while (1) {
        if (!read_line_with_history(buf, sizeof(buf)))
            break;

        if (!strcmp(buf, "q")) {
            if (g_child_pid > 0) {
                killpg(g_child_pid, SIGTERM);
                usleep(200000);
                int status;
                if (waitpid(g_child_pid, &status, WNOHANG) == 0) {
                    killpg(g_child_pid, SIGKILL);
                    waitpid(g_child_pid, NULL, 0);
                }
                g_child_pid = -1;
            }
            break;
        }

        if (buf[0]) {
            add_to_history(buf);
        }

        reset_results();
        if (current_dir) {
            free(current_dir);
            current_dir = NULL;
        }

        if (!strncmp(buf, "//", 2)) {
            char *p = buf + 2;
            while (isspace(*p)) p++;
            collect_recursive(p && *p ? p : NULL);
            if (result_count)
                selector(p && *p ? "recursive" : "recursive (all)");
            else
                printf("[x3] No matches found\n");
        }
        else if (buf[0] == '/') {
            char *p = buf + 1;
            while (isspace(*p)) p++;
            collect_non_recursive(p);
            if (result_count)
                selector(p && *p ? "local" : "local (all)");
            else
                printf("[x3] No matches found\n");
        } else if (buf[0]) {
            printf("[x3] Use / to list all, /pattern for local, or //pattern for recursive\n");
        }
    }
    
    restore_terminal();
}

int main(int argc, char *argv[])
{
    save_terminal();

    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = signal_handler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    sigaction(SIGINT,  &sa, NULL);
    sigaction(SIGTERM, &sa, NULL);
    sigaction(SIGHUP,  &sa, NULL);
    sigaction(SIGQUIT, &sa, NULL);

    atexit(cleanup);

    char *cwd = getcwd(NULL, 0);
    if (!cwd) {
        perror("getcwd");
        force_terminal_sane();
        return 1;
    }
    g_root = realpath(cwd, NULL);
    if (!g_root) {
        g_root = cwd;
    } else {
        free(cwd);
    }
    if (g_root && strlen(g_root) > 1 && g_root[strlen(g_root) - 1] == '/') {
        g_root[strlen(g_root) - 1] = '\0';
    }

    if (argc == 2) {
        struct stat st;
        char *rp = realpath(argv[1], NULL);
        if (rp && stat(rp, &st) == 0 && S_ISDIR(st.st_mode)) {
            free(g_root);
            g_root = strdup(rp);

            pid_t pid = fork();
            if (pid == 0) {
                setpgid(0, 0);
                open_file_manager(g_root);
            } else if (pid > 0) {
                g_child_pid = pid;
                setpgid(pid, pid);
            }

            free(rp);
            interactive();
            force_terminal_sane();
            return 0;
        }
        free(rp);
    }

    if (argc == 1) {
        interactive();
        force_terminal_sane();
        return 0;
    }

    for (int i = 1; i < argc; i++) {
        char *rp = realpath(argv[i], NULL);
        if (!rp) continue;

        struct stat st;
        if (stat(rp, &st) == 0 && S_ISREG(st.st_mode)) {
            ensure_tmpdir_and_fm();
            char *dst = unique_dest(basename(rp));
            if (dst) {
                copy_file(rp, dst);
                free(dst);
            }
        }
        free(rp);
    }

    interactive();
    force_terminal_sane();
    return 0;
}
