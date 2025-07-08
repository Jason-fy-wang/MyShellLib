#Bucket naming rules
#Do not include sensitive information in the bucket name, because the bucket namespace is global and publicly visible.
#Bucket names must contain only lowercase letters, numbers, dashes (-), underscores (_), and dots (.). Names containing dots require verification.
#Bucket names must start and end with a number or letter.
#Bucket names must contain 3 to 63 characters. Names containing dots can contain up to 222 characters, but each dot-separated component can be no longer #than 63 characters.
#Bucket names cannot be represented as an IP address in dotted-decimal notation (for example, 192.168.5.4).
#Bucket names cannot begin with the "goog" prefix.
#Bucket names cannot contain "google" or close misspellings of "google".
#Also, for DNS compliance and future compatibility, you should not use underscores (_) or have a period adjacent to another period or dash. For example, ".." or "-." or ".-" are not valid in DNS names.

## create bucket
gsutil mb gs://bucket_name

## copy to bucket
curl https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/800px-Ada_Lovelace_portrait.jpg --output ada.jpg

gsutil cp ada.jpg  gs://bucket_name


## download bucket
gsutil cp -r gs://bucket_name/ada.jpg .

## cp a object to another folder
gsutil cp gs://bucket_name/ada.jpg gs://bucket_name/image-folder/

## list files
gsutil ls gs://bucket_name

## list file detail
gsutil ls -l gs://bucket_name/ada.jpg

## make sure object public accessible
gsutil acl ch -u AllUsers:R gs://bucket_name/ada.jpg
### remove object public access
gsutil acl ch -d AllUsers gs://bucket_name/ada.jpg

## delete objects
gsutil rm gs://bucket_name/ada.jpg



