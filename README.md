# te_axon

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with te_axon](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with te_axon](#beginning-with-te_axon)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

The te_axon module installs, configures, and manages the services of the
Tripwire Axon Agent.

## Setup

### Setup Requirements

The Tripwire Axon Agent needs a Tripwire Enterprise Console server
to connect to. A DNS SRV record can be created so that the Agent can discover
the Console server automatically. Otherwise, the Axon bridge host and port must be provided.
If the Axon bridge requires a key, the key must be provided as a parameter as well.

The Agent install files must be staged somewhere on the target system. This can
be a network drive, or you can use a separate `file` resource to manually copy
the package files to the target system.

The MSI provider for Windows is a little more forgiving and may work with URLs
or network drive paths. Newer versions of RPM also work with URLs.

### Beginning with te_axon

At minimum, you must supply the source to the Agent install package.

```puppet
class { 'te_axon':
  package_source => 'http://files.example.com/tripwire/Axon_Agent_x64.msi'
}
```

On Linux, you must also supply the Event Generator service and driver packages.

```puppet
class { 'te_axon':
  package_source            => 'http://files.example.com/tripwire/axon-agent-installer-linux-x64.rpm',
  package_rtm_source        => 'http://files.example.com/tripwire/tw-eg-service-x86_64.rpm',
  package_rtm_driver_name   => 'tw-eg-driver-rhel',
  package_rtm_driver_source => 'http://files.example.com/tripwire/tw-eg-driver-rhel-x86_64.rpm'
}
```

## Usage

All parameters for the te_axon module are contained within the main `te_axon` class, so for any function of the module, set the options you want. See the common usages below for examples.

Examples omit the required parameters for brevity.

### Setting Bridge options

```puppet
class { 'te_axon':
  package_source   => 'http://files.example.com/tripwire/Axon_Agent_x64.msi',
  bridge_host      => 'teconsole.example.com'
  registration_key => 'correct horse battery staple'
}
```

### Setting Custom Tags

```puppet
class { 'te_axon':
  ...
  tags => {
    'tagset_1' => 'tag1',
    'tagset_2' => ['tag2a', 'tag2b'],
  },
}
```

## Reference

Available at https://tripwire.github.io/puppet-te_axon/

The full reference documentation can be generated with Puppet Strings:

```
$ bundle exec rake strings:generate
```

HTML documentation will be created under the ./doc/ directory.

## Limitations

The te_axon module was tested with Puppet 4.10, though it should work on 4.9
or later (or Puppet Enterprise 2017.1 or later).

The following Operating Systems have been tested with this module:

* Red Hat 5, 6, 7
* CentOS 5, 6, 7
* Windows 7, 8.1, 10, Server 2008 R2, Server 2012 R2, Server 2016

Other versions may work if they are supported by both Puppet and the Tripwire Axon Agent.

## Development

See the [contribution guidelines](CONTRIBUTING.md) for more information.
