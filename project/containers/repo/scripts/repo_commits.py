import git
import pandas as pd
from collections import namedtuple

CommitShortInfo = namedtuple('CommitShortInfo', ['hash', 'datetime', 'author'])

def get_commit_short_info(gitpython_commit):
    return CommitShortInfo(
        hash = gitpython_commit.hexsha,
        datetime = pd.Timestamp(gitpython_commit.committed_date, unit='s'),
        author = gitpython_commit.author.name
        )    

def retrieve_commit_history(repo_path, start_hash=None):
    """
    Retrieve commit history from a Git repository starting from a given commit hash.
    If start_hash is not specified, retrieve all history.
    """
    
    repo = git.Repo(repo_path)    
    commits = list(repo.iter_commits(rev=start_hash))

    commit_data = []
    for commit in commits:
        commit_data.append(get_commit_short_info(commit))

    return commit_data

def checkout(repo_path, commit_id):
    repo = git.Repo(repo_path)
    repo.git.checkout(commit_id)

def retrieve_current_commit(repo_path):
    repo = git.Repo(repo_path)    
    commit = repo.head.commit
    return get_commit_short_info(commit)

def write_to_parquet(data, output_file):
    """
    Write commit data to a Parquet file.
    """
    df = pd.DataFrame(data)
    df.to_parquet(output_file)

def output_commit_history(repo_path, output_file, start_hash=None):
    commit_data = retrieve_commit_history(repo_path, start_hash)
    write_to_parquet(commit_data, output_file)


# Example usage:
if __name__ == "__main__":
    # Specify the path to the Git repository
    repo_path = 'C:/Data/Repos/Thrive'

    # Specify the start commit hash (optional, set to None to retrieve all history)
    start_hash = None  # Set to None if you want to retrieve all history

    # Retrieve commit history
    commit_data = retrieve_commit_history(repo_path, start_hash)

    df = pd.DataFrame(commit_data)
    print(df.head())

    # Write commit data to a Parquet file
    output_file = 'commit_history.parquet'
    write_to_parquet(commit_data, output_file)
