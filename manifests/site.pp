node default {
#  include ::roles::standalone
}


class { selinux:
  mode => 'permissive',
  type => 'targeted',
}

package { 'git':
  ensure => installed,
}


###############
# sudo config #
###############
include sudo

sudo::conf { 'puppet_puppet':
    content  => 'puppet ALL=NOPASSWD: /usr/bin/puppet, /usr/local/bin/puppet',
  }
sudo::conf { 'vagrant':
  content => "Defaults:vagrant !requiretty\nvagrant ALL=(ALL) NOPASSWD: ALL",
}

#################
# docker config #
#################
#class { 'docker':
#  docker_users => ['wdundore'],
#}



# default path for commands
#Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }

# by default all files overwritten by puppet
# will be backed up on the puppetmaster
#filebucket { 'main':  server => 'puppet.apidb.org' }
#File { backup => main }

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
