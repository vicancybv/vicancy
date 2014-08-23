Vicancy
=======

[ ![Codeship Status for pmoorman/vicancy](https://codeship.io/projects/6420b1d0-e98f-0131-eba0-368dc75eab9e/status)](https://codeship.io/projects/26202)

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
Or create pull request

Continuous Integration & Deployment
-----------------------------------

* Code from **master** branch gets deployed into
  * Sandbox server: http://sandboxvicancy.herokuapp.com
  * Staging server: http://stagingvicancy.herokuapp.com
* Code from **production** branch gets deployed into production server

Generate API Documentation
--------------------------

Run the following:

    bundle exec rake docs:generate
    

Update video thumbnails on heroku
---------------------------------

Run the following to update thumbs on staging server:

    heroku run rake thumbs:get --app stagingvicancy