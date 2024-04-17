import pandas as pd
import argparse
from time import time
import os
import git

import repo_commits as rc
import repo_snapshot as rs


def pull_or_clone_repo(repo_url, local_path):
    """
    Pull a Git repository if it already exists locally,
    or clone it if it does not exist.
    """
    if os.path.exists(local_path):
        print(f'Pulling from {repo_url} into {local_path}')
        repo = git.Repo(local_path)
        origin = repo.remotes.origin
        origin.pull()
    else:
        print(f'Cloning {repo_url} into {local_path}')
        git.Repo.clone_from(repo_url, local_path)

def main(params):
    #params.commit_hash

    print(f'params: {params}')
    
    repo_dir = os.environ['REPO_DIR']
    repo_url = os.environ['REPO_URL']

    if not params.nopull:
        pull_or_clone_repo(repo_url, repo_dir)

    print (f'Repo dir: {repo_dir}')

    commits = rc.retrieve_commit_history(repo_dir)

    df = pd.DataFrame(commits)
    dir = os.environ['SNAPSHOTS_DIR']

    print (f'Out dir: {dir}')

    os.makedirs(dir, exist_ok=True)
    df.to_csv(os.path.join(dir, 'commit_history.csv'))

    rs.make_snapshot(
        repo_path = repo_dir,
        commit_id = params.commit,
        destination_folder = dir,
        subfolder = '',
        extensions = ['.cs'])
    

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Starting up repo container')

    parser.add_argument('--commit', help='commit hash to write initial snapshot')
    parser.add_argument('--nopull', help='if no pulling/cloning needed', action='store_true')
    
    args = parser.parse_args()


    main(args)