
# base init auth
gcloud auth list
gcloud config set run/region REGION

# deploy
gcloud functions deploy memories-thumbnail-creator  \
    --gen2  \
    --runtime=nodejs20 \
    --region=us-west1 \
    --source=.  \
    --entry-point=memories-thumbnail-creator   \
    --trigger-topic topic-memories-723 \
    --stage-bucket  qwiklabs-gcp-03-039fd5543e46-bucket   \
    --service-account   qwiklabs-gcp-03-039fd5543e46@qwiklabs-gcp-03-039fd5543e46.iam.gserviceaccount.com    \
    --allow-unauthenticated

# verify status of function
gcloud functions describe nodejs-pubsub-function  --region=REGION


# send msg to pubsub
gcloud pubsub topis publish cf-demo --message="Cloud Function Gen2"


# read function logs
gcloud functions logs read nodejs-pubsub-function --region=REGION


