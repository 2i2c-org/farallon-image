
# pangeo-hubs

A collection of JupyterHub deployments with hubploy by 2i2c.

## Contents:

1. **User documentation:**
   * [How to ssh into your hub](#how-to-ssh-into-your-hub)
2. **Admin documentation:**
   * [How to deploy changes to an existing hub](#how-to-deploy-changes-to-an-existing-hub)
   * [How to use an unreleased helm chart](#how-to-use-an-unreleased-helm-chart)

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

1. The current list of existing clusters use [repo2docker](https://repo2docker.readthedocs.io/en/latest/)
to build the Docker image. In order to install new R packages, add them to their corespondig configuration
file: `<deployments/<hub-image>/image/install.R`

2. The packages listed in the `install.R` file are installed using
[devtools](https://www.r-project.org/nosvn/pandoc/devtools.html)

- Add the pkgs available on [Cran](https://cran.r-project.org) to the `cran_packages`
  list. These packages will be installed using `devtools::install_version`.
- Add the pkgs that are only available on GitHub to the `github_packages` list.
  These packages will be installed using `devtools::install_github`.

3. Pin every package to their current versions, available on the
[R Studio package manager](https://packagemanager.rstudio.com/client/#/repos/1/packages)
or to a specific wanted version. If the package is only available on GitHub, pin to a git commit hash.

4. Build the Docker image locally and make sure everything is ok.

   ```bash
      # from inside the image directory
      docker build .
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
      hubploy build <cluster-name> --check-registry --push
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

## How to use an unreleased helm chart

Sometimes you might need to use the latest version of a helm chart and that isn't yet released.
The following steps shows how to do so for the DaskHub project, but the pattern
should be replicable for others.

1. Clone the repo holding the latest version of the helm-chart and checkout the wanted branch:

   *DaskHub example:*

   ```bash
   git clone https://github.com/dask/helm-chart.git
   git checkout master
   ```

2. Reference the version of the unpackaged Helm chart (of the locally cloned git repository) in the dependencies `yaml` file of your project (either `requirements.yaml` or `Chart.yaml`). This version should be available in the`Chart.yaml` file (of the cloned repository). If the version is set to be a placeholder or outdated, it may be because it is maintained using `chartpress`, then run `chartpress` in that repository first to update it.

   *DaskHub example:*

   ```yaml
   dependencies:
     - name: daskhub
       repository: file://<path-to-your-daskhub-checkout>/daskhub
       version: <version-from-chart.yaml-of-daskhub>
   ```

3. Run an update any time the dependencies (in `requirements.yaml` or `Chart.yaml`) of the chart you
just cloned changes.

      *DaskHub example:*

      ```bash
      # from inside the dask/helm-chart checkout
      helm dep up daskhub
      ```

4. Deploy the changes.

## How to ssh into your hub

The OHW and Farallon hubs use the [`jupyterhub-ssh`](https://github.com/yuvipanda/jupyterhub-ssh) project, allowing straightforward SSH access into the hubs.
To gain SSH access to your user environment in [OHW](https://ohw.pangeo.2i2c.cloud) or [Farallon](https://farallon.2i2c.cloud) hubs, follow the next steps:

1. Login into your JupyterHub and go to the API token request page of the hub you want to SSH into:
   * https://ohw.pangeo.2i2c.cloud/hub/token
   * https://farallon.2i2c.cloud/hub/token

2. Request a new API token and copy it.

3. SSH into JupyterHub using the username you used to request a new token from the Hub and the Hub address:

   ```bash
    $ ssh <username-you-used-to-login>@ohw.pangeo.2i2c.cloud
   ```
   or:

   ```bash
    $ ssh <username-you-used-to-login>@farallon.2i2c.cloud
   ```

4. Enter the token received from JupyterHub as a password.

   **Note**: If the Notebook server isn't running, `jupyterhub-ssh` will try to start it for you. But this takes a while.
   If you get a timeout error about the server spawning process like this one:

      ```bash
      Starting your server...............................failed to start server on time!
      ```
   You should first start the notebook server from the JupyterHub page or try a few times, until the server starts.

5. TADA :tada: Now you have an interactive terminal! You can do anything you would generally interactively do via ssh: run editors, fully interactive programs, use the commandline, etc. Some features like non-interactive command running, tunneling, etc are currently unavailable.
