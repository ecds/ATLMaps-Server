# Deploynotes
The deployment is managed by Capistrano.

Global depoly settings are found in `Capfile`. Staging and Productions settings are found in `config/deploy`.

## Deploy to Staging
`cap deploy staging`

## Deploy to Productions
`cap deploy production`
In `config/initializers/assets.rb` there is a the line to compile the rails_admin assets for production:

`Rails.application.config.assets.precompile += %w( rails_admin/rails_admin.css
rails_admin/rails_admin.js )`

## Server Setup
https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04
http://www.gis-blog.com/how-to-install-postgis-2-3-on-ubuntu-16-04-lts/
https://www.phusionpassenger.com/library/install/nginx/install/oss/xenial/

### Basic Server Stuff
sudo su -
lsblk
mkfs.ext4 /dev/xvdb
mkdir /data
mount /dev/xvdb /data
vim /etc/fstab
/dev/xvdb       /data   ext4    defaults        1 1
mkdir /data/atlmaps-server
mkdir /data/atlmaps-client
chown deploy:deploy /data/*
mkdir /data/nginx

the following is from
https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04
apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
su - deploy

~/.profile:
```
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\, Branch\: \1/'
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

MYPS1=`uname -a | cut -d' ' -f 2`" / \u"

if [ $USER == "root" ]; then
        PROMPT="#"
else
   PROMPT="$"
fi

export PS1="\033[0;32m$MYPS1 \033[0;36m\t \033[0;32m[ \033[0;31m\w\033[0;32m\$(parse_git_branch)]\033[0m\033[1;30m\033[0m\n$PROMPT "
```

### RBENV
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
source ~/.profile
type rbenv
```
rbenv is a function
rbenv ()
{
    local command;
    command="$1";
    if [ "$#" -gt 0 ]; then
        shift;
    fi;
    case "$command" in
        rehash | shell)
            eval "$(rbenv "sh-$command" "$@")"
        ;;
        *)
            command rbenv "$command" "$@"
        ;;
    esac
}
```
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.2.7
Take a bathroom break or grab some coffee or beer.
rbenv global 2

#### Verify
ruby -v
ruby 2.2.7p470 (2017-03-28 revision 58194) [x86_64-linux]

### Install GIS Stuff
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt update
sudo apt install gdal-bin libgdal-dev libgeos-dev

### PostgreSQL and PostGIS
*Note, if the `depoly` user does not have sudo rights - not recommend - you will need to run sudo commands with an user that has sudo rights.*
sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update

For dev, and maybe even for staging, we'll run PostgreSQL locally. In production, we'll use AWS RDS.

#### For Dev/Staging
sudo apt install postgresql-9.6 postgresql-contrib-9.6

Create a database and user. You'll need to make note of this later for the `database.yaml`
sudo -h localhost -u <username> createuser -P <database name>

Skip this step if you are  importing a dump from an ATLMaps database.
sudo -u postgres psql -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" <database name>


#### For Production
sudo apt install postgresql-client
Setup PostGIS: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.PostGIS
Allow the instance to access the database via the RDS security group.

### Deploy the ATLMaps-Server

### Install Nginx
