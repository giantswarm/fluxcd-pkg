# OCI integration test

OCI integration test uses a test application(`testapp/`) to test the
oci package against each of the supported cloud providers.

**NOTE:** Tests in this package aren't run automatically by the `test-*` make
target at the root of `fluxcd/pkg` repo. These tests are more complicated than
the regular go tests as it involves cloud infrastructure and have to be run
explicitly.

Before running the tests, build the test app with `make docker-build` and use
the built container application in the integration test.

The integration test provisions cloud infrastructure in a target provider and
runs the test app as a batch job which tries to log in and list tags from the
test registry repository. A successful job indicates successful test. If the job
fails, the test fails.

Logs of a successful job run:
```console
$ kubectl logs test-job-93tbl-4jp2r
2022/07/28 21:59:06 repo: xxx.dkr.ecr.us-east-2.amazonaws.com/test-repo-flux-test-heroic-ram
1.659045546831094e+09   INFO    logging in to AWS ECR for xxx.dkr.ecr.us-east-2.amazonaws.com/test-repo-flux-test-heroic-ram
2022/07/28 21:59:06 logged in
2022/07/28 21:59:06 tags: [v0.1.4 v0.1.3 v0.1.0 v0.1.2]
```

## Requirements

### Amazon Web Services

- AWS account with access key ID and secret access key with permissions to
    create EKS cluster and ECR repository.
- AWS CLI v2.x, does not need to be configured with the AWS account.
- Docker CLI for registry login.
- kubectl for applying certain install manifests.

### Microsoft Azure

- Azure account with an active subscription to be able to create AKS and ACR,
    and permission to assign roles. Role assignment is required for allowing AKS
    workloads to access ACR.
- Azure CLI, need to be logged in using `az login` as a User (not a Service
  Principal).

  **NOTE:** To use Service Principal (for example in CI environment), set the
  `ARM-*` variables in `.env`, source it and authenticate Azure CLI with:
  ```console
  $ az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
  ```
  In this case, the AzureRM client in terraform uses the Service Principal to
  authenticate and the Azure CLI is used only for authenticating with ACR for
  logging in and pushing container images. Attempting to authenticate terraform
  using Azure CLI with Service Principal results in the following error:
  > Authenticating using the Azure CLI is only supported as a User (not a Service Principal).
- Docker CLI for registry login.
- kubectl for applying certain install manifests.

#### Permissions

Following permissions are needed for provisioning the infrastructure and running
the tests:
- `Microsoft.Kubernetes/*`
- `Microsoft.Resources/*`
- `Microsoft.Authorization/roleAssignments/{Read,Write,Delete}`
- `Microsoft.ContainerRegistry/*`
- `Microsoft.ContainerService/*`

### Google Cloud Platform

- GCP account with project and GKE, GCR and Artifact Registry services enabled
    in the project.
- gcloud CLI, need to be logged in using `gcloud auth login` as a User (not a
  Service Account), configure application default credentials with `gcloud auth
  application-default login` and docker credential helper with `gcloud auth configure-docker`.

  **NOTE:** To use Service Account (for example in CI environment), set
  `GOOGLE_APPLICATION_CREDENTIALS` variable in `.env` with the path to the JSON
  key file, source it and authenticate gcloud CLI with:
  ```console
  $ gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
  ```
  Depending on the Container/Artifact Registry host used in the test, authenticate
  docker accordingly
  ```console
  $ gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://us-central1-docker.pkg.dev
  $ gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://gcr.io
  ```
  In this case, the GCP client in terraform uses the Service Account to
  authenticate and the gcloud CLI is used only to authenticate with Google
  Container Registry and Google Artifact Registry.

  **NOTE FOR CI USAGE:** When saving the JSON key file as a CI secret, compress
  the file content with
  ```console
  $ cat key.json | jq -r tostring
  ```
  to prevent aggressive masking in the logs. Refer
  [aggressive replacement in logs](https://github.com/google-github-actions/auth/blob/v1.1.0/docs/TROUBLESHOOTING.md#aggressive--replacement-in-logs)
  for more details.
- Docker CLI for registry login.
- kubectl for applying certain install manifests.

**NOTE:** Unlike ECR, AKS and Google Artifact Registry, Google Container
Registry tests don't create a new registry. It pushes to an existing registry
host in a project, for example `gcr.io`. Due to this, the test images pushed to
GCR aren't cleaned up automatically at the end of the test and have to be
deleted manually. [`gcrgc`](https://github.com/graillus/gcrgc) can be used to
automatically delete all the GCR images.
```console
$ gcrgc gcr.io/<project-name>
```

#### Permissions

Following roles are needed for provisioning the infrastructure and running the
tests:
- `Artifact Registry Administrator`
- `Compute Instance Admin (v1)`
- `Compute Storage Admin`
- `Kubernetes Engine Admin`
- `Service Account Admin`
- `Service Account Token Creator`
- `Service Account User`
- `Storage Admin`

## Test setup

Copy `.env.sample` to `.env`, put the respective provider configurations in the
environment variables and source it, `source .env`.

Ensure the test app container image is built and ready for testing. Test app
container image can be built with make target `docker-build`.

Run the test with `make test-*`, setting the test app image with variable
`TEST_IMG`. By default, the default test app container image,
`fluxcd/testapp:test`, will be used.

```console
$ make test-azure
make test PROVIDER_ARG="-provider azure"
docker image inspect fluxcd/testapp:test >/dev/null
TEST_IMG=fluxcd/testapp:test go test -timeout 30m -v ./ -verbose -retain -provider azure --tags=integration
2022/07/29 02:06:51 Terraform binary:  /usr/bin/terraform
2022/07/29 02:06:51 Init Terraform
...
```

## Debugging the tests

For debugging environment provisioning, enable verbose output with `-verbose`
test flag.

```console
$ make test-aws GO_TEST_ARGS="-verbose"
```

The test environment is destroyed at the end by default. Run the tests with
`-retain` flag to retain the created test infrastructure.

```console
$ make test-aws GO_TEST_ARGS="-retain"
```

The tests require the infrastructure state to be clean. For re-running the tests
with a retained infrastructure, set `-existing` flag.

```console
$ make test-aws GO_TEST_ARGS="-retain -existing"
```

To delete an existing infrastructure created with `-retain` flag:

```console
$ make test-aws GO_TEST_ARGS="-existing"
```
