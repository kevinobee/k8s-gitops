# Automation Scripts

The bash shell scripts in this folder will help you get started running the repository applications in a local Kubernetes cluster.

## Getting Started

To build a Kubernetes cluster and run the applications in the `apps` folder perform the following steps:

1. Install the required CLI tools by running the [./install-cli-tools.sh](./install-cli-tools.sh) script

1. Create a local Kubernetes Cluster

    Run the [./create-kind-cluster.sh](./create-kind-cluster.sh) script to create the cluster.

    This script uses the [Kind](https://kind.sigs.k8s.io/) tool, which offers a simple way of creating a local Kubernetes cluster with only a single dependency on Docker.

1. Install the applications by running the [./install-apps.sh](./install-apps.sh) script

Your cluster and applications are now running, time to start developing.
