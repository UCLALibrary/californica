#!/bin/bash

bundle exec sidekiq &

find . -name *.pid -delete
bundle exec rails s
