Vicancy
=======

Repository structure
--------------------

* **feature** branches - branches where feature development occurs, main working branches
* **master** branch - staging branch, all complete code goes here (from feature branches)
* **production** branch - production branch, working code from staging branch goes here

Git Workflow
------------

* Work in feature branches (either local or remote)
* Once the feature is complete, merge it into master branch
* Play with it on sandbox and/or staging servers
* Once considered ok, push staging branch into production:
```
git push origin master:production
```

Continuous Integration & Deployment
-----------------------------------

* Code from **master** branch gets deployed into staging server
* Code from **production** branch gets deployed into production server
