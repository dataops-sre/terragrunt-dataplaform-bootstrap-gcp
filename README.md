# Data platform terragrunt bootstrap on GCP

This repository bootstrap a scalable Managed Kubernetes cluster on GCP with terragrunt

It supports spot instances and autoscales regarding cluster loads 

## Components

Infrastructure components:

* [terraform-google-gke](https://github.com/gruntwork-io/terraform-google-gke)
* [Kubernetes Provider for Terraform](https://github.com/hashicorp/terraform-provider-kubernetes)
* [Helm Provider for Terraform](https://github.com/hashicorp/terraform-provider-helm/)
* [cluster-autoscaler](https://github.com/kubernetes/autoscaler)

Software components:

* Ingress controller: [traefik](https://github.com/traefik/traefik)
* Airflow scheduler: [airflow](https://github.com/apache/airflow)

## How to use

The project use the standard terragrunt project structure, detailed explication [here](https://blog.gruntwork.io/terragrunt-how-to-keep-your-terraform-code-dry-and-maintainable-f61ae06959d8).

Following steps suppose you start brand new project on GCP, thus include parts to create service account and enable services

Manual steps: 

1) login in to GCP `gcloud auth login`
2) create new project and service account
```bash
gcloud projects create gke-terragrunt-demo
gcloud config set project gke-terragrunt-demo
gcloud iam service-accounts create terragrunt-sa --display-name="Terragrunt service account"
gcloud projects add-iam-policy-binding gke-terragrunt-demo --member='serviceAccount:terragrunt-sa@gke-terragrunt-demo.iam.gserviceaccount.com' --role='roles/admin'
gcloud iam service-accounts keys create ~/.gcloud/key.json --iam-account=terragrunt-sa@gke-terragrunt-demo.iam.gserviceaccount.com
gcloud auth activate-service-account --key-file ~/.gcloud/key.json
#need to enable billong manually
gcloud services enable cloudresourcemanager.googleapis.com --project gke-terragrunt-demo
gcloud services enable container.googleapis.com --project gke-terragrunt-demo

```
3) run `task run-image` mount code base into a terragrunt image
4) run `terragrunt apply-all` in `/mnt/infrastructure-live` you will have a Kubernetes cluster with name `gke-on-vpc-cluster` ready in less than 10 minutes and it will deploy additional tools such as `cluster-autoscaler`, `spot-instance-handler`, `ingress controller` and `airflow`

```bash
❯ task run-image
task: docker run -it -v `pwd`:/mnt -w="/mnt"  -v ~/.gcloud/:/root/.gcloud/  -e GOOGLE_APPLICATION_CREDENTIALS="root/.gcloud/key.json"  --user=root --rm alpine/terragrunt:$TERRAGRUNT_VERSION bash
bash-5.0# pwd
/mnt/infrastructure-live
bash-5.0# terragrunt apply-all
...

module.gke.random_string.cluster_service_account_suffix: Creating...
module.gcp-network.module.vpc.google_compute_network.network: Creating...
module.gke.random_string.cluster_service_account_suffix: Creation complete after 0s [id=q8gy]
module.gke.random_shuffle.available_zones: Creating...
module.gke.random_shuffle.available_zones: Creation complete after 0s [id=-]

Apply complete! Resources: 12 added, 0 changed, 0 destroyed.
...
...
terragrunt-dataplaform-bootstrap (git)-[main] % aws eks --region eu-west-2 update-kubeconfig --name test-eks-irsa --role-arn "arn:aws:iam::xxxxxx:role/xxxxxx"
$terragrunt-dataplaform-bootstrap (git)-[main] % kubectl get pod -n kube-system
NAME                                                        READY   STATUS    RESTARTS   AGE
aws-node-rtts8                                              1/1     Running   0          2m46s
aws-node-z9sg4                                              1/1     Running   0          2m42s
cluster-autoscaler-aws-cluster-autoscaler-5bd88ccc8-x6nkn   1/1     Running   0          88s
coredns-6ddcfb5bcf-6lm5q                                    1/1     Running   0          6m42s
coredns-6ddcfb5bcf-hff8c                                    1/1     Running   0          6m42s
kube-proxy-9vh9l                                            1/1     Running   0          2m46s
kube-proxy-cwtfr                                            1/1     Running   0          2m42s
spot-handler-k8s-spot-termination-handler-jbwfl             1/1     Running   0          93s
spot-handler-k8s-spot-termination-handler-lhrzf             1/1     Running   0          93s
traefik-ingress-controller-d999b849b-z85rr                  1/1     Running   0          84s
$terragrunt-dataplaform-bootstrap (git)-[main] % kubectl get pod -n default
NAME                       READY   STATUS    RESTARTS   AGE
airflow-7fbb8f4b58-2djlc   1/1     Running   0          103s
airflow-postgresql-0       1/1     Running   0          103s
```

Those steps can be further automated in CI/CD pipelines.

## Access to cluster
``` bash
aws eks --region eu-west-2 update-kubeconfig --name test-eks-irsa --role-arn "arn:aws:iam::xxxxxx:role/xxxxxx"  
```
will configure kubernetes access, then you can make kubernetes operations with `kubectl` command

To access to the airflow instance, you can use kubernetes port forwarding
