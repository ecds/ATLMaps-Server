**ATLMaps Quick Setup Guide**
*March 3 2016*
*Yang*

**Background**
The ATLMap app requires two major components:
>- ATLMaps-Server
>- ATLMaps-Client

In the GitHub README.md of ATLMaps-Server there is a very good diagram that illustrates the relationship of how different components talk with each other. See it yourself here:
https://github.com/emory-libraries-ecds/ATLMaps-Server

**Checkout repositories**
Request to be added to the Emory ECDS group on GitHub
https://github.com/emory-libraries-ecds

**The two repositories are:**
https://github.com/emory-libraries-ecds/ATLMaps-Client
https://github.com/emory-libraries-ecds/ATLMaps-Server

**Quick checkout commands:**
```
git clone git@github.com:emory-libraries-ecds/ATLMaps-Client.git
git clone git@github.com:emory-libraries-ecds/ATLMaps-Server.git
```

**Backend Setup**
We’d usually like to bundle the backend:
```
cd [project directory]
bundle
```

**Ruby Version**
Use rbenv.
Version defined in `.ruby-version`


If bundle fails on the postgresql then it is more than likely that you would need to install pg correctly.
The first time I tried the .pkg from postgresql’s official website but it didn’t go too far. Do not recommend using the .pkg.
And you can get postgresql on a Mac by using brew like this:

```brew install postgresql```

**Once brew finishes the installation it will print out information like:**

```
If builds of PostgreSQL 9 are failing and you have version 8.x installed,
you may need to remove the previous version first. See:
  https://github.com/Homebrew/homebrew/issues/2510

To migrate existing data from a previous major version (pre-9.0) of PostgreSQL, see:
  http://www.postgresql.org/docs/9.5/static/upgrading.html

To migrate existing data from a previous minor version (9.0-9.4) of PosgresSQL, see:
  http://www.postgresql.org/docs/9.5/static/pgupgrade.html

  You will need your previous PostgreSQL installation from brew to perform `pg_upgrade`.
  Do not run `brew cleanup postgresql` until you have performed the migration.

To have launchd start postgresql at login:
  ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents

Then to load postgresql now:
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

Or, if you don't want/need launchctl, you can just run:
  postgres -D /usr/local/var/postgres

==> Summary
🍺  /usr/local/Cellar/postgresql/9.5.1: 3,118 files, 35M
```

And now we can use ```postgres -D /usr/local/var/postgres``` to start the service or setup lauchctld

**Some helpful commands in postgresql:**
```
createuser -s -r postgres (run this in bash)
create database atlmaps_api_dev; (run this in postgresql command)
```

**All the gitignored files**
Please collect these files from Emory developers or create your own.
```application.rb``` in ```$AppRoot/config/```
```database.yml``` in ```$AppRoot/config/```
```devise.rb``` in ```$AppRoot/config/initializers/```

**next you’d need to get a database dump and import as follows:**
import a database dump
```psql atlmaps_api_dev < atlmaps.pg```
* this assumes that you have the database named atlmaps_api_dev created in postgresql

**now you can do rails s to start the backend:**

**local DNS setup**
In our particular setup we use a DNS that is required for routing to work. So you would need to edit your hosts file and on a Mac it is:
```sudo vi /etc/hosts```
and append this entry:
```0.0.0.0         api.atlmaps-dev.com```

Now you should be able to use the domain name and port 3000 to access the backend like this:
```api.atlmaps-dev.com:3000```

**A few samplers to know that your app is up and running**
```
http://api.atlmaps-dev.com:3000/v1/projects/24 - example
http://api.atlmaps-dev.com:3000/admin - admin panel
```
