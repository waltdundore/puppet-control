#testing
node default {
  include ::profiles::vagrant
  include ::profiles::packages
  include ::profiles::docker_netbox
}

#include selinux

class { 'selinux':
  mode => 'permissive',
  type => 'targeted',
}

include epel


###############
# sudo config #
###############
include sudo

sudo::conf { 'puppet_puppet':
    content  => 'puppet ALL=NOPASSWD: /usr/opt/puppetlabs/bin/puppet, /usr/local/opt/puppetlabs/bin/puppet',
  }

# default permissions of 644 for files and 755 for directories
File { mode => '0644' }

# files default to being owned by root
File {
  owner => root,
  group => root,
}

# ignore version control when recursively managing directories
File { ignore => ['.svn', '.git', 'CVS' ] }



# default options for mounts
Mount {
  dump => 0,
  pass => 0,
}

Package {
  allow_virtual => true,
}
