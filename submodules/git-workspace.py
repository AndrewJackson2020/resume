#!/usr/bin/env python

import click
import tomllib
import pathlib
import subprocess


@click.group()
def main():
    pass


@main.command('apply')
def apply():
    """
    Apply configured repos to current working directory.
    """

    with open("git-workspace.toml", "rb") as f:
        repos = tomllib.load(f)

    for repo_name, repo_attributes in repos.items():

        repo_folder = pathlib.Path(repo_name)
        if not repo_folder.exists():
            repo_folder.mkdir()
        
        git_folder = repo_folder / ".git"
        if not git_folder.exists():
            subprocess.run(["git", "init"], cwd=repo_name, check=True)

        # TODO Delete remotes not in configured remotes
        p = subprocess.run(["git", "remote"], stdout=subprocess.PIPE, cwd=repo_name, check=True)
        for whatever in p.stdout.decode().strip().split("\n"):
            if whatever not in [i["name"] for i in repo_attributes["remote"]] and whatever:
                p = subprocess.run(
                        ["git", "remote", "remove", whatever], 
                        stdout=subprocess.PIPE, cwd=repo_name, check=True)

        # TODO Add remotes not in actual remotes
        p = subprocess.run(["git", "remote"], stdout=subprocess.PIPE, cwd=repo_name, check=True)
        for remote in repo_attributes["remote"]:
            if remote["name"] in p.stdout.decode():
                continue
            p = subprocess.run(
                    ["git", "remote", "add", remote["name"], remote["url"]], 
                    cwd=repo_name, check=True)

        p = subprocess.run(
                ["git", "fetch", "-a"],
                cwd=repo_name, check=True)

        p = subprocess.run(
                ["git", "worktree", "list", "--porcelain"],
                cwd=repo_name, check=True)

        # TODO Add worktrees if in config
        for worktree in p.stdout.decode().split("\n"):
            worktree_name = worktree.split(" ")
            if worktree_name in [i["name"] for i in repo_attributes["worktree"]]:
               continue 


        print(repo_name, repo_attributes)


@main.command('freeze')
def freeze():
    pass


if __name__ == '__main__':
    main()
