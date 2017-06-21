require 'beaker-rspec'

# Install Puppet on all hosts
install_puppet_agent_on(hosts, options)

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  agent_root = ENV['TE_AXON_install_root']
  raise 'Must set TE_AXON_install_root' unless agent_root

  c.formatter = :documentation

  c.before :suite do
    # Install module to all hosts
    hosts.each do |host|
      install_dev_puppet_module_on(host, :source => module_root)

      # Copy agent installer to hosts
      logger.error('host platform is ' + host.platform.variant)
      if host.platform.variant == 'windows'
        on(host, 'mkdir c:\tmp\te_axon')
        scp_to(host, agent_root + '/windows/x86_64/Axon_Agent_x64.msi', 'c:/tmp/te_axon')
      else
        on(host, 'mkdir /tmp/te_axon')
        scp_to(host, agent_root + '/linux/x86_64/axon-agent-installer-linux-x64.rpm', '/tmp/te_axon')
        scp_to(host, agent_root + '/linux/x86_64/tw-eg-service-1.3.326-1.x86_64.rpm', '/tmp/te_axon/tw-eg-service-x86_64.rpm')
        scp_to(host, agent_root + '/linux/x86_64/tw-eg-driver-rhel-1.3.313-1.x86_64.rpm', '/tmp/te_axon/tw-eg-driver-rhel-x86_64.rpm')
      end
    end
  end
end
