UCLA Library Management -- Californica
=================================

[![Build Status](https://travis-ci.org/UCLALibrary/californica.svg?branch=master)](https://travis-ci.org/UCLALibrary/californica) [![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

Development
-----------

### Prerequisites

Requirements:
1. Ruby and Bundler
1. MySQL (or MariaDB), Redis, Node.js, and Java
1. Various build tools (Ubuntu packages are listed below - not sure about other
   distros...)

#### Chose your path: development environment alternatives

The "[native-style](https://github.com/UCLALibrary/amalgamated-samvera/wiki/Setting-up-a-Californica-development-environment,-%22native%22-style)" development environment will run entirely on your own computer. Choose this path if you'd like to get a deeper understanding of how all the pieces fit together and work, but also understand this environment will be somewhat different than what is running in production.

The [VM-style](https://github.com/UCLALibrary/amalgamated-samvera/wiki/Setting-up-a-Californica-development-environment,-VM-style) development environment has as a goal to run a production-like environment in a virtual machine, hosted on your computer. It is also generally easier to get started with using, particularly if you've already installed the requirements (Vagrant and Virtualbox).

## Default admin user
A default admin user is created for you, with the e-mail address of admin@example.com, and a password of 'password' This password can and should be set by way of a dot-env variable ADMIN_PASSWORD. See the .env.sample file for an example.

## Creating a new admin user
First, create the user via the UI, or have them self-register. Then,
on the rails console:
```
u = User.find_by_user_key('example@library.ucla.edu')
admin = Role.find_by_name('admin')
admin.users << u
admin.save
u.admin?
  => true
```
If `u.admin?` returns `true` then you know it worked as expected. See also the
[Making Admin Users in Hyrax Guide](https://github.com/samvera/hyrax/wiki/Making-Admin-Users-in-Hyrax).

## Deployment

To deploy to the server `cd`, simply type `cap cd deploy`.

For this to work:
- You need Capistrano installed (`bundle install` does this).
- Your public ssh key needs to have been added to the `deploy` account on the
  server. A member of the devops team can do this for you. If you have uploaded
  your public key to GitHub, they might have done this already, but changes need
  to be made manually.

What is Hyrax, what is Californica?
------------------------------

_Hyrax_ is a [Rails Engine](http://guides.rubyonrails.org/engines.html#what-are-engines-questionmark)
providing a base platform for digital repositories of various types. This includes Institutional/Document
Repositories, Digital Collections DAMS, as well as other kinds of digital library and archives systems.

_Californica_ is an application providing a general purpose repository system based on the _Hyrax_ platform.
_Californica_ gives you the most commonly used Samvera features and functions.

This application is designed as a management interface for UCLA's digital library content.

License
-------

Californica is available under the [Apache License Version 2.0](./LICENSE).
