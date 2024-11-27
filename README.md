# Ansible Tests

This repository contains utilities to manage and interact with containerized nodes using Ansible for testing purposes.

## Getting Started

### 1. Install Dependencies

Ensure that you have `poetry` installed. If not, you can install it from [Poetry's official site](https://python-poetry.org/docs/#installation).

Then, install the required dependencies by running:

```bash
# Install the necessary dependencies defined in pyproject.toml
poetry install
```

### 2. Enter the Virtual Environment

Once the dependencies are installed, enter the virtual environment:

```bash
# Activate the virtual environment
poetry shell
```

### 3. Make the Container Utility Executable

Next, make the `container` utility script executable:

```bash
# Give execute permissions to the container utility
chmod +x container
```

### 4. Check the Container Utility Usage

To see the available commands and options, run the `container` utility:

```bash
# Display the usage of the container utility
./container
```

### 5. Create Your First Node

Now, create your first containerized node (named `node_a`) using Docker and set it to listen on port `2222` with the `ubuntu:22.04` image:

```bash
# Create a node (node_a) on port 2222 using the Docker engine
./container create --docker --image ubuntu:22.04 --port 2222 --name node_a
```

### 6. Run an Ad-Hoc Ansible Ping Test

After the node is created, you can use Ansible to test connectivity. Run an ad-hoc `ping` command to verify that Ansible can communicate with the container:

```bash
# Run an ad-hoc ping to the local node via Ansible
ansible -i .tmp/inventory.ini local -m ping
```

This command will attempt to ping the `local` host group (all nodes created with the `container` utility) defined in your `.tmp/inventory.ini` file.

---

### Additional Notes

- **Docker Engine**: The script assumes that Docker (or Podman) is installed and running. If you're using Podman, simply substitute `--docker` with `--podman`.
- **Ansible Inventory**: The `.tmp/inventory.ini` file is generated dynamically by the container utility. It is used by Ansible to access the containerized nodes.
- **SSH Keys**: Ensure you have the correct SSH keys in place if you intend to use them for connecting to your containers.

For any issues, feel free to open an issue on the repository or check the utility's help command.
