# get message from subscriptions
gcloud pubsub subscriptions pull --auto-ack MyPub

# create topic
gcloud pubsub topics create myTopic

# list topics
gcloud pubsub topics list


# delete tpopics
gcloud pubsub topics delete test1

# create subscription
gcloud pubsub subscriptions create --topic myTopic  mySubScription

# list subscriptions
gcloud pubsub topics list-subscriptions myTopic

# delete subscriptions
gcloud pubsub subscriptions delete sub1

# public message to topic
gcloud pubsub topics publish myTopic --message "hello world"

# consume message  (consume only one msg)
gcloud pubsub subscriptions pull mySubscription --auto-ack

# pull message with limit (consume limit msgs)
gcloud pubsub subscriptions pull mySubscription --auto-ack --limit=3


## pubsub python SDK
git clone https://github.com/googleapis/python-pubsub.git



