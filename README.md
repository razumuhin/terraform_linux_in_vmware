# terraform_linux_in_vmware from template
create linux vm in vmware via terraform
You can create new machines on separate inventory by working with workspace.
note: Make sure you have created the workspace before running the terrafom code.

In this project, using a linux template server in our vmware virtualization platform, multiple workspaces can be created via terraform.
A sample template has been prepared for you to create virtual servers.
If you wish, you can also work in a single workspace.
all you have to do is edit the terraform.tfvars file according to your environment.

NOTE: In the prepared scenario, a user named "template" was created and its password was set as :123456Aa.
then create a new user for system security and generate ssh-keygen for this user and use this public key and enter your terraform.tfvar file


