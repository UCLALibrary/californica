UCLA Library Management -- Tenejo
=================================

[![Build Status](https://travis-ci.org/curationexperts/tenejo.svg?branch=master)](https://travis-ci.org/curationexperts/tenejo) [![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

Development
-----------

1. Setup your database.
   We use PostgreSQL. To support the test and development environments, you'll
   need have Postgres installed and running. In your `psql` console do
   `create role tenejo with createdb login`. Then do
   `bundle exec rake db:setup` to setup the create the database and schema.

What is Hyrax, what is Tenejo?
------------------------------

_Hyrax_ is a [Rails Engine](http://guides.rubyonrails.org/engines.html#what-are-engines-questionmark)
providing a base platform for digital repositories of various types. This includes Institutional/Document
Repositories, Digital Collections DAMS, as well as other kinds of digital library and archives systems.

_Tenejo_ is an application providing a general purpose repository system based on the _Hyrax_ platform.
_Tenejo_ gives you the most commonly used Samvera features and functions.

This application is a fork of _Tenejo_, designed as a management interface for UCLA's digital library
content.

License
-------

Tenejo is available under the [Apache License Version 2.0](./LICENSE).
