#!/bin/bash

cd testing
bundle
bundle install
rake db:migrate && RAILS_ENV=development rake agendador:setup
