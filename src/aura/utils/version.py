import shutil
import subprocess

from aura.utils.paths import config_dir


def print_version() -> None:
    if shutil.which("pacman"):
        print("Packages:")
        pkgs = ["aura-shell", "aura-cli", "aura-meta"]
        versions = subprocess.run(
            ["pacman", "-Q", *pkgs], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True
        ).stdout

        for pkg in pkgs:
            if pkg not in versions:
                print(f"    {pkg} not installed")
        print("\n".join(f"    {pkg}" for pkg in versions.splitlines()))
    else:
        print("Packages: not on Arch")

    print()
    try:
        aura_dir = (config_dir / "hypr").resolve().parent
        aura_ver = subprocess.check_output(
            ["git", "--git-dir", aura_dir / ".git", "rev-list", "--format=%B", "--max-count=1", "HEAD"], text=True
        )
        print("Aura:")
        print("    Last commit:", aura_ver.split()[1])
        print("    Commit message:", *aura_ver.splitlines()[1:])
    except subprocess.CalledProcessError:
        print("Aura: not installed")

    print()
    try:
        shell_ver = subprocess.check_output(["/usr/lib/aura/version", "-s"], text=True).strip()
        print("Shell:")
        print("    ", shell_ver)
    except FileNotFoundError:
        print("Shell: version helper not available")

    print()
    if shutil.which("qs"):
        print("Quickshell:")
        print("   ", subprocess.check_output(["qs", "--version"], text=True).strip())
    else:
        print("Quickshell: not in PATH")

    local_shell_dir = config_dir / "quickshell/aura"
    if local_shell_dir.exists():
        print("\nLocal copy of shell found:")

        try:
            shell_ver = subprocess.check_output(
                [
                    "git",
                    "--git-dir",
                    local_shell_dir / ".git",
                    "rev-list",
                    "--format=%B",
                    "--max-count=1",
                    "upstream/main",
                ],
                text=True,
                stderr=subprocess.DEVNULL,
            )
            print("    Last merged upstream commit:", shell_ver.split()[1])
            print("    Commit message:", *shell_ver.splitlines()[1:])
        except subprocess.CalledProcessError:
            print("    Unable to determine last merged upstream commit.")

        shell_ver = subprocess.check_output(
            ["git", "--git-dir", local_shell_dir / ".git", "rev-list", "--format=%B", "--max-count=1", "HEAD"],
            text=True,
        )
        print("\n    Last commit:", shell_ver.split()[1])
        print("    Commit message:", *shell_ver.splitlines()[1:])
