################################################################################
##
## Alces HPC Software Stack - Puppet configuration files
## Copyright (c) 2008-2014 Alces Software Ltd
##
################################################################################
class alceshpc (
  #Generic Alces variables
  #Supported profiles:
  # - generic
  $profile = hiera('alcesbase::profile','generic'),
  #Supported roles:
  # - slave
  # - master
  $role = hiera('alcesbase::role','slave'),
  #Supported machines
  # - generic
  $machine = hiera('alcesbase::machine','generic'),
  #Cluster name:
  $clustername = hiera('alcesbase::clustername','alcescluster'),
  #HA (ha enabled?)
  $ha = $alcesbase::ha,
  #Keep os jitter minimal
  $jitter=$alcesbase::jitter
)
{

  class { 'alceshpc::packages':
  }

  class { 'alceshpc::lustre':
    lustre=>hiera('alceshpc::lustre',false),
    lustrenetworks=>hiera('alceshpc::lustrenetworks',undef),
    lustretype=>hiera('alceshpc::lustretype','client'),
    lustreclient_mountpoint=>hiera('alceshpc::lustreclient_mountpoint','/mnt/lustre'),
    lustreclient_target=>hiera('alceshpc::lustreclient_target',undef)
  }

  class { 'alceshpc::limits':
  }

  class { 'alceshpc::scheduler':
    gridscheduler=>hiera('alceshpc::scheduler::gridscheduler',true),
    torque=>hiera('alceshpc::scheduler::torque',false),
    schedulerrole=>hiera('alceshpc::schedulerrole','client'),
  }

}
