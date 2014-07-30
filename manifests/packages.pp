################################################################################
##
## Alces HPC Software Stack - Puppet configuration files
## Copyright (c) 2008-2013 Alces Software Ltd
##
################################################################################
class alceshpc::packages (
)
{
  $module_path=get_module_path('alceshpc')
  $data_path="${module_path}/data"
  
  $packages_base="${data_path}/packages_base.yml"

  $base_packages=loadyaml($packages_base)
  $profiletype_packages=loadyaml("${data_path}/packages_${alceshpc::role}.yml")
  $profile_packages=loadyaml("${data_path}/packages_${alceshpc::profile}.yml")

  $packages=inline_template("<%=((@base_packages || [])+(@profiletype_packages || [])+(@profile_packages || [])).join(' ')%>")

  exec {'installalces':
    command=>"/usr/bin/yum --nogpgcheck -y -e0 install ${packages}",
    logoutput=>on_failure,
    timeout=>1200,
    creates => '/etc/alces-release'
  }
}
