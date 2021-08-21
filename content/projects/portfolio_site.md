---
title: "Portfolio (about this site)"
date: 2021-08-21T11:20:22-04:00
draft: true
---

I wanted to create a simple and easy-to-maintain site to host my
personal portfolio. I decided to use the static-site generator
[Hugo](https://gohugo.io/) for this project. Hugo allows me to use
Markdown (which I use for everything already) to write posts for the
site, and publishing is as simple as pushing commits to a [remote git
repository](https://github.com/jcarr132/portfolio-site) which triggers
automated CI/CD into [Netlify's](https://www.netlify.com) CDN.
I used the [Hermit](https://github.com/Track3/hermit) Hugo theme as a
base and made some minor modifications.

I wrote a small Go program to generate the
[CV](https://github.com/jcarr132/cv2) that I'm using for the site. I got
this idea from [rwxrob](https://www.youtube.com/rwxrob) on YouTube.
Essentially, all of my CV data (Education, Experience, Skills, the
usual) is defined in a single YAML file. Go reads the data from the YAML
file and injects it into a series of HTML templates which then get
globbed together into a single HTML page that I style with CSS. To get a
PDF version, I use the WeasyPrint Python library which takes the HTML
file and produces a PDF complete with styling. Before this, I was using
LaTeX to generate my CV (I was using LaTeX a lot at the time, writing my
Master's thesis) which was much more of an annoyance to modify, format,
and compile, and truthfully didn't look nearly as nice.
