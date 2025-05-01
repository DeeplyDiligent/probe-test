@description('Name of the AKS cluster')
param aksClusterName string

@description('Name of the resource group')
param resourceGroupName string

@description('Location for all resources')
param location string = resourceGroup().location

@description('Name of the container registry')
param acrName string

@description('Name of the application image')
param appImageName string

@description('Tag of the application image')
param appImageTag string

resource aksCluster 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: aksClusterName
  location: location
  properties: {
    kubernetesVersion: '1.20.7'
    dnsPrefix: aksClusterName
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: 'azureuser'
      ssh: {
        publicKeys: [
          {
            keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCy...'
          }
        ]
      }
    }
    servicePrincipalProfile: {
      clientId: 'your-client-id'
      secret: 'your-client-secret'
    }
    networkProfile: {
      networkPlugin: 'azure'
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
    }
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource acrRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(acr.id, 'acrpull')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalId: aksCluster.identityProfile.kubeletidentity.objectId
  }
}

resource appDeployment 'Microsoft.Resources/deployments@2021-04-01' = {
  name: 'appDeployment'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: [
        {
          apiVersion: 'apps/v1'
          kind: 'Deployment'
          metadata: {
            name: 'probe-tester'
          }
          spec: {
            replicas: 1
            selector: {
              matchLabels: {
                app: 'probe-tester'
              }
            }
            template: {
              metadata: {
                labels: {
                  app: 'probe-tester'
                }
              }
              spec: {
                containers: [
                  {
                    name: 'probe-tester'
                    image: '${acrName}.azurecr.io/${appImageName}:${appImageTag}'
                    ports: [
                      {
                        containerPort: 8080
                      }
                    ]
                    livenessProbe: {
                      httpGet: {
                        path: '/liveness'
                        port: 8080
                      }
                      initialDelaySeconds: 10
                      periodSeconds: 10
                    }
                    readinessProbe: {
                      httpGet: {
                        path: '/readiness'
                        port: 8080
                      }
                      initialDelaySeconds: 5
                      periodSeconds: 10
                    }
                    startupProbe: {
                      httpGet: {
                        path: '/startup'
                        port: 8080
                      }
                      failureThreshold: 60
                      periodSeconds: 1
                    }
                  }
                ]
              }
            }
          }
        }
      ]
    }
  }
}
