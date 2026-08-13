#!/usr/bin/env python3
import re
import subprocess
import sys
from pathlib import Path

PATTERN = re.compile(r"<!-- exec: (.+?) -->.*?<!-- endexec -->", re.DOTALL)


def replace(match):
    cmd = match.group(1).strip()
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    output = result.stdout
    if result.returncode != 0:
        print(
            f"[inject-exec] command failed ({result.returncode}): {cmd}",
            file=sys.stderr,
        )
        print(result.stderr, file=sys.stderr)
        sys.exit(1)
    output = re.sub(r"<!-- exec: .+? -->\n?|<!-- endexec -->\n?", "", output)
    if output and not output.endswith("\n"):
        output += "\n"
    return f"<!-- exec: {cmd} -->\n{output}<!-- endexec -->"


def process(path):
    content = Path(path).read_text()
    new_content = PATTERN.sub(replace, content)
    if new_content != content:
        Path(path).write_text(new_content)
        print(f"[inject-exec] updated {path}")


for p in sys.argv[1:]:
    process(p)
