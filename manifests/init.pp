# == Class: iptables
#
# Sets up our iptables module
#
# === Parameters:
#
# [*file*]
#
# The location of the target file where our rules will live.  Defaults to
# /etc/sysconfig/iptables
#
# [*file6*]
#
# The location of the target file where our ip6tables rules will reside.
# Defaults to /etc/sysconfig/ip6tables
#
class iptables (
  $iptables_file = 'UNSET',
  $ip6tables_file = 'UNSET',
  $version = 'UNSET',
) {

  ##############################################################################
  # Parameter Validation
  ##############################################################################
  $config = $iptables_file ? {
    'UNSET'   => '/etc/sysconfig/iptables',
    default => $iptables_file,
  }

  $config6 = $ip6tables_file ? {
    'UNSET'   => '/etc/sysconfig/ip6tables',
    default => $ip6tables_file,
  }

  validate_absolute_path( $config )
  validate_absolute_path( $config6 )

  # This is used to ensure consistent join separators when generating the order
  # for the concat fragments
  $join_separator = '_'

  $table_order_width = 1
  $table_order = {
    comment => 0,
    filter  => 1,
    nat     => 2,
    mangle  => 3,
    raw     => 4,
  }

  $chain_order_width = 1
  $chain_order = {
    table         => 0,
    name          => 1,
    'INPUT'       => 2,
    'OUTPUT'      => 3,
    'FORWARD'     => 4,
    'PREROUTING'  => 5,
    'POSTROUTING' => 6,
    other         => 8,
    commit        => 9,
  }

  $rule_order_width = 3
  # These are more as a guideline, and not set in stone
  # infra_allow    - infrastructure rules that should rarely change and not be
  #                   overridden
  # temp_rules      - temporary rules
  # specific_allows - host-specific allows
  # specific_denys  - host-specific denies
  # global_allows   - global allows
  # catchall_reject - reject any non-matching rules
  $rule_order = {
    infra           => 0,
    temp            => 200,
    specific_allow  => 400,
    'default'         => 500,
    specific_deny   => 600,
    global_allows   => 800,
    catchall_reject => 999,
  }

  $order = {
    table => $table_order,
    chain => $chain_order,
    rule  => $rule_order,
  }
}
