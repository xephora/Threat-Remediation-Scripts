import re
import sys

script_path = sys.argv[1]
src = open(script_path).read()
V = {}

TOK = [
    ('lit_q',   re.compile(r'"([^"]*)"')),
    ('strid',   re.compile(r'(?:string|character)\s+id\s*\{([0-9,\s]+)\}')),
    ('chr',     re.compile(r'(?:ASCII\s+character|character\s+id)\s+(\d+)')),
    ('qform',   re.compile(r'quoted\s+form\s+of\b')),
    ('var',     re.compile(r'_\w+')),
    ('skip',    re.compile(r'[&()\s,{}]+')),
]

def tokenize(expr):
    i, out = 0, []
    while i < len(expr):
        for kind, rx in TOK:
            m = rx.match(expr, i)
            if not m:
                continue
            i = m.end()
            if kind == 'lit_q':
                out.append(('L', m.group(1)))
            elif kind == 'strid':
                out.append(('L', ''.join(chr(int(x)) for x in re.findall(r'\d+', m.group(1)))))
            elif kind == 'chr':
                out.append(('L', chr(int(m.group(1)))))
            elif kind == 'var':
                out.append(('V', m.group(0)))
            elif kind == 'qform':
                out.append(('Q', None))
            break
        else:
            out.append(('?', expr[i])); i += 1
    return out

def build(expr, resolve_vars=True):
    parts, pend_q = [], False
    for kind, val in tokenize(expr):
        if kind == 'L':
            parts.append(val)
        elif kind == 'Q':
            pend_q = True
        elif kind == 'V':
            v = V.get(val)
            if v is None or not resolve_vars:
                parts.append('${%s}' % val)
            else:
                parts.append(("'"+v+"'") if pend_q else v)
            pend_q = False
        elif kind == '?':
            parts.append(val)
    return ''.join(parts)

print('='*70, '\nSTRING / LIST CONSTANTS\n', '='*70, sep='')
for line in src.splitlines():
    line = line.strip()
    m = re.match(r'(?:set|property)\s+(_\w+)\s*(?:to|:)\s+(.*)$', line)
    if not m:
        continue
    name, expr = m.group(1), m.group(2)
    if expr.lstrip().startswith('{') and 'string id' in expr:
        elems = re.findall(r'(?:\(string id \{[0-9,\s]+\})\)|\((?:[^()]|\([^()]*\))*\)', expr)
        vals = [build(e) for e in elems]
        V[name] = vals
        print(f'\n{name}  (list, {len(vals)} entries):')
        for v in vals:
            print('   -', v)
    elif 'do shell script' in expr:
        V[name] = build(expr.split('do shell script', 1)[1])
    elif re.search(r'character id|string id|"', expr):
        V[name] = build(expr)
        print(f'\n{name} = {V[name]}')

print('\n'+'='*70, '\nRECONSTRUCTED SHELL COMMANDS\n', '='*70, sep='')
for line in src.splitlines():
    line = line.strip()
    m = re.match(r'(?:set\s+(_\w+)\s+to\s+)?do shell script\s+(.*)$', line)
    if not m:
        continue
    name, expr = m.group(1), m.group(2)
    if re.fullmatch(r'_\w+', expr.strip()):
        cmd = V.get(expr.strip(), '')
    else:
        cmd = build(expr)
    if name:
        V[name] = cmd
    print(f'\n--- {"stage-1 (loop over RPC hosts)" if name else "stage-2 (executed)"} ---')
    print(cmd)
