#!/usr/bin/env python

import click
import tomllib
import pathlib
import subprocess


def _get_git_remotes(repo_name: str) -> list:
    p = subprocess.run(["git", "remote"], stdout=subprocess.PIPE, cwd=repo_name, check=True)
    return p.stdout.decode().strip().split("\n")


def _remove_git_remote(git_remote: str, repo_name: str) -> None:
    p = subprocess.run(
            ["git", "remote", "remove", git_remote], 
            stdout=subprocess.PIPE, cwd=repo_name, check=True)


def _add_git_remote(repo_name: str, name: str, url: str) -> None:
    p = subprocess.run(
            ["git", "remote", "add", name, url],
            cwd=repo_name, check=True)


def _git_fetch(repo_name: str) -> None:
    p = subprocess.run(
            ["git", "fetch", "-a"],
            cwd=repo_name, check=True)


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

        actual_worktrees = _git_worktree_list(repo_name=repo_name)

        # TODO Add worktrees if in config
        breakpoint()
        for actual_worktree_path, actual_worktree_branch in actual_worktrees.items():
            if actual_worktree_path in [i["name"] for i in repo_attributes["worktree"]]:
               continue 


        print(repo_name, repo_attributes)


@main.command('freeze')
def freeze():
    """
    TODO write function that saves state of current repos and workspaces
    """


if __name__ == '__main__':
    main()
