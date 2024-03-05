from dotnetfile import DotNetPE
import sys

def get_headers(PE):
        return PE

def get_PEstreams(PE):
        return PE.get_resources()

def detect_filetype(PE):
        if PE.is_dll:
                return "[+] Is DLL"
        elif PE.is_exe:
                return "[+] Is EXE"
        else:
                return "[!] Filetype not detected."

def has_entrypoint(PE):
        if PE.has_native_entry_point():
                return "[+] has entrypoint and possible to debug"
        else:
                return "[!] no entrypoint"

def detect_assemblies(PE):
        return PE.Assembly.get_assembly_name()

def detect_sections(PE):
        [print(str(i)+"\n") for i in PE.sections]

if __name__ == "__main__":
        PE = sys.argv[1]
        mode = sys.argv[2]
        dotnet_file = DotNetPE(PE)
        if "detect" in mode:
                print(detect_filetype(dotnet_file))
        elif "resources" in mode:
                print(get_PEstreams(dotnet_file))
        elif "headers" in mode:
                print(get_headers(dotnet_file))
        elif "entrypoint" in mode:
                print(has_entrypoint(dotnet_file))
        elif "assembly" in mode:
                print(detect_assemblies(dotnet_file))
        elif "sections" in mode:
                detect_sections(dotnet_file)
        else:
                print("Usage: script.py file mode\n[*] modes: detect | resources | headers | entrypoint | assembly | sections")
