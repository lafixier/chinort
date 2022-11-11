#!/usr/bin/env python3
import glob
import subprocess


def main() -> None:
    nim_files = glob.glob('./**/*.nim', recursive=True)
    for nim_file in nim_files:
        subprocess.run(["nimpretty", nim_file])
        print(f"[*] nim_fmt.py: formatted '{nim_file}'")


if __name__ == "__main__":
    main()
