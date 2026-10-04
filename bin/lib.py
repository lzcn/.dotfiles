"""Shared CLI boundary for Python utilities (Python 3.9+, standard library only)."""
import os
from pathlib import Path
import shutil
import subprocess
import sys


class CommandError(Exception):
    """An operational failure suitable for a concise CLI error."""


def require_command(name):
    if not shutil.which(name):
        raise CommandError(f"{name} is required but not installed")


def capture(args, *, env=None):
    result = subprocess.run(args, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=env)
    if result.returncode:
        raise CommandError(result.stderr.strip() or f"{args[0]} exited {result.returncode}")
    return result.stdout


def readable_file(value):
    path = Path(value).expanduser()
    if not path.is_file() or not os.access(path, os.R_OK):
        raise CommandError(f"File not readable: {path}")
    return path


def cli(main):
    try:
        return main() or 0
    except BrokenPipeError:
        return 0
    except (CommandError, OSError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        print("Cancelled", file=sys.stderr)
        return 130
