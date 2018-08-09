# Path on remote server to download any files (e.g., for configuration)
# Usually something like `/home/ubuntu/downloads`
# @TODO: remote_download_path="${env.REMOTE_DOWNLOADS_PATH}"
# (https://github.com/hashicorp/terraform/issues/1930)
remote_download_path="/home/ubuntu/downloads"

# Path of pem file, which holds private key for ssh
pem_file_path="~/.ssh/john-oneill-IAM-keypair.pem"
