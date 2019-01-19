#!/bin/bash

bundle check || bundle install

bundle exec sidekiq &

find . -name *.pid -delete
bundle exec rails s
