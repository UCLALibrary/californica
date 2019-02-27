# UCLA Library Management - Californica

<img align="left" width="150" src="app/assets/images/CalifornicaPoppy.jpeg">

---

#### Californica is designed as a management interface for UCLA's digital library content.

[Eschscholzia californica, Copa De Oro](https://en.wikipedia.org/wiki/Eschscholzia_californica) The [state flower of California](http://www.parks.ca.gov/?page_id=627), the California poppy is a showy perennial wildflower.

---

[![Build Status](https://travis-ci.org/UCLALibrary/californica.svg?branch=master)](https://travis-ci.org/UCLALibrary/californica) &nbsp; [![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE) &nbsp; [![Test Coverage](https://coveralls.io/repos/github/UCLALibrary/californica/badge.svg?branch=master)](https://coveralls.io/github/UCLALibrary/californica?branch=master)

---

## Development

TO DO: Move this [into the wiki](https://github.com/UCLALibrary/californica/wiki)

### Prerequisites

The developer environment relies on Docker Engine and Docker Compose. Make sure you're running the latest versions.

Installation or upgrade instructions for [Docker Compose](https://docs.docker.com/compose/install/) and [Docker Engine](https://docs.docker.com/install/) are available on their respective sites.

## Getting started

First, clone the repo from GitHub:

    git clone git@github.com:UCLALibrary/californica.git
    cd californica

After that, you can run `docker-compose` to bring up the development environment:

    docker-compose up

The first time you create the environment, you'll also need to provision the databases. From within the `californica` directory, run:

    docker-compose run web bash
    bundle exec rake db:setup
    bundle exec rake californica:ingest:ladnn_sample

If this succeeds without error, you've successfully created your Californica environment and loaded some sample records.

To access some of the services that you'll need, try finding them at the following locations:

- Californica -> http://localhost:3000/
- Fedora -> http://localhost:8080/fcrepo/rest
- Solr -> http://localhost:8983/solr/#/

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

- A local rails app development environment is provisioned
- `bundle install` completes successfully
- Capistrano is installed as a part of the environment
- A deploy file exists that defines the destination host where code should be deployed. The relative path within the code base is `config/deploy/target_system.rb` - where `target_system` is an identifier for the destination host where code will be deployed. Sample file contents are:

```ruby
server 'californica-test.library.ucla.edu', user: 'deploy', roles: [:web, :app, :db]
```

This should already be available for you, but good to verify so you know where your deploy is going.

**To deploy code using Capistrano to a UCLA Library server**

1. Within your local development environment, become a user that has the following attributes:

- ownership of the files within your local copy of the code base
- ssh public key is installed in the `authorized_keys` file for your user account on the UCLA Library `jump` server
- ssh public key is installed in the `authorized_keys` file for the `deploy` user account on the destination server where code will be deployed
- if you need your public keys installed - please reach out to the DevSupport team for assistance

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

## Importing from CSV

### Character Encoding

When importing from a CSV file it is important to ensure that the character encoding
remains UTF-8.

If you need to make manual edits to a CSV export before importing _do not_ use Excel
unless it is version 2016 or higher. Older versions of Excel will change the encoding when you save the
file and re-export it as CSV. Current versions of Excel will have an option to export as 'UTF-8 CSV', which
should be used. Google Sheets or LibreOffice Calc will allow you to make manual edits and maintain the
correct encoding when saving.

### Import Process

Use the `rake californica:ingest:csv` task, and specify the CSV_FILE and IMPORT_FILE_PATH when you invoke it. For example:

```
CSV_FILE=/opt/data/ladnn/dlcs-ladnn-2018-09-06.csv IMPORT_FILE_PATH=/opt/data/ladnn/ bundle exec rake californica:ingest:csv
```

### Adding works to a collection
1. Create a collection manually.
  1. Make sure it is public.
  1. Make sure you grant deposit rights to all registered users (Sharing --> Add Group --> Then add 'registered' to the deposit role).
2. Note the id of the collection and specify it on the command line:
```
COLLECTION_ID=abc123 CSV_FILE=/opt/data/ladnn/dlcs-ladnn-2018-09-06.csv IMPORT_FILE_PATH=/opt/data/ladnn/ bundle exec rake californica:ingest:csv
```

## What is Hyrax, what is Californica?

_Hyrax_ is a [Rails Engine](http://guides.rubyonrails.org/engines.html#what-are-engines-questionmark)
providing a base platform for digital repositories of various types. This includes Institutional/Document
Repositories, Digital Collections DAMS, as well as other kinds of digital library and archives systems.

_Californica_ is an application providing a general purpose repository system based on the _Hyrax_ platform.
_Californica_ gives you the most commonly used Samvera features and functions.

This application is designed as a management interface for UCLA's digital library content.

## License

Californica is available under the [Apache License Version 2.0](./LICENSE).
