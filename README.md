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
1. Copy `.env.sample` to `.env.development`. This will set certain required
environment variables for your local development environment. If you want to customize them, make those changes to `.env.develoment`.
1. Setup your database.
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

At this point, you can start a development server with: `bundle exec rake hydra:server`.

To support running individual tests (or run the application test suite without restarting
the test servers), you can do `bundle exec rake hydra:test_server`. Once the servers have
started, you can run `bundle exec rake spec` to run the RSpec tests.

### Troubleshooting

1. If you have trouble with `nokogiri`, see
   [_Installing Nokogiri_](http://www.nokogiri.org/tutorials/installing_nokogiri.html) for
   troubleshooting.

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
