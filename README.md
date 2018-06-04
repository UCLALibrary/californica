Tenejo
======

Tenejo is a general purpose Digital Repository/Asset Management System.

[![Build Status](https://travis-ci.org/curationexperts/tenejo.svg?branch=master)](https://travis-ci.org/curationexperts/tenejo)[![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

Development
-----------

1. Setup your database.
   We use PostgreSQL. To support the test and development environments, you'll
   need have Postgres installed and running. In your `psql` console do
   `create role tenejo with createdb login`. Then do
   `bundle exec rake db:setup` to setup the create the database and schema.

License
-------

Tenejo is available under the [Apache License Version 2.0](./LICENSE).
