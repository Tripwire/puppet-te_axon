# Writes agent configuration files. Private class.
# @api Private
class te_axon::config inherits te_axon {

  if $te_axon::registration_key {
    # The agent will delete the registration key on startup, and we don't want
    # puppet re-creating it every time. There isn't a way to conditionally
    # create a file, so we have to use an exec command with a condition.
    $cmd = $facts['kernel'] ? {
      windows => "cmd.exe /c echo \"${te_axon::registration_key}\" > ${te_axon::config_path}\\${te_axon::registration_filename}",
      default => "/bin/echo \"${te_axon::registration_key}\" > ${te_axon::config_path}/${te_axon::registration_filename}",
    }
    exec { 'echo_key':
      command => $cmd,
      # not exactly...
      creates => "${te_axon::config_path}/${te_axon::registration_filename}.done",
    }
    file { 'key.done':
      ensure => file,
      path   => "${te_axon::config_path}/${te_axon::registration_filename}.done",
    }
    Exec['echo_key'] -> File['key.done']
  }

  if $te_axon::tags{
    $tags = { tagSets => $te_axon::tags }
    file { 'metadata.yml':
      ensure  => file,
      path    => "${te_axon::config_path}/metadata.yml",
      content => inline_template('<%= @tags.to_yaml %>')
    }
  }

  file { 'twagent.conf':
    ensure  => file,
    path    => "${te_axon::config_path}/twagent.conf",
    content => epp('te_axon/twagent.conf.epp')
  }

}
