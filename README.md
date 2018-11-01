# UCLA Library Management - Californica

<img align="left" width="150" src="http://digital2.library.ucla.edu/imageResize.do?contentFileId=58393&scaleFactor=0.4">

---

#### Californica is designed as a management interface for UCLA's digital library content.  

[Eschscholzia californica, Copa De Oro](https://en.wikipedia.org/wiki/Eschscholzia_californica) The [state flower of California](http://www.parks.ca.gov/?page_id=627), the California poppy is a showy perennial wildflower.
   
---

[![Build Status](https://travis-ci.org/UCLALibrary/californica.svg?branch=master)](https://travis-ci.org/UCLALibrary/californica) &nbsp; [![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE) &nbsp;  [![Test Coverage](https://coveralls.io/repos/github/UCLALibrary/californica/badge.svg?branch=master)](https://coveralls.io/github/UCLALibrary/californica?branch=master)

---

## Development

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
First, create the user via the UI, or have them self-register.  

Then, on the rails console:
```ruby
u = User.find_by_user_key('example@library.ucla.edu')
admin = Role.find_by_name('admin')
admin.users << u
admin.save
u.admin?
  => true
```

If `u.admin?` returns `true` then you know it worked as expected. 

See also the [Making Admin Users in Hyrax Guide](https://github.com/samvera/hyrax/wiki/Making-Admin-Users-in-Hyrax).

## Deployment

### Prerequisites/Assumptions:

* A local rails app development environment is provisioned
* `bundle install` completes successfully
* Capistrano is installed as a part of the environment
* A deploy file exists that defines the destination host where code should be deployed. The relative path within the code base is `config/deploy/target_system.rb` - where `target_system` is an identifier for the destination host where code will be deployed. Sample file contents are:
```ruby
server 'californica-test.library.ucla.edu', user: 'deploy', roles: [:web, :app, :db]
```
This should already be available for you, but good to verify so you know where your deploy is going.

**To deploy code using Capistrano to a UCLA Library server**

1. Within your local development environment, become a user that has the following attributes:
 * ownership of the files within your local copy of the code base
 * ssh public key is installed in the `authorized_keys` file for your user account on the UCLA Library `jump` server
 * ssh public key is installed in the `authorized_keys` file for the `deploy` user account on the destination server where code will be deployed
 * if you need your public keys installed - please reach out to the DevSupport team for assistance
2. Ensure you are in the project code directory and execute:
```bash
  VIA_JUMP=yes BRANCH=master bundle exec cap target_system deploy
```
  Where `target_system` matches the filename used by the `target_system.rb` deploy file.

  This will execute the deploy, tunneling through the Library's `jump` server.

  If your local environment username is different than your username on the `jump` server, execute:
```bash
  JUMP_USER=YOUR_JUMP_USERNAME VIA_JUMP=yes BRANCH=master bundle exec cap target_system deploy
```

Importing from CSV
------------------

When importing from a CSV file it is important to ensure that the character encoding
remains UTF-8.

If you need to make manual edits to a CSV export before importing *do not* use Excel
unless it is version 2016 or higher. Older versions of Excel will change the encoding when you save the 
file and re-export it as CSV. Current versions of Excel will have an option to export as 'UTF-8 CSV', which
should be used. Google Sheets or LibreOffice Calc will allow you to make manual edits and maintain the 
correct encoding when saving.

What is Hyrax, what is Californica?
---

_Hyrax_ is a [Rails Engine](http://guides.rubyonrails.org/engines.html#what-are-engines-questionmark)
providing a base platform for digital repositories of various types. This includes Institutional/Document
Repositories, Digital Collections DAMS, as well as other kinds of digital library and archives systems.

_Californica_ is an application providing a general purpose repository system based on the _Hyrax_ platform.
_Californica_ gives you the most commonly used Samvera features and functions.

This application is designed as a management interface for UCLA's digital library content.

License
---

Californica is available under the [Apache License Version 2.0](./LICENSE).
