+++
date = "2019-03-14T07:00:00+00:00"
draft = true
tags = ["DevOps", "Lean IT", "Infracode", "Engineering", "Productivity"]
title = "Composable Infrastructure: Chapter I"

+++
![](/uploads/board-2440249_1280.jpg)

So you need to launch an app? You create a VPC; then a compute instance. You'll probably then want to create an autoscaling group across multiple availability zones and put a load balancer in front of it. You'll then need to provision databases, create some object storage to store files in and define a bunch of IAM policies to lock it all down.

You are looking good! Oh, wait, everything is accessible on the internet!

Now you need to move it all to private networks. That'll include learning network routing, CIDR blocks, DNS, TLS, NAT gateways, the list goes on. After all that is set up, you'll probably want to replicate it all into multiple environments and get some monitoring and alerting hooked up.

Wow, all you wanted to do was launch an app!

So let's start getting smarter and write some infrastructure as code to take away to manual repetition and chances of human error for all this infrastructure. We write some infracode for the VPC, the autoscaling group, load-balancing, databases, networking...wait, this seems oddly familiar.

While writing infracode for the infrastructure stack is a significant improvement, it still requires a considerable amount of manual work and maintenance for all that code. Then there's the reproducibility; what happens when we want to deploy multiple environments? Do we have all this code repetition for each environment? What if we're going to make a change across all our deployments? Will we have to make the change several times across all this repetition?

Surely there must be a better way...