# Manages the Axon Agent and Event Generator services. Private class.
# @api Private
class te_axon::service inherits te_axon {

  if $te_axon::service_manage {
    service { 'tripwire-axon-agent':
      ensure     => $te_axon::service_ensure,
      enable     => $te_axon::service_enable,
      name       => $te_axon::service_name,
      provider   => $te_axon::service_provider,
      hasstatus  => true,
      hasrestart => true,
    }
  }

  if $te_axon::service_rtm_manage {
    service { 'tw-eg-service':
      ensure     => $te_axon::service_rtm_ensure,
      enable     => $te_axon::service_rtm_enable,
      name       => $te_axon::service_rtm_name,
      provider   => $te_axon::service_rtm_provider,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
