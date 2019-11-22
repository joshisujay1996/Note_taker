add subnet id or vpc if necessary


# Run using command

packer build \
    -var 'aws_access_key=your_aws_access_key' \
    -var 'aws_secret_key=your_aws_secret_key' \
nodejs_ami_.json