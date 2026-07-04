

### `terraform/`

* **`provider.tf`**: Sets up AWS and creates a shared backup file (S3) with a lock (DynamoDB) so two people can't change things at the same time.
* **`main.tf`**: The master file that connects and runs all the folders/modules together.
* **`variables.tf`**: The settings file where you can change inputs like AWS region, server sizes, and cluster versions.
* **`outputs.tf`**: Prints out the final results after building, like the cluster login link and network IDs.

### `modules/` (Your custom Lego blocks)

* **`vpc/`**: Builds the network, including the private rooms (subnets) and the internet doorway (NAT gateway).
* **`eks/`**: Builds the Kubernetes brain (control plane) and the worker servers (node group) inside the safe, private network.
* **`ecr/`**: Builds a private storage garage to safely save and scan your Docker container images.
