# Installs the Axon Agent and the Event Generator. Private class.
# @api Private
class te_axon::install inherits te_axon {

  if $te_axon::package_manage {
    package { 'Axon Agent':
      ensure   => $te_axon::package_ensure,
      source   => $te_axon::package_source,
      name     => $te_axon::package_name,
      provider => $te_axon::package_provider,
    }
  }

  if $facts['kernel'] != 'Windows' and $te_axon::package_rtm_manage {
    package { 'tw-eg-driver':
      ensure   => $te_axon::package_rtm_ensure,
      source   => $te_axon::package_rtm_driver_source,
      name     => $te_axon::package_rtm_driver_name,
      provider => $te_axon::package_provider,
    }

    package { 'tw-eg-service':
      ensure   => $te_axon::package_rtm_ensure,
      source   => $te_axon::package_rtm_source,
      name     => $te_axon::package_rtm_name,
      provider => $te_axon::package_provider,
    }

    Package['tw-eg-driver'] -> Package['tw-eg-service']
  }
}
