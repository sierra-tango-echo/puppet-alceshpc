################################################################################
##
## Alces HPC Software Stack - Puppet configuration files
## Copyright (c) 2008-2013 Alces Software Ltd
##
################################################################################
class alceshpc::scheduler (
  $schedulertype,
  $schedulerrole,
  $ha=$alceshpc::ha,
)
{
  if $schedulertype == 'alces-gridscheduler' {
      user{'geadmin':
        uid=>'360',
        gid=>'360',
        shell=>'/sbin/nologin',
        home=>'/opt/alces/pkg/services/gridscheduler/2011.11p1_155',
        ensure=>present,
        require=>Group['geadmin'],
      }
      group{'geadmin':
        ensure=>present,
        gid=>'360',
      }
      if $schedulerrole == 'master' {
        package {'alces-gridscheduler':
          ensure=>installed
        }
        service {'qmaster.alces-gridscheduler':
          enable=>!$ha,
          require=>Package['alces-gridscheduler']
        }
        file {'/var/lib/alces/share/alces-gridscheduler-config.tgz':
          ensure=>present,
          mode=>600,
          owner=>'root',
          group=>'root',
          source=>'puppet:///modules/alceshpc/scheduler/alces-gridscheduler-config.tgz',
          require=>File['/var/lib/alces/share']
        }
        file {'/var/lib/alces/bin/init-gridscheduler.sh':
          ensure=>present,
          mode=>700,
          owner=>'root',
          group=>'root',
          source=>'puppet:///modules/alceshpc/scheduler/init-gridscheduler.sh',
          require=>File['/var/lib/alces/bin/']
        }
        exec {'unpack-gridscheduler-config':
          command=>'tar -zxvf /var/lib/alces/share/alces-gridscheduler-config.tgz -C /',
          creates=>'/var/spool/gridscheduler',
          require=>File['/var/lib/alces/share/alces-gridscheduler-config.tgz']
        }
      }
      else {
        file{'/etc/init.d/execd.alces-gridscheduler':
          ensure=>present,
          owner=>'root',
          group=>'root',
          mode=>'744',
          source=>'puppet:///modules/alceshpc/scheduler/execd.alces-gridscheduler',
        }
        service{'execd.alces-gridscheduler':
          enable=>true,
          require=>File['/etc/init.d/execd.alces-gridscheduler']
        }
      }
  } elsif $schedulertype	== 'alces-torque' {
      if $alceshpc::profile == 'compute' {
        file{'/etc/init.d/pbs_mom':
          ensure=>present,
          owner=>'root',
          group=>'root',
          mode=>'744',
          source=>'puppet:///modules/alceshpc/scheduler/pbs_mom.init',
         }
        service{'pbs_mom':
          enable=>true,
          require=>File['/etc/init.d/pbs_mom']
        }
      }
  }
}
