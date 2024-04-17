import os
import shutil
import repo_commits

from pathlib import PurePath

def make_snapshot(repo_path, commit_id, subfolder, destination_folder, extensions):    
    
    """
    Copies files from a given source folder filtered by given extensions.
    """
    # Check if the destination folder exists, if not, create it
    
    if commit_id:
        print(f'Checking out commit {commit_id}')
        repo_commits.checkout(repo_path, commit_id)
        
    commit = repo_commits.retrieve_current_commit(repo_path)
    
    destination_folder = os.path.join(destination_folder, commit.hash)

    if os.path.exists(destination_folder):
        shutil.rmtree(destination_folder)

    os.makedirs(destination_folder)
    
    # Walk through the source folder
    for root, dirs, files in os.walk(repo_path):
        # Create the corresponding directory structure in the destination folder
        relative_path = os.path.relpath(root, repo_path)
        destination_path = os.path.join(destination_folder, relative_path)        
        
        # Copy files with specified extensions to the destination folder
        for file in files:
            if file.endswith(tuple(extensions)): 
                pp = PurePath(relative_path)
                if pp.is_relative_to(subfolder):
                    #print(os.path.join(root, file))
                
                    source_file_path = os.path.join(root, file)
                    destination_file_path = os.path.join(destination_path, file)

                    os.makedirs(os.path.dirname(destination_file_path), exist_ok=True)
                    shutil.copy(source_file_path, destination_file_path)


if __name__ == '__main__':
    make_snapshot('C:\Data\Repos\Thrive', 'src', 'C:\Data\Snapshots', ['.cs'])