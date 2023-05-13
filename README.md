# Hello World Operator

This is a simple operator which watch for `HelloWorld` custom resource objects.
On start prints `Hello World!` both as logging and simple stdout message.

When a `Hello World` resource is created or updated it reads the `name` from the spec, and 
prepends `Hello` to the name, written as message in the status section.

When a `Hello World` resource is delete it prints `Bye bye` `spec.name` both as logging and simple stdout message.

> **Note:** For some reason the `Hello World!` and `Bye bye` messages are not printed as simple messages on the stdout whe the application is run in a container. They are printed only as logging formated messages.

## Prerequisites

In order to play with this operator you have to have:
- [Kubectl tool](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Kopf](https://kopf.readthedocs.io/en/stable/install/)
-  Kubernetes Cluster, for example [Minikube](https://kopf.readthedocs.io/en/stable/minikube/)
- [Make](https://www.gnu.org/software/make/)

## Run the operator locally 

To run the operator on your local machine:
- Export the `KUBECONFIG` file pointing to your K8s cluster.
  ```console
  export KUBECONFIG ~/.kube/config
  ```
- Install the CRD to your K8s cluster.
  ```console
  make install
  ```
- Run the operator.
  ```consoel
  make run
  ```
- On separate console, where `KUBECONFIG` is exported too, deploy the example `HelloWorld`.
  ```console
  kubectl apply -f example.yaml
  ```
- Update the the `HelloWorld` `spec.name`.
  ```console
  kubectl edit helloworlds.interview.swarz.com  helloworld-sample  
  ```
- See the status:
  ```console
  kubectl get helloworlds.interview.swarz.com  helloworld-sample -o yaml
  ```
- Delete the example `HelloWorld`
  ```console
  kubectl delete -f example.yaml
  ```
  Or
  ```console
  kubectl delete helloworlds.interview.swarz.com  helloworld-sample
  ```

## Run the operator in Kubernetes cluster

To run the operator in your Kubernetes cluster:
- Export the `KUBECONFIG` file pointing to your K8s cluster.
  ```console
  export KUBECONFIG ~/.kube/config
  ```
- Install the CRD to your K8s cluster.
  ```console
  make install
  ```
- Deploy the Operator into the K8s cluster.
  ```console
  make deploy
  ```
  The above command will deploy the operator in the default namespace.
  To deploy it in your custom namespace:
  ```console
  make deploy NAMESPACE=<your namespace>
  ```
  If you have deployed the operator image in your specific registry or want to use different image tag:
  ```console
  make deploy NAMESPACE=<your namespace> REGISTRY=<your registry> IMAGE_TAG=<your tag>
  ```
- Deploy the example `HelloWorld`.
  ```console
  kubectl apply -f example.yaml
  ```
- Update the the `HelloWorld` `spec.name`.
  ```console
  kubectl edit helloworlds.interview.swarz.com  helloworld-sample  
  ```
- See the status.
  ```console
  kubectl get helloworlds.interview.swarz.com  helloworld-sample -o yaml
  ```
- Delete the example `HelloWorld`.
  ```console
  kubectl delete -f example.yaml
  ```
  Or
  ```console
  kubectl delete helloworlds.interview.swarz.com  helloworld-sample
  ```
- Clean the operator.
  ```console
  make clean
  ```
  Or
  ```console
  make clean NAMESPACE=<your namespace>
  ```

  ## Building docker image.

- To build the docker image.
  ```console
  make docker-images 
  ```
  Or if you want to change the registry and the tag:
  ```console
  make docker-images REGISTRY=<your registry> IMAGE_TAG=<your tag>
  ```
- To publish the docker image.
  ```console
  docker-push
  ```
  Or if you want to change the registry and the tag:
  ```console
  docker-push REGISTRY=<your registry> IMAGE_TAG=<your tag>
  ```