Tenejo
======

Tenejo is a general purpose Digital Repository/Asset Management System.

Development
-----------

1. Setup your database.
   We use PostgreSQL. To support the test and development environments, you'll
   need have Postgres installed and running. In your `psql` console do
   `create role tenejo with createdb login`. Then do
   `bundle exec rake db:setup` to setup the create the database and schema.
