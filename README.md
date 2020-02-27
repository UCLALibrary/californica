# UCLA Library Management - Californica

<img align="left" width="150" src="app/assets/images/CalifornicaPoppy.jpeg">

---

#### Californica is designed as a management interface for UCLA's digital library content

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
    bundle exec rake hyrax:default_admin_set:create

If this succeeds without error, you've successfully created your Californica environment.

To access some of the services that you'll need, try finding them at the following locations:

- Californica -> http://localhost:3000/
- Fedora -> http://localhost:8984/
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

## Loading data

You can load data from a csv via the Hyrax Dashboard interface.

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

Use the `rake californica:ingest:csv` task, and specify the CSV_FILE and IMPORT_FILE_PATH when you invoke it.

In the docker-compose development environment, `/opt/data/` mounts the `californica/data` directory
from your host machine. This directory is empty by default and included in .gitignore, so you'll
need to obtain the data on your own and put it here: metadata CSVs are stored in the box drive and
master images are on the Netapp `Masters` volume.

Once the data is in place, the ingest command looks something like:

```
CSV_FILE=/opt/data/ladnn/dlcs-dlcs_ladnn-2018-12-12.csv IMPORT_FILE_PATH=/opt/data/ladnn/ bundle exec rake californica:ingest:csv
```

In our server environments, csv files are copied to `/opt/data/` and the entire `Masters` volume is
mounted at `/opt/data/Masters/`. To set the IMPORT_FILE_PATH variable, you will need to find the
directory within `Masters` that contains the collections image files. For example:

```
CSV_FILE=/opt/data/ladnn/dlcs-dlcs_ladnn-2018-12-12.csv \
IMPORT_FILE_PATH=/opt/data/Masters/dlmasters/ladailynews/image/ \
bundle exec rake californica:ingest:csv
```

### Adding works to a collection

You can add a `Parent ARK` column to the CSV file.  For each row of the CSV, add the ARK for the collection that work should belong to.  The importer will find the `Collection` record with the matching ARK.  If the `Collection` record doesn't exist yet, the importer will create a new `Collection` using that ARK.

## Read-only mode
Californica has a read-only mode, which can be enabled via the `Settings` menu on the admin dashboard, and is useful for making consistent backups or migrating data.

Ideally, a user should log in as an admin, enable read-only mode, and keep the window open so they can then disable it again. If the window accidentally gets closed, and the system is stuck in read-only mode, open a rails console and fix the problem like this:

```
% RAILS_ENV=production bundle exec rails c
irb(main):006:0> Hyrax::Feature.where(key: "read_only").first.destroy!
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
