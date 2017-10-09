# Aker Auth Service

This is a prototype Rails app to provide Single Sign-On for all Aker web-apps

Note: ldap.yml must be populated if this is to be used for accessing LDAP servers.
Otherwise, enable fake_ldap in the appropriate environment config file.

To set a cron job to clear out old sessions:

    0 22 * * * /bin/bash -l -c 'cd PATH && bundle exec bin/rails runner -e staging '\''Session.sweep'\'' >> ../shared/log/schedule.log 2>&1'

where PATH is where the application is running
