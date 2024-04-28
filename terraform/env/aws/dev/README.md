# AWS-EKS

This project is used as an example repo for different types of deployments of and on AWS EKS and for standing things up quickly for testing. It is written with the intent for the repo to be public. For these reasons, some of the methods of deployment wouldn't be the best choice for production deployments.

A few high level notes:

- This project deploys a vpc and eks cluster. The EKS cluster is in a private subnets.
- The EKS cluster does have a public endpoint, but is restricted to the IP of where it is deployed from.

