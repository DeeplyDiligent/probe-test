# Probe Tester App

## Folder Structure

The folder structure of the project is organized as follows:

```
* `src/`
  * `api/`
    * `controllers/`
      * `liveness_controller.py`
      * `readiness_controller.py`
      * `startup_controller.py`
      * `home_controller.py`
    * `models/`
    * `services/`
    * `utils/`
  * `config/`
    * `config.py`
  * `tests/`
    * `test_controllers.py`
* `docker/`
  * `Dockerfile`
  * `docker-compose.yaml`
* `docs/`
  * `readme.md`
* `scripts/`
  * `deploy.sh`
  * `setup.sh`
* `requirements.txt`
* `setup.py`
```

## Instructions

### Using the New Folder Structure

1. Navigate to the `src/api/controllers` directory to find the controller files for the application.
2. The `liveness_controller.py`, `readiness_controller.py`, `startup_controller.py`, and `home_controller.py` files contain the respective route handlers.
3. The `config` directory contains the configuration settings for the Flask app.
4. The `tests` directory contains the unit tests for the controllers.
5. The `docker` directory contains the Docker configuration files.
6. The `iac` directory contains the Bicep code to deploy the app to Azure AKS.

### Deploying the App Using Bicep Code

1. Ensure you have the Azure CLI and Bicep CLI installed on your machine.
2. Navigate to the `iac` directory.
3. Run the following command to deploy the Bicep code:

```sh
az deployment group create --resource-group <resource-group-name> --template-file main.bicep --parameters aksClusterName=<aks-cluster-name> acrName=<acr-name> appImageName=<app-image-name> appImageTag=<app-image-tag>
```

4. The command will create an Azure AKS cluster, an Azure Container Registry, and deploy the app to the AKS cluster.
5. Once the deployment is complete, you can access the app using the external IP address of the AKS cluster.
