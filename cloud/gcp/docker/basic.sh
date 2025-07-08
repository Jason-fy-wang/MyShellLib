## tag format
<regional-repository>-docker.pkg.dev/my-project/my-repo/my-image

## create repository
gcloud artifacts repositories create my-repository --repository-format=docker --location=us-east4 --description="Docker repository"

## config docker with specific registry
gcloud auth configure-docker us-east4-docker.pkg.dev


