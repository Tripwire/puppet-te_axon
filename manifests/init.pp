#
# Main class. Contains all private classes.
#
# @ api public
#
# @summary The te_axon class installs, configures, and manages the services of the
#   Tripwire Axon Agent.
#
# @example Minimal configuration
#    class { 'te_axon':
#      package_source => 'http://files.example.com/tripwire/Axon_Agent_x64.msi'
#    }
#
# @example Bridge options
#    class { 'te_axon':
#      package_source   => 'http://files.example.com/tripwire/Axon_Agent_x64.msi',
#      bridge_host      => 'teconsole.example.com'
#      registration_key => 'correct horse battery staple'
#    }
#
# @example Linux Event Generator packages
#    class { 'te_axon':
#      package_source            => 'http://files.example.com/tripwire/axon-agent-installer-linux-x64.rpm',
#      package_rtm_source        => 'http://files.example.com/tripwire/tw-eg-service-x86_64.rpm',
#      package_rtm_driver_name   => 'tw-eg-driver-rhel',
#      package_rtm_driver_source => 'http://files.example.com/tripwire/tw-eg-driver-rhel-x86_64.rpm'
#    }
#
# @example Custom tag sets
#    class { 'te_axon':
#      ...
#      tags => {
#        'tagset_1' => 'tag1',
#        'tagset_2' => ['tag2a', 'tag2b'],
#      },
#    }
#
# @param package_manage Whether to manage the Axon Agent package. Default: `true`
# @param package_ensure Whether to install the Axon Agent package. Default: `installed`
# @param package_install_path Path to install the Axon Agent package. Default: varies by operating system
# @param package_source The path to the Axon Agent installer. **Required**
# @param package_name The name of the Axon Agent package. Default: varies by operating system
# @param package_provider Which package provider to use to manage the Axon Agent package. Default: `undef`
# @param package_rtm_manage Whether to manage the Event Generator service. Does not apply to Windows. Default: `true`
# @param package_rtm_ensure Whether to install the Event Generator service. Default: `installed`
# @param package_rtm_name The name of the Event Generator service package. Default: varies by operating system
# @param package_rtm_source The path to the Event Generator service package. **Required** if package_rtm_manage is `true`.
# @param package_rtm_driver_name The name of the Event Generator driver. Default: varies by operating system
# @param package_rtm_driver_source The path to the Event Generator driver package. **Required** if package_rtm_manage is `true`.
# @param config_path Path to write Axon Agent configuration files. Default: varies by operating system
# @param dns_srvc_name DNS service name to look up. Default: `_tw-agw`
# @param dns_srvc_domain A specific domain to use when looking up the DNS SRV record. Default: `undef`.
#   The agent will use the domain of the IP addresses assigned to the host.
# @param bridge_host A specific agent bridge host to connect to. Default: `undef`
# @param bridge_port A specific agent bridge port to connect to. Default: `5670`
# @param registration_filename File to write the registration pre-shared key. Default: `registration_pre_shared_key.txt`
# @param registration_key Registration pre-shared key. Should be the same as the one specified in the
#   Axon Bridge `bridge.properties` file. Default: `undef`
# @param proxy_hostname Hostname for a SOCKS 5 proxy server to connect through. Default: `undef`
# @param proxy_port Port for a SOCKS 5 proxy server to connect through. Default: `undef`
# @param proxy_username Username for a SOCKS 5 proxy server to connect through. Default: `undef`
# @param proxy_password Password for a SOCKS 5 proxy server to connect through. Default: `undef`
# @param tls_version Use a specific TLS version when connecting. Default: `undef`
# @param tls_cipher_suites Use a specific set of TLS cipher suites when connecting.
#   Valid values are FIPS-compatible OpenSSL cipher suites which utilize an RSA key. Default: `undef`
# @param logger_level Can be set to `DEBUG` to enable debug logging from the agent. Default: `undef`
# @param spool_size The maximum size of the agent spool. Default: `1g` (1 gigabyte)
# @param tags Tags to automatically apply to the node when registered.
#  Format is a Hash of tag set names to tag values, or an array of tag values. Optional.
# @param service_enable Whether to enable the Axon Agent service to start at boot. Default: `true`
# @param service_ensure Whether the Axon Agent service should be running. Default: `running`
# @param service_manage Whether to manage the Axon Agent service. Default: `true`
# @param service_name The Axon Agent service name to manage. Default value: varies by operating system
# @param service_provider Which service provider to use for the Axon Agent service. Default: `undef`.
# @param service_rtm_enable Whether to enable the Event Generator service to start at boot. Default: `true`
# @param service_rtm_ensure Whether the Event Generator service should be running. Default: `running`
# @param service_rtm_manage Whether to manage the Event Generator service. Should only be used if `install_rtm` is `true`. Default: `true`
# @param service_rtm_name The Event Generator service name to manage. Default: varies by operating system
# @param service_rtm_provider Which service provider to use for the Event Generator service. Default: `undef`.
class te_axon (
  Boolean $package_manage,
  String $package_ensure,
  String $package_install_path,
  String $package_source,
  String $package_name,
  Optional[String] $package_provider,
  Boolean $package_rtm_manage,
  String $package_rtm_ensure,
  String $package_rtm_name,
  Optional[String] $package_rtm_source,
  String $package_rtm_driver_name,
  Optional[String] $package_rtm_driver_source,
  String $config_path,
  String $dns_srvc_name,
  Optional[String] $dns_srvc_domain,
  Optional[String] $bridge_host,
  Integer[0, 65535] $bridge_port,
  String $registration_filename,
  Optional[String] $registration_key,
  Optional[String] $proxy_hostname,
  Optional[Integer[0, 65535]] $proxy_port,
  Optional[String] $proxy_username,
  Optional[String] $proxy_password,
  Optional[Enum['TLSv1', 'TLSv1.1', 'TLSv1.2']] $tls_version,
  Optional[String] $tls_cipher_suites,
  Optional[String] $logger_level,
  String $spool_size,
  Optional[Hash] $tags,
  Boolean $service_enable,
  Enum['running', 'stopped'] $service_ensure,
  Boolean $service_manage,
  String $service_name,
  Optional[String] $service_provider,
  Boolean $service_rtm_enable,
  Enum['running', 'stopped'] $service_rtm_ensure,
  Boolean $service_rtm_manage,
  String $service_rtm_name,
  Optional[String] $service_rtm_provider,
) {

  contain te_axon::install
  contain te_axon::config
  contain te_axon::service

  Class['::te_axon::install']
  -> Class['::te_axon::config']
  ~> Class['::te_axon::service']
}
