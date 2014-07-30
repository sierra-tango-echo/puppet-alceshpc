################################################################################
##
## Alces HPC Software Stack - Puppet configuration files
## Copyright (c) 2008-2013 Alces Software Ltd
##
################################################################################
class alceshpc::limits (

)
{
  file {'/etc/security/limits.d/alces.conf':
    ensure=>present,
    mode=>0644,
    owner=>root,
    group=>root,
    content=>multitemplate(
            "alceshpc/dynamic/limits/$alceshpc::machine/alces.conf",
            "alceshpc/dynamic/limits/$alceshpc::profile/alces.conf",
            "alceshpc/dynamic/limits/$alceshpc::role/alces.conf",
            "alceshpc/dynamic/limits/generic/alces.conf")
  }
}
