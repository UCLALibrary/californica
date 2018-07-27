UCLA Library Management -- Tenejo
=================================

[![Build Status](https://travis-ci.org/UCLALibrary/californica.svg?branch=master)](https://travis-ci.org/UCLALibrary/californica) [![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

Development
-----------

### Prerequisites

Requirements:
1. Ruby and Bundler
1. Postgres, Redis, Node.js, and Java
1. Various build tools (Ubuntu packages are listed below - not sure about other
   distros...)

#### Virtual Machine

Work to set up a cannonical VM image for the project is ongoing at https://github.com/UCLALibrary/packer-samvera.
In the meantime, a minimal Vagrantfile looks something like:
```Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "private_network", ip: "192.168.50.4"

  config.vm.provider "virtualbox" do |v|
    v.memory = 4092
    v.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update && apt-get install -y build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev ruby-bundler postgresql nodejs redis-server default-jre
  SHELL
end
```


As currently configured, solr and fedora data is stored inside the project
directory at `californica/tmp/`. If this is in your VM's shared directory,
performance will not be good. It might be a good idea to move this data to e.g.
`/samvera-data/`. This location is set in `fcrepo_wrapper`, `.solr_wrapper`,
`conf/fcrepo_wrapper_test.yml` and `conf/solr_wrapper_test.yml`.

#### Ubuntu

- Use Ubuntu 18.04 or newer. Older releases don't come with the required version of ruby.
- Install prerequisities with `sudo apt-get update && sudo apt-get install -y build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev ruby-bundler postgresql nodejs redis-server default-jre`
- Once installed, postgres should run automatically under the `postgres` user.
  For the `psql` console, use: `sudo -u postgres psql`


### Installation

1. Clone the project repository:
   `git clone https://github.com/UCLALibrary/californica.git; cd californica`
1. Install dependencies
   `bundle install`
1. Setup your database. SEE THE SECTION IMMEDIATELY FOLLOWING FOR MORE DETAILS!
   We use PostgreSQL. To support the test and development environments, you'll
   need have Postgres installed and running. In your `psql` console do
   `create role californica with createdb login;`. Then do
   `bundle exec rake db:setup` to setup the create the database and schema.
1. Start redis
   `redis-server &`
   (Ubuntu starts Redis automatically, so this will just complain that the port
   is already taken and exit.)
1. Run the CI suite
   `bundle exec rake ci`

### Important details for PostgreSQL security and configuration

The instructions above assume your PostgreSQL server is configured to allow authentication to password-less user accounts. This is an insecure configuration for Postgresql. 
If you would like to enable your PostgreSQL server to allow authentication to password-less user accounts, you must edit your pg_hba.conf config file (typically in the /etc/postgresql file tree somewhere), and change the line that reads:
`host    all             all             127.0.0.1/32            md5`
to
`host    all             all             127.0.0.1/32            trust`

However, we recommend you consider creating your californica role with a password, by entering the
following in your `psql` console:
`create user californica CREATEDB PASSWORD californica;`

NOTE: If you DO create your californica role with a password, you will *need* to use a `dotenv` file. See the Configuration with `dotenv` section below.

At this point, you can start a development server with: `bundle exec rake hydra:server`.

To support running individual tests (or run the application test suite without restarting
the test servers), you can do `bundle exec rake hydra:test_server`. Once the servers have
started, you can run `bundle exec rake spec` to run the RSpec tests.

#### Troubleshooting

1. If you have trouble with `nokogiri`, see
   [_Installing Nokogiri_](http://www.nokogiri.org/tutorials/installing_nokogiri.html) for
   troubleshooting.

#### Configuration with `dotenv`

We use [`dotenv`](https://github.com/bkeepers/dotenv#usage) to manage configuration
across environments. [`.env.sample`](./.env.sample) lists the variables
configurable in this way, along with plausible development defaults.

If you want custom configuration in development and test environments, you can add a
`.env`, `.env.development` and/or `.env.test`, all of which are ignored by Git.
Custom configuration here may require some custom setup (e.g. using password
authentication for the your database user).

If you are only trying to ensure that the dev and test environments utilize the password 
you've set for your californica role, we recommend you use a single `.env` file by copying
`.env.sample` to `.env` ... If you know what you're doing and want separate `.env.development` 
and `.env.test` files, there are instructions in `.env.sample` which we recommend you read.

In production, these environment variables should be set by `.env.production` at
deploy time and from a secret source.

## Creating an admin user
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
