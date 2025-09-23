import json
import sys
import argparse
from typing import Any, Union

def detect_type(value: Any) -> str:
    if isinstance(value, dict):
        return "object"
    elif isinstance(value, list):
        return "array"
    elif isinstance(value, str):
        try:
            parsed = json.loads(value)
            if isinstance(parsed, dict):
                return "object (escaped JSON)"
            elif isinstance(parsed, list):
                return "array (escaped JSON)"
        except Exception:
            pass
        return "string"
    elif isinstance(value, bool):
        return "boolean"
    elif isinstance(value, (int, float)):
        return "number"
    elif value is None:
        return "null"
    else:
        return type(value).__name__


def try_parse_escaped(value: Any) -> Any:
    if isinstance(value, str):
        try:
            return json.loads(value)
        except Exception:
            return value
    return value


def print_schema(obj: Union[dict, list], indent: str = "", prefix: str = ""):
    if isinstance(obj, dict):
        for i, (key, value) in enumerate(obj.items()):
            branch = "└── " if i == len(obj) - 1 else "├── "
            value_type = detect_type(value)
            print(f"{indent}{branch}{key}: {value_type}")
            new_indent = indent + ("    " if i == len(obj) - 1 else "│   ")
            print_schema(try_parse_escaped(value), new_indent)
    elif isinstance(obj, list) and obj:
        branch = "└── "
        first_type = detect_type(obj[0])
        print(f"{indent}{branch}[array items]: {first_type}")
        new_indent = indent + "    "
        print_schema(try_parse_escaped(obj[0]), new_indent)


def parse_path(obj: Any, path: str, expand_all: bool = False):
    keys = path.split(".")
    current = try_parse_escaped(obj)
    expr_parts = ["json"]

    for idx, key in enumerate(keys):
        if isinstance(current, list):
            if key.isdigit():
                i = int(key)
                expr_parts.append(f"[{i}]")
                current = try_parse_escaped(current[i])
            elif expand_all:
                rest_path = ".".join(keys[idx:])
                results = []
                for i, item in enumerate(current):
                    try:
                        val, expr = parse_path(item, rest_path, expand_all)
                        results.append({
                            "index": i,
                            "value": val,
                            "path": expr_parts[0] + "".join(expr_parts[1:]) + f"[{i}]" + expr[len("json"):]
                        })
                    except KeyError:
                        continue
                return results, f"{''.join(expr_parts)}[*].{rest_path}"
            else:
                raise KeyError(
                    f"Must provide index for array at '{'.'.join(keys[:idx+1])}' (or use --all)."
                )
        elif isinstance(current, dict):
            expr_parts.append(f"['{key}']")
            if key not in current:
                raise KeyError(f"Key '{key}' not found.")
            current = try_parse_escaped(current[key])
        else:
            raise KeyError(f"Path '{key}' not valid (stopped at non-object/list).")

    expr = "".join(expr_parts)
    return current, expr


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="JSON schema introspection tool")
    parser.add_argument("json_file", help="Path to the JSON file")
    parser.add_argument("-p", "--parse", help="Dotted path to extract (e.g., payload.details.ip)")
    parser.add_argument("--all", action="store_true", help="Expand arrays automatically if index not given")

    args = parser.parse_args()

    with open(args.json_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    if args.parse:
        try:
            value, expr = parse_path(data, args.parse, args.all)

            if isinstance(value, list) and args.all:
                print("Results:")
                for item in value:
                    print(f"- Index {item['index']} -> Value: {json.dumps(item['value'], indent=2)}")
                    print(f"  Path: {item['path']}")
            else:
                print(f"Value: {json.dumps(value, indent=2)}")
                print(f"Access Path: {expr}")

        except KeyError as e:
            print(f"[!] Error: {e}")
    else:
        print(f"Schema tree for {args.json_file}:\n")
        print_schema(data)
