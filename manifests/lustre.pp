################################################################################
##
## Alces HPC Software Stack - Puppet configuration files
## Copyright (c) 2008-2013 Alces Software Ltd
##
################################################################################
class alceshpc::lustre (
  $lustre,
  $lustrenetworks,
  $lustretype='client',
  $lustreclient_mountpoint='/mnt/lustre',
  $lustreclient_target,
)
{

  if $alceshpc::role == 'storage' { $storage=true } else { $storage=false }

  if $lustre {

    if $lustretype=='server' {
      $lustrepackages="@lustre-server kernel-devel"
    } else {
      $lustrepackages="@lustre-client kernel-devel"
    }

    exec {'installlustre':
      command=>"/usr/bin/yum --nogpgcheck -y -e0 install ${lustrepackages}",
      logoutput=>on_failure,
      timeout=>600,
    }

    if empty($lustrenetworks) { fail 'no machine set' }

    file {'/etc/modprobe.d/alces-lustre.conf':
      ensure=>present,
      mode=>0644,
      owner=>'root',
      group=>'root',
      content=>template('alceshpc/alces-lustre.conf.erb')
    }
    if $lustretype == 'client' {

      if empty($lustreclient_target) { fail 'no lustre client target set' }

      file {'lustreclient_mountpoint':
        ensure=>directory,
        path=>$lustreclient_mountpoint
      }
      mount {'lustreclient_mount':
        name=>$lustreclient_mountpoint,
        require=>[File['lustreclient_mountpoint']],
        device=>$lustreclient_target,
        dump=>0,
        pass=>0,
        options=>"defaults,_netdev",
        fstype=>"lustre",
        ensure=>"defined"
      }
    }
  }
}
