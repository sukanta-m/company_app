# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions


### Mongodb server

required version : 3.4 +

if you have docker installed, start mongodb with docker using following command

```
docker run -d -v $PWD/db_data/mongo:/data/db -p 27017:27017 mongo
```