UCLA Library Management -- Tenejo
=================================

[![Build Status](https://travis-ci.org/UCLALibrary/samvera-mgmt.svg?branch=master)](https://travis-ci.org/UCLALibrary/samvera-mgmt) [![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

Development
-----------

1. Setup your database.
   We use PostgreSQL. To support the test and development environments, you'll
   need have Postgres installed and running. In your `psql` console do
   `create role tenejo with createdb login`. Then do
   `bundle exec rake db:setup` to setup the create the database and schema.

## Creating an admin user
First, create the user via the UI, or have them self-register. Then,
on the rails console:
```
u = User.find('example@library.ucla.edu')
admin = Role.find_by_name('admin')
admin.users << u
admin.save
u.admin?
  => true
```
If `u.admin?` returns `true` then you know it worked as expected. See also the
[Making Admin Users in Hyrax Guide](https://github.com/samvera/hyrax/wiki/Making-Admin-Users-in-Hyrax).

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
