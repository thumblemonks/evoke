# Evoke

Evoke, a service application that provides your own HTTP-based application with a mechanism for storing and executing a delayed HTTP request. Basically, Evoke is triggers and makes a request to a fully-qualified URL at a specific date and time of your choosing. You can think of Evoke as a service for invoking delayed triggers or jobs your application needs to execute at a specific time, but you don't want to write special code for.

### For example ...

Let's say you have an app that needs to send custom reminders to users (like a calendar application). Normally, you might:

1. record the date and time the reminder should be sent (easy)
2. implement the email itself (easy)
3. write some other utility, daemon, cron-job thinga-ma-bob that looks at your database repeatedly to figure out when to send the reminder (yuck and annoying).

So, with Evoke, you could do 1 and 2, but then just send a request to Evoke for it to store a URL and a date/time the URL should be called. When invoked at the date/time you set, this URL will theoretically trigger the email you want to send. You don't need to run any other services that you are afraid will crash and you not know about it, which would just lead to headaches and custom service code on your application servers. Thumble Monks and Evoke will take care of it.

### How about another example ...

What? Ok, fine. Let's say you have a system that allows trial memberships. Let's also say these trial memberships expire after 30 days. Well, whenever a new account is created, you could send Evoke a specific URL that could be called in 30 days (to the second) and would expire the trial membership. You wouldn't need to write any special reapers or scrubbers or anything. You would simply have to implement an action that would update the membership when called with the data you told it to be called with.

If you wanted, you could even tell evoke to call a renewal reminder one year from now. It's crazy what you could do.

### Cool things

* Any HTTP method you want
* Gets
* Updates
* Ruby helper
* GUID

### Coming soon ...

* A JavaScript library for you to use so that you don't need to do anything special or even need a real web-app. Just HTML and JavaScript, baby!

## CAVEATS

**This code is intended for a system the Thumble Monks team is putting together. We're just so nice we are sharing the code for the base service publicly ;)**

## Why would someone want to do this?

Because it's in the vein of supporting a service-oriented architecture. At Thumble Monks, we believe that some things you just don't need to keep implementing. We want to be done with all of this repetitive service stress. Managing delayed triggers or jobs is just one of those stresses.

Stop re-inventing the services wheel. You wouldn't intentionally write the same code in two classes would you? No. You'd abstract into a super-class or a module or something.

You wouldn't intentionally write the same class in two code-bases would you? No. You'd abstract the class into a library or plug-in.

So, why implement the same services between projects. We're talking a level of abstraction that is much higher than a class or a library. We're talking system abstraction and we're talking about doing it for everything in your application.

## Why is it called Evoke?

Because.

I guess probably because I was looking for words like invoke, trigger, remember, et al and hit upon evoke. Just seemed to make sense.

## How does it work?

Like this ...

rest-client
delayed_job

# Using App

## Requirements

* [Sinatra](http://github.com/bmizerany/sinatra/tree/master)
* Ruby JSON

## Setting up an app

We're still working this out.

### Installation


    $ TBD

### Configuration

    TBD

### Running

    $ TBD

# Todo

## 0.1.0

* TBD

## Backlog

* Aren't we clever

# Acknowledgements

Someone for sure. Probably our wives.

# Legal

Copyright &copy; 2008 Justin Knowlden, Gabriel Gironda, Dan Hodos, Thumble Monks, released under the MIT license
