# wstest
test for terraform
## 1 The basic functions of WS have been preliminarily completed,including
## 2 Being stuck a whole day on how to upload the self signed certificate to AWS's ACM through Terraform, the temporary solution is to manually upload the certificate.
## 3 From the perspective of network security, further modifications are needed for VPC and subnet
## 4 The code has been tested on AWS
## 5 Continue to modify basic functions and add additional features,including
## 6 A problem,terraform appears "Error: Cycle" when creating an EC2 instance using the provision function and eip
## 7 If you want to run the code in aws,please change the line(119) "certificate_arn   = "arn:aws:acm:us-west-2:842376562637:certificate/710f50b0-10ad-4b23-b29a-4e03f607b7b7"" certificate_arn to your own certificate_arn
