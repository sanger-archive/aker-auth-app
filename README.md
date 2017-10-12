# Aker Auth Service

This is a prototype Rails app to provide Single Sign-On for all Aker web-apps

Note: ldap.yml must be populated if this is to be used for accessing LDAP servers.
Otherwise, enable fake_ldap in the appropriate environment config file.

To set a cron job to clear out old sessions:

    0 22 * * * /bin/bash -l -c 'cd PATH/current && bundle exec bin/rails runner -e staging '\''Session.sweep'\'' >> PATH/shared/log/schedule.log 2>&1'

where PATH is the application folder.
(Note that trying to pipe the output to `../shared/log/schedule.log` will not necessarily describe the correct path if `current` is a soft link.)
