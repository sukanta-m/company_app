# README

* Ruby version : 2.4.1
* Rails version : 5.0.6

### Mongodb server

required version : 3.4 +

if you have docker installed, start mongodb with docker using following command

```
docker run -d -v $PWD/db_data/mongo:/data/db -p 27017:27017 mongo

```

### Rspec

* To run spec, run below command

```
rspec spec/ --format=doc

```

* Test coverage

if you want to check the code coverage in html view, then open the file
```
[app dir]/coverage/index.html

```