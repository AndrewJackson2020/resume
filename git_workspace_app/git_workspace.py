#!/usr/bin/env python

import click
import toml
import tomllib
import pathlib
import subprocess


def _get_git_remotes(repo_name: str) -> list:
    p = subprocess.run(["git", "remote"], stdout=subprocess.PIPE, cwd=repo_name, check=True)
    return p.stdout.decode().strip().split("\n")


def _get_git_remote_url(repo_name: str, remote_name: str) -> str:
    p = subprocess.run(["git", "remote", "get-url", remote_name], stdout=subprocess.PIPE, cwd=repo_name, check=True)
    return p.stdout.decode().strip()


def _remove_git_remote(git_remote: str, repo_name: str) -> None:
    _ = subprocess.run(
            ["git", "remote", "remove", git_remote], 
            stdout=subprocess.PIPE, cwd=repo_name, check=True)

def _git_checkout(repo_name: str, branch_name: str) -> None:
    _ = subprocess.run(
            ["git", "checkout", branch_name], 
            stdout=subprocess.PIPE, cwd=repo_name + "/" + branch_name, check=True)

def _add_checkout_null(repo_name: str) -> None:
    subprocess.run("git checkout $(git commit-tree $(git hash-object -t tree /dev/null) < /dev/null)", shell=True, cwd=repo_name, check=True)

def _add_git_remote(repo_name: str, name: str, url: str) -> None:
    p = subprocess.run(
            ["git", "remote", "add", name, url],
            cwd=repo_name, check=True)


def _remove_git_worktree(repo_name: str, worktree: str) -> None:
    p = subprocess.run(
            ["git", "worktree", "remove", worktree],
            cwd=repo_name, check=True)


def _add_git_worktree(repo_name: str, directory: str, branch: str) -> None:
    _ = subprocess.run(
            ["git", "worktree", "add", directory, branch],
            cwd=repo_name, check=True)


def _git_fetch(repo_name: str) -> None:
    _ = subprocess.run(
            ["git", "fetch", "-a"],
            cwd=repo_name, check=True)


# TODO Convert to use specified type
def _git_worktree_list(repo_name: str) -> dict:

    p = subprocess.run(
            ["git", "worktree", "list", "--porcelain"],
            stdout=subprocess.PIPE, cwd=repo_name, check=True)
    stdout = p.stdout.decode()
    worktrees = {}
    for worktree_stdout in stdout.split('\n\n'):
        worktree_list = worktree_stdout.split("\n")
        if len(worktree_list) <= 2 or "detached" in worktree_list[2]:
            continue
        worktree_path = worktree_list[0].split(" ")[-1]
        branch = worktree_list[2].split(" ")[1].split("/")[-1]
        worktrees[worktree_path] = branch

    return worktrees
        


@click.group()
def main():
    pass


@main.command('apply')
def apply():
    """
    Apply configured repos to current working directory.
    """

    with open("git_workspace.toml", "rb") as f:
        repos = tomllib.load(f)

    for repo_name, repo_attributes in repos.items():

        repo_folder = pathlib.Path(repo_name)
        if not repo_folder.exists():
            repo_folder.mkdir()
        
        git_folder = repo_folder / ".git"
        if not git_folder.exists():
            subprocess.run(["git", "init"], cwd=repo_name, check=True)

        actual_git_remotes = _get_git_remotes(repo_name=repo_name)
        expected_git_remotes = [i["name"] for i in repo_attributes["remote"]]
        for actual_git_remote in actual_git_remotes:
            if actual_git_remote in expected_git_remotes and actual_git_remote:
                _remove_git_remote(
                        git_remote=actual_git_remote, repo_name=repo_name)

        actual_git_remotes = _get_git_remotes(repo_name=repo_name)
        for remote in repo_attributes["remote"]:
            if remote["name"] in actual_git_remotes:
                continue
            _add_git_remote(repo_name, remote["name"], remote["url"])

        _git_fetch(repo_name=repo_name)

        _add_checkout_null(repo_name=repo_name)

        actual_worktrees = _git_worktree_list(repo_name=repo_name)
        expected_worktree_paths = [i["name"] for i in repo_attributes["worktree"]]
        for actual_worktree_path, actual_worktree_branch in actual_worktrees.items():
            if actual_worktree_path in expected_worktree_paths:
               continue 

            _remove_git_worktree(repo_name=repo_name, worktree=actual_worktree_path)

        for expected_worktree in repo_attributes["worktree"]:
            if expected_worktree["name"] in actual_worktrees.keys():
                pass
            _add_git_worktree(repo_name=repo_name, directory=expected_worktree["name"], branch=expected_worktree["ref"])

        actual_worktrees = _git_worktree_list(repo_name=repo_name)
        for expected_worktree in repo_attributes["worktree"]:
            if expected_worktree["ref"] == actual_worktrees[str(pathlib.Path.cwd() / repo_name / expected_worktree["name"])]:
                continue
            _git_checkout(repo_name=repo_name, worktree_name=expected_worktree["name"], worktree_ref=expected_worktree["ref"])

            

@main.command('freeze')
def freeze():
    """
    TODO write function that saves state of current repos and workspaces
    """
    folders = [i for i in pathlib.Path(".").glob("*") if i.is_dir()]
    repos = {}
    for folder in folders:
        folder_str = str(folder)
        if not (folder / ".git").exists():
            continue

        repos[folder_str] = {"remote": [], "worktree": []}

        remotes = _get_git_remotes(repo_name=folder_str)
        for remote in remotes:
            repos[folder_str]["remote"].append({"name": remote, "url": _get_git_remote_url(repo_name=folder_str, remote_name=remote)})

        worktrees = _git_worktree_list(repo_name=folder_str)
        for worktree, ref in worktrees.items():
            repos[folder_str]["worktree"].append({"name": worktree.split("/")[-1], "ref": ref})

    toml_string = toml.dumps(repos)  # Output to a string
    click.echo(toml_string)


if __name__ == '__main__':
    main()
