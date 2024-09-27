# wstest
test for terraform
## 1 The basic functions of WS have been preliminarily completed,including
### •	Using Terraform or AWS Cloudformation, automate the deployment of secure, publicly available HA Load-Balanced Web Servers that return the instance id of the host that served the request.
### •	Ensure that the web servers are available in two AWS availability zones and will automatically rebalance themselves if there is no healthy web server instance in either availability zone.
### •	Redirect any HTTP requests to HTTPS. Self-signed certificates are acceptable.
## 2 Being stuck a whole day on how to upload the self signed certificate to AWS's ACM through Terraform, the temporary solution is to manually upload the certificate.
## 3 From the perspective of network security, further modifications are needed for VPC and subnet
## 4 The code has been tested on AWS
## 5 Continue to modify basic functions and add additional features,including
### •	Provide basic automated tests to cover included scripts, templates, manifests, recipes, code etc.
### •	Redirect any 404 errors to a custom static page.
### •	Add a Database to your automation and have your application serve the data stored in addition to the instance ID.
## 6 A problem,Terraform appears "Error: Cycle" when creating an EC2 instance using the provision function
