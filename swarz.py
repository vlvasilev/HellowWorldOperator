import kopf
import os
from kubernetes import client, config

@kopf.on.startup()
def startup_handler(logger: kopf.Logger, **kwargs):
    logger.info("Hello World!")
    print("Hello, World!") # does not print anything in container 

@kopf.on.startup()
def configure(**kwargs) -> None:
    try:
        kubeconfig_path = os.environ["KUBECONFIG"]
        config.load_kube_config(config_file=kubeconfig_path)
    except KeyError:
        config.load_incluster_config()

@kopf.on.update('interview.swarz.com', 'v1alpha1', 'helloworlds')
@kopf.on.create('interview.swarz.com', 'v1alpha1', 'helloworlds')
def reconcile_handler(body, **kwargs):
    api_client = client.ApiClient()
    custom_api = client.CustomObjectsApi(api_client)

    name = body['metadata']['name']
    namespace = body['metadata']['namespace']
    greeting_name = body['spec']['name']

    # Update the status subresource of the custom resource with the desired value
    patch = {'status': {'message': f'Hello {greeting_name}!'}}
    custom_api.patch_namespaced_custom_object_status(
        group='interview.swarz.com',
        version='v1alpha1',
        namespace=namespace,
        plural='helloworlds',
        name=name,
        body=patch
    )


@kopf.on.delete('interview.swarz.com', 'v1alpha1', 'helloworlds')
def delete_handler(spec, **kwargs):
    greeting_name = spec['name']

    logger = kwargs['logger']
    logger.info(f'Bey bey, {greeting_name}!')
    print(f'Bey bey, {greeting_name}!') # does not print anything in container