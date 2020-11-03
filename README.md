
# pangeo-hubs

A collection of JupyterHub deployments with hubploy by 2i2c.

## How to deploy changes to an existing hub

This section shows how to install new R packages and deploy the changes to a cluster.

### Step 0: Set up your pre-requisites
Make sure you have the following packages installed and configured:

   - [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
   - [Aws CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
   - [sops](https://github.com/mozilla/sops/releases)
   - [hubploy](https://github.com/yuvipanda/hubploy)
   - [docker](https://docs.docker.com/install/)

### Step 1: Install additional R packages

1. The current list of existing clusters use `repo2docker` to build the Docker
image. In order to install new R packages, add them to their corespondig configuration
file: `<deployments/<hub-image>/image/install.R`

2. The packages listed in the `install.R` file are installed using
[devtools](https://www.r-project.org/nosvn/pandoc/devtools.html)

- Add the pkgs available on [Cran](https://cran.r-project.org) to the `cran_packages`
  list. These packages will be installed using `devtools::install_version`.
- Add the pkgs that are only available on GitHub to the `github_packages` list/
  These packages will be installed using `devtools::install_github`.

3. Pin every package to their current versions, available on the
[R Studio package manager](https://packagemanager.rstudio.com/client/#/repos/1/packages)
or to a specific wanted version. If the package is only available on GitHub, pin to a GitHub commit hash.

4. Build the Docker image locally and make sure everything is ok.

   ```bash
      docker build . inside the image directory
   ```

5. Commit the changes to git, for `hubploy build <hub-name> --push --check-registry` to work,
since the commit hash is used as the image tag.

### Step 2: Deploy the changes to the hub

1. Make sure you have the right gcloud project set:

   ```bash
      gcloud config set project <project>
   ```

3. Get the user access credentials used by hubploy and [sops GCP KMS](https://github.com/mozilla/sops#22encrypting-using-gcp-kms):

   ```bash
      gcloud auth application-default login
   ```

4. Retrieve the authentication token and pass it to the docker login command to authenticate to the Amazon ECR registry.
   When retrieving the password, ensure that you specify the same region that your Amazon ECR registry exists in.

   ```bash
      aws ecr get-login-password --region <amazon-ECR-registry-region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<amazon-ECR-registry-region>.amazonaws.com
   ```

5. Build and push the Docker image with `hubploy`:

   ```bash
      hubploy build ohw --check-registry --push
   ```

6. Authenticate into the cluster:

   ```bash
      aws eks update-kubeconfig --name=<cluster-name>
   ```

7. Deploy the changes to the **staging** hub and make sure everything works as expected:

   ```bash
      hubploy deploy <hub-name> hub staging
   ```

   **Note**: 
      * Each hub will always have two versions - a *staging* hub that isn’t used
      by actual users, and a *production* hub that is. These two should be
      kept as similar as possible, so you can fearlessly test stuff on the
      staging hub without feaer that it is going to crash & burn when deployed
      to production.

      * Make sure your IAM role has enough persmissions to deploy. Check with the cluster admin if
      a `401 Unautorized` error appers when deploying.

8. Deploy the changes to the **production** hub:

   ```bash
      hubploy deploy <hub-name> hub prod
   ```
