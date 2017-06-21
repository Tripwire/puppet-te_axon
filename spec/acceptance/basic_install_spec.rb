require 'spec_helper_acceptance'

describe 'te_axon basic install' do

  if host_inventory['platform'] == 'windows'
    manifest = <<-EOS
      class { 'te_axon':
        package_source   => 'c:/tmp/te_axon/Axon_Agent_x64.msi',
        bridge_host      => 'teconsole.example.com',
        registration_key => 'foobar',
        tags => {
          'tag_set1' => ['1_tag1', '1_tag2'],
          'tag_set2' => '2_tag1'
        },
      }
    EOS
    config_dir = 'C:\ProgramData\Tripwire\agent\config'
    package_name = 'Axon Agent'
    service_name = 'TripwireAxonAgent'
    eg_service_name = 'TripwireEventGeneratorService'
  else
    manifest = <<-EOS
      class { 'te_axon':
        package_source            => '/tmp/te_axon/axon-agent-installer-linux-x64.rpm',
        package_rtm_source        => '/tmp/te_axon/tw-eg-service-x86_64.rpm',
        package_rtm_driver_name   => 'tw-eg-driver-rhel',
        package_rtm_driver_source => '/tmp/te_axon/tw-eg-driver-rhel-x86_64.rpm',
        bridge_host               => 'teconsole.example.com',
        registration_key          => 'foobar',
        tags => {
          'tag_set1' => ['1_tag1', '1_tag2'],
          'tag_set2' => '2_tag1'
        },
      }
    EOS
    config_dir = '/etc/tripwire'
    package_name = 'axon-agent'
    service_name = 'tripwire-axon-agent'
    eg_service_name = 'tw-eg-service'
  end

  config_file = config_dir + '/twagent.conf'
  tag_file = config_dir + '/metadata.yml'
  reg_key_file = config_dir + '/registration_pre_shared_key.txt'

  it 'should run without errors' do
    result = apply_manifest(manifest, :catch_failures => true)
  end

  it 'should run a second time without changes' do
    result = apply_manifest(manifest, :catch_changes => true)
  end

  # Axon config directory should exist
  describe file(config_dir) do
    it { should be_directory }
  end

  # Configuration file should exist and have the bridge, port, and spool size set
  describe file(config_file) do
    it { should exist }
    its(:content) { should match /bridge\.host=teconsole\.example\.com/ }
    its(:content) { should match /bridge\.port=5670/ }
    its(:content) { should match /spool.size.max=1g/ }
  end

  # Tag file for the Axon agent should exist with proper content
  describe file(tag_file) do
    its(:content_as_yaml) { should include('tagSets' => include('tag_set1' => include('1_tag1')))}
    its(:content_as_yaml) { should include('tagSets' => include('tag_set1' => include('1_tag2')))}
    its(:content_as_yaml) { should include('tagSets' => include('tag_set2' => '2_tag1'))}
  end

  # Axon agents registration key should exist and contain the test password
  describe file(reg_key_file) do
    it { should exist }
    its(:content) { should match /foobar/ }
  end

  # Axon agent should be installed
  describe package(package_name) do
    it { should be_installed }
  end

  # Axon service should be running
  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end

  # Axon EG service installed and be running
  describe service(eg_service_name) do
    it { should be_enabled }
    it { should be_running }
  end

  # EG Port should be listening
  describe port(1169) do
    it { should be_listening }
  end
end
