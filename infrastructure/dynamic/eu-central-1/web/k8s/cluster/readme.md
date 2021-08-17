#### Creating SSH Key for the nodes ####

* Use `ssh-keygen -t rsa`
* Name key files as `./key` without passphrase
* Remove the old key files
* rename the `key` and `key.pub` files as
* `sshkey` and `sshkey.pub` respectively

_Note_: Do not remove the key file unless you destroy the cluster and would like to re-new SSH key. It can not be changed after the creation of the infrastructure.