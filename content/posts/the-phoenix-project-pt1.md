+++
title = "The Phoenix Project Pt1"
date = "2018-11-08T08:37:44+11:00"
tags = ["DevOps", "Lean IT", "Infracode", "Engineering", "Productivity"]
+++

Recently I was recommended by a fellow DevOps friend (and mentor) to read The Phoenix Project by Gene Kim, Kevin Behr and George Spafford, as part of my learning curriculum on the journey to becoming an engineer in the DevOps/SRE space.

Let me roll out the spoiler bandwagon right now. This book is an absolute must-read for anyone in the IT industry, regardless of your department or speciality. Now, moving on.

If you haven’t read it before, The Phoenix Project is about the journey of an ops technician named Bill Palmer. Bill is thrown in the deep end and is forced to take over the whole IT department of a manufacturing company that is on the verge of bankruptcy and becoming outsourced as a result of failing software solutions to compete with their competitors. What Bill finds is an internal war between development and operations teams that leaves the company with delayed and broken releases (we’ve all been there before). This clusterfuck begins a quest to solve this infamous problem of which much of the IT industry has struggled with for decades. Over the next several months, and with the mentoring from some great characters, Bill learns the principles of DevOps and completely transforms the company into an automated and smart-working machine.

What practical lessons did I learn from The Phoenix Project?

## IT work is EXACTLY like a manufacturing plant floor:

On a plant floor, materials come in on the left and leave as finished products on the right. These materials pass through a series of work centres as they are assembled. We call this work-in-progress or “WIP.”

Specific work centres can sometimes become constraints, that is, the particular task at said work centre takes longer to complete than the flow of WIP leading to it. In the IT world, we call this technical debt; new requests, problems and bugs that are coming in before existing issues have been addressed. Eventually, this leads to an unfathomable amount of technical debt. To address this, one must control the flow of WIP to the constraint as not to begin the accumulation of technical debt.

## Visualisation gives overview:

Being able to visualise WIP is essential to maintain its flow. Kanban boards are an excellent tool for this.

A basic kanban consists of three columns: “to do,” “doing,” and “done.” These columns contain task cards. All outstanding and required task cards reside in the “to do” column. These cards are then prioritised and moved into the “doing” column in small numbers as not to create a constraints. Only once they’re completed can they be moved to the “done” column.

Cards should never be introduced into the “doing” column until all its existing cards have been completed. This process ensures a constant flow of work and makes sure only priority tasks are under the microscope at any given time.

## Ten deploys per day:

The key to DevOps’ success is continual improvement. While developers have become agile and quick to respond to new requests over the last 15 years, operations fell behind. Devs wanted their code released quickly and regularly, while ops didn’t want to make any changes to the servers as not to break them. Devs wanted speed, ops wanted stability. In order to counter this conundrum, ops needed to become agile. We achieve this through several tools and concepts.

The primary concept is called infrastructure as code or “infracoding.” In the world of cloud computing, we can write scripts or code (like a programming language) to spin up and automate cloud infrastructure as it is needed. This eliminates the need for ops to manually provision on monitor infrastructure.

Our second go-to tool set is continuous testing and continuous intergration. With the use of infracoding, we can create dev and QA environments to exactly clone our production environment. We then use tools to create tests and conditions that new code must pass in order to move to the next stage. Having this whole process automated allows an incredible amount of speed when applying new code and gives us the ability to roll back to previous versions if problems arise.

This, for the most part, eliminates downtime and visible problems for customers. While there are many more parts to the DevOps workflow, these key components are the driving force that allows ops to become agile and achieve speed AND stability.

## Closing comments:

These mentioned aspects of DevOps cover the practical day-to-day applications to achieve the DevOps workflow. In a future post, I plan to go over “the three ways” of DevOps, which delves into the philosophical side of the DevOps movement and how these practices and tools fit into the larger company picture.

For now, these mentioned lessons I’ve learned from The Phoenix Project are those that can be applicable to your workflow today.