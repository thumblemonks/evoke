# Evoke

Evoke, a service application that provides your application with a mechanism for storing and executing a delayed HTTP request. Basically, Evoke triggers calls a fully-qualified URL at a specific date and time of your choosing. You can think of Evoke as a service for invoking delayed triggers or jobs your application needs to execute at a specific time, but you don't want to write special code for.

### For example ...

Let's say you have an app that needs to send custom reminders to users (like a calendar application). Normally, you might:

1. record the date and time the reminder should be sent (easy)
2. implement the email itself (easy)
3. write some other utility, daemon, cron-job thinga-ma-bob that looks at your repeatedly database to figure out when to send the reminder (yuck and annoying).

So, with Evoke, you could do 1 and 2, but then just send a request to Evoke for it to store a URL and a date/time the URL should be called. When invoked at the date/time you set, this URL will theoretically trigger the email you want to send. You don't need to run any other services that you are afraid will crash and you not know about it, leading to headaches and custom services code on your application servers. Thumble Monks & Evoke will take care of it.

### Coming soon ...

* A JavaScript library for you to use so that you don't need to do anything special or even need a real web-app. Just HTML and JavaScript, baby!
* An ActiveResource plugin for you to use in your Rails app

## CAVEATS

**This code isn't running anywhere yet because we're still writing it.**

**This code is intended for a system the Thumble Monks team is putting together. We're just so nice we are sharing the code for the base service publicly ;)**

## Why would someone want to do this?

Because it's in the vein of supporting a service-oriented architecture. At Thumble Monks, we believe that some things you just don't need to keep implementing. We want to be done with all of this repetitive service stress. Managing delayed triggers or jobs is just one of those stresses.

Stop re-inventing the services wheel. You wouldn't intentionally write the same code in two classes would you? No. You'd abstract into a super-class or a module or something.

You wouldn't intentionally write the same class in two codebases would you? No. You'd abstract the class into a library or plug-in.

So, why implement the same services between projects. We're talking a level of abstraction that is much higher than a class or a library. We're talking system abstraction and we're talking about doing it for everything in your application.

## Why is it called Evoke?

Because.

I guess probably because I was looking for words like invoke, trigger, remember, et al and hit upon evoke. Just seemed to make sense.

## How does it work?

Like this ...

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

Copyright &copy; 2008 Justin Knowlden, Gabriel Gironda, Thumble Monks, released under the MIT license
