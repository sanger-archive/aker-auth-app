# Aker - Auth app

[![Build Status](https://travis-ci.org/sanger/aker-auth-app.svg?branch=devel)](https://travis-ci.org/sanger/aker-auth-app)
[![Maintainability](https://api.codeclimate.com/v1/badges/6f25335ed5bf756e9688/maintainability)](https://codeclimate.com/github/sanger/aker-auth-app/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/6f25335ed5bf756e9688/test_coverage)](https://codeclimate.com/github/sanger/aker-auth-app/test_coverage)

This is Rails app provides Single Sign-On for all Aker web-apps

Note: ldap.yml must be populated if this is to be used for accessing LDAP servers.
Otherwise, enable fake_ldap in the appropriate environment config file.

To set a cron job to clear out old sessions:

    0 22 * * * /bin/bash -l -c 'cd PATH/current && bundle exec bin/rails runner -e staging '\''Session.sweep'\'' >> PATH/shared/log/schedule.log 2>&1'

where PATH is the application folder.
(Note that trying to pipe the output to `../shared/log/schedule.log` will not necessarily describe the correct path if `current` is a soft link.)
