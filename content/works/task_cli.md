---
title: "Task CLI"
date: 2020-10-15
draft: true
---

"Task CLI" is a personal software project of mine aimed at developing a task
and time management system for my own use. I've tried out far too many
productivity systems, calendar apps, todo list methods, etc., but I've never
found something that fully met my needs. So building my own application allows
me to take the features that I like from other systems, compose them all
together, and alter things as I please.

A secondary objective of the project is to learn the Go programming language. I
like Go because it's easy to work with and reasonably efficient, and I find
that I learn languages best by building a real project with them.

The application is in a very early state but I've implemented some basic
functionality like adding tasks to a list, displaying the list of tasks,
marking them complete, setting priorities, and adding deadlines. There are two
main components to the application in its current state: the command-line
interface and the TaskList library. The main focus of my development right now
is on building out a basic TaskList API whereas the interface is a secondary
concern. In time I plan to include a terminal user interface (TUI) for real-time
interaction.
