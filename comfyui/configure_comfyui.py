#!/usr/bin/env python3
import argparse
import pathlib


def replace_once(path: pathlib.Path, old: str, new: str) -> None:
    text = path.read_text()
    if old not in text:
        raise SystemExit(f"Expected text not found in {path}: {old!r}")
    path.write_text(text.replace(old, new, 1))


def replace_database_path(cli_args: pathlib.Path) -> None:
    text = cli_args.read_text()
    start = text.find("database_default_path = os.path.abspath(\n")
    if start == -1:
        raise SystemExit(f"Expected database_default_path block not found in {cli_args}")

    end = text.find("\n)", start)
    if end == -1:
        raise SystemExit(f"Expected database_default_path block terminator not found in {cli_args}")

    end += len("\n)")
    text = text[:start] + 'database_default_path = "/data/user/comfyui.db"' + text[end:]
    cli_args.write_text(text)


def configure(app_dir: pathlib.Path) -> None:
    cli_args = app_dir / "comfy" / "cli_args.py"
    folder_paths = app_dir / "folder_paths.py"

    replace_once(cli_args, 'default="127.0.0.1"', 'default="0.0.0.0"')
    replace_once(
        folder_paths,
        "base_path = os.path.dirname(os.path.realpath(__file__))",
        'base_path = "/data"',
    )
    replace_database_path(cli_args)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("app_dir", type=pathlib.Path)
    args = parser.parse_args()

    configure(args.app_dir)


if __name__ == "__main__":
    main()
