#!/usr/bin/env python3
import argparse
import pathlib
import shlex
import subprocess
import sys


ROOT = pathlib.Path(__file__).resolve().parent
CONFIG_FILE = ROOT / "pytorch-stack.env"
CONSTRAINTS_FILE = ROOT / "pytorch-constraints.txt"

STACK_PACKAGES = {
    "TORCH_VERSION": "torch",
    "TORCHVISION_VERSION": "torchvision",
    "TORCHAUDIO_VERSION": "torchaudio",
}


def load_config() -> dict[str, str]:
    config: dict[str, str] = {}
    for line_number, raw_line in enumerate(CONFIG_FILE.read_text().splitlines(), start=1):
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue

        key, separator, value = line.partition("=")
        if not separator:
            raise SystemExit(f"{CONFIG_FILE}:{line_number}: expected KEY=VALUE")
        config[key.strip()] = value.strip().strip("'\"")

    required_keys = {
        "PYTORCH_CUDA_INDEX_URL",
        "PYTORCH_CUDA_VERSION",
        *STACK_PACKAGES.keys(),
    }
    missing_keys = sorted(required_keys - config.keys())
    if missing_keys:
        raise SystemExit(f"{CONFIG_FILE}: missing keys: {', '.join(missing_keys)}")

    return config


def pinned_requirements(config: dict[str, str]) -> list[str]:
    return [
        f"{package_name}=={config[version_key]}"
        for version_key, package_name in STACK_PACKAGES.items()
    ]


def write_constraints(config: dict[str, str]) -> pathlib.Path:
    CONSTRAINTS_FILE.write_text("\n".join(pinned_requirements(config)) + "\n")
    return CONSTRAINTS_FILE


def run_pip(args: list[str]) -> None:
    command = [sys.executable, "-m", "pip", "install", "--no-cache-dir", *args]
    print("$ " + " ".join(shlex.quote(part) for part in command), flush=True)
    subprocess.check_call(command)


def install_stack(config: dict[str, str]) -> None:
    write_constraints(config)
    run_pip([
        "--extra-index-url",
        config["PYTORCH_CUDA_INDEX_URL"],
        *pinned_requirements(config),
    ])


def install_requirements(config: dict[str, str], requirement_files: list[str]) -> None:
    constraints_file = write_constraints(config)
    for requirement_file in requirement_files:
        run_pip([
            "--extra-index-url",
            config["PYTORCH_CUDA_INDEX_URL"],
            "--constraint",
            str(constraints_file),
            "-r",
            requirement_file,
        ])


def verify_stack(config: dict[str, str]) -> None:
    import torch
    import torchvision
    import torchaudio

    print("torch", torch.__version__, torch.version.cuda)
    print("torchvision", torchvision.__version__)
    print("torchaudio", torchaudio.__version__)

    expected = {
        "torch": config["TORCH_VERSION"],
        "torch CUDA": config["PYTORCH_CUDA_VERSION"],
        "torchvision": config["TORCHVISION_VERSION"],
        "torchaudio": config["TORCHAUDIO_VERSION"],
    }
    actual = {
        "torch": torch.__version__,
        "torch CUDA": torch.version.cuda,
        "torchvision": torchvision.__version__,
        "torchaudio": torchaudio.__version__,
    }

    mismatches = [
        f"{name}: expected {expected[name]}, got {actual[name]}"
        for name in expected
        if actual[name] != expected[name]
    ]
    if mismatches:
        raise SystemExit("PyTorch stack mismatch:\n" + "\n".join(mismatches))


def main() -> None:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("install-stack")

    requirements_parser = subparsers.add_parser("requirements")
    requirements_parser.add_argument("requirement_files", nargs="+")

    subparsers.add_parser("verify")
    args = parser.parse_args()

    config = load_config()
    if args.command == "install-stack":
        install_stack(config)
    elif args.command == "requirements":
        install_requirements(config, args.requirement_files)
    elif args.command == "verify":
        verify_stack(config)


if __name__ == "__main__":
    main()
