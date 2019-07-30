+++
date = "2019-07-28T07:00:00+00:00"
tags = ["DevOps", "Lean IT", "Infracode", "Engineering", "Productivity"]
title = "Composable Infrastructure"
draft = false

+++
## PART I: Introduction

So you want to launch an app? You log onto this thing called [AWS](https://aws.amazon.com) and are greeted with an endless wall of features, resources, services and documentation.

After putting your eyes back in your head, you start reading and work out how to create an EC2 instance. You then work out that you'll probably want to create an autoscaling group, then spread that across multiple availability zones, put a load balancer in front of it, provision a database or two, create some S3 buckets and define a bunch of IAM policies to facilitate all these transactions safely.

You are looking good! Oh, wait, everything is accessible on the internet because you've done this in the default VPC!

Cool, so now you need to move it all to private networks. That'll include more documentation and reading on network routing, CIDR blocks, DNS, TLS, NAT gateways, the list goes on. After all that is set up, you'll probably want to replicate everything into multiple regions and finally get some monitoring and observability hooked up.

Wow, all you wanted to do was launch an app!

Doing all of the work above in the AWS console is normal when learning, I did it, we all did it. Pointing and clicking is excellent for learning, not so great when you start provisioning production infrastructure that is susceptible to frequent changes, having multiple people working on it, and the rising need for reproducibility. This is where infrastructure-as-code made its name.

While provisioning your infrastructure as code is a significant improvement, it still requires a considerable amount of manual work and maintenance for all that code. Then there's the reproducibility of the code; what happens when we want to deploy multiple environments or resources? I'm sure I don't need to explain to you how much of a pain in the arse the logistics of code repetition can be.

Hold on, let's go back to the start; My business goals were to launch an app, not wrangle with the endless pit of infrastructure.

Surely there must be a better way?

Yes, there is, and it is called "composable infrastructure".

</br>
## PART II: Composable Infrastructure

So what is composable infrastructure? Well, first, let's take a quick trip into the two main types of infrastructure most widely used today.

We have Infrastructure-as-a-Service (IaaS). These are things like AWS and GCP. They provide you with all the knobs and switches for CPU, memory, disk, network, server, databases, and so on, but it is up to you to put it all together.

Then there is Platform-as-a-Service (PaaS). These are things like Heroku and Docker Cloud. PaaS abstracts and hides the complexities of raw infrastructure and generally sits above IaaS. Now you have a simple API; here's how you deploy your app or database without needing the know-how to wire it all together under the hood.

PaaS sounds excellent, right? Well, yes and no. By design, PaaS is hiding those wires under the hood and therefore has limitations. You have to work within the boundaries of the PaaS and thus are limited to the supported languages and protocols; you can't directly access the underlying resources nor monitor them, it becomes harder to debug problems, and harder to customise your architecture as your app scales.

You'll see a trend with startups and new company products. They start with PaaS and take advantage of the simplicity it provides to get a product out the door, but as they grow, they start to hit the limitations mentioned above and tend to fall back to IaaS.

What we need is the provisioning simplicity that PaaS provides with the ability to get under the hood that IaaS provides.

This is where composable infrastructure enters the picture. To explain this, let's use the analogy of a car manufacturing factory.

When creating a new car model, I write a list of parts I need, go to the warehouse and retrieve those parts off the shelf, then feed them into my production line to be assembled.

Many of these parts are already built and ready to be assembled. For instance, I don't want to have to build a new engine, transmission and radiator for each car. I want these parts ready-to-go. By doing so, it simplifies the production, saves time, ensures consistency, and provides the same quality across every car produced.

This is the mindset behind composable infrastructure. Rather than having to manually code or provision resources every time we want to build a platform, we can have these underlying resources pre-built and ready to go. Now we merely make a list of what we need (an EC2 instance, S3 bucket and RDS database, for example), fetch them from our composable infrastructure library, and feed them into CI/CD to be built.

Now we can create simple, consistent and reproducible platforms — the simplicity of PaaS, with the flexibility of IaaS.

</br>
## PART III: What it looks like

To demonstrate composable infrastructure, I've chosen to use [Terraform](https://www.terraform.io) as it is an excellent infracoding tool and lends itself to this style of workflow.

In Terraform, we can create what we call [modules](https://www.terraform.io/docs/modules/index.html). In its simplest form, a module is any piece of Terraform code we can call and execute from another location. Think of it as a blueprint. Let me show you what I mean.

Let's say we have a directory with two sub-directories and few blank Terraform files that looks something like this:

```
/infracode
  /infracode/my_module/ec2.tf
  /infracode/my_deployments/my_instances.tf
```

In `ec2.tf` we write some Terraform to provision a simple EC2 instance:

```
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
  ami = "ami-abcd1234"
  instance_type = "t2.micro"

  tags = {
    Name = "my-instance"
  }
}
```

Here we have defined our Terraform provider and defined a resource (in this case, an EC2 instance) to create via the AWS provider. Cool, so if we were to run `terraform apply` from within `/my_module`, it would go off and build an instance with the name tag `"my-instance"`.

However, what we actually want to do is reuse this code any time we need to create an instance. So let's use this existing code as a module.

In our other directory `/my_deployments` in the `my_instances.tf` file, instead of rewriting the code, we do something like this:

```
module "foo" {
  source = "../my_module"
}
```

Here we've told Terraform that we want to use a module, we give it a name and tell Terraform where it can find the directory containing the code we want to execute. Now if we run `terraform apply` from within `/my_deployments`, it reads the code from our source `../my_module` and executes it. Pretty cool, right?

So what if I want to create two instances? Easy; create a second module block:

```
module "foo" {
  source = "../my_module"
}

module "bar" {
  source = "../my_module"
}
```
Now if we run a `terraform apply`, it identifies that there are two modules, `"foo"` and `"bar"`, and creates them.

You may have noticed, however, that at this point, we're creating two EC2 instances both with the name tag `"my-instance"`. So we need to start customising the parameters of each instance. To do so, we use variables. So let's go back to our base code `ec2.tf` in the `/my_module` directory and make some changes:

```
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
  ami = "ami-abcd1234"
  instance_type = "t2.micro"

  tags = {
    Name = "${var.instance_name}"
  }

variable = instance_name {}
}
```

Now we've set the EC2 name tag as a blank variable called `instance_name`. So if we move back to `my_instances.tf` in our module blocks we can now do something like this:

```
module "foo" {
  source = "../my_module"

  instance_name = "my-instance-1"
}

module "bar" {
  source = "../my_module"

  instance_name = "my-instance-2"
}
```

Here we have defined `instance_name` in our two module blocks, and their values are inserted into the blank variable `instance_name` in our root module `ec2.tf`. Terraform will now create two instances, one with the name tag `"my-instance-1"` and the other `"my-instance-2"`. We now have a reproducible module to create EC2 instances any time we need one.

While this is a simple example of some fundamental infrastructure, it demonstrates the foundations and concepts of using Terraform modules to create composable infrastructure!

The best part is that as a community, we can collectively work and benefit from each other. With this outlook, we have fantastic resources like [The Terraform Module Registry](https://registry.terraform.io) where, as a community, we can write and share modules for each other to use in our platform creations. There's no point all of us writing the same thing when we can benefit from each other's work!

</br>
## PART IV: Conclusion

I hope this short journey into composable infrastructure has shown you the benefits of treating infrastructure like a lean manufacturing production line. The key takeaway here is to work smart, not hard. The mindset and process of getting work done are more valuable than the tools you choose to use. So be smart!