# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----

# ---- original file header ----
#
# @summary
#   
#
Puppet::Functions.create_function(:'iptables::format_reject') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    
    rej = ''
    rej = args[0] if args[0].is_a?(String)

    ver = '4'
    ver = args[1][-1].chr if args[1][-1].chr == '6'

    return rej if rej == ''

    # create a translation table so reject types from iptables
    # and ip6tables can be used as interchangeably as possible,
    # though its not perfect.
    translations = {
      # v4 to v6 translations
      'icmp-net-unreachable' => 'icmp6-no-route',
      'icmp-host-unreachable' => 'icmp6-addr-unreachable',
      'icmp-port-unreachable' => 'icmp6-port-unreachable',
      'icmp-proto-unreachable' => 'icmp6-port-unreachable',
      'icmp-net-prohibited' => 'icmp6-adm-prohibited',
      'icmp-host-prohibited' => 'icmp6-adm-prohibited',
      'icmp-admin-prohibited' => 'icmp6-adm-prohibited',
      # v6 to v4 translations
      'icmp6-no-route' => 'icmp-net-unreachable',
      'no-route' => 'icmp-net-unreachable',
      'icmp6-adm-prohibited' => 'icmp-admin-prohibited',
      'adm-prohibited' => 'icmp-admin-prohibitied',
      'icmp6-addr-unreachable' => 'icmp-host-unreachable',
      'addr-unreach' => 'icmp-addr-unreachable',
      'icmp6-port-unreachable' => 'icmp-port-unreachable',
      'port-unreach' => 'icmp-port-unreachable'
    }

    valid_rejects = {
      '4' => [ 'icmp-net-unreachable', 'icmp-host-unreachable',
               'icmp-port-unreachable', 'icmp-proto-unreachable',
               'icmp-net-prohibited', 'icmp-host-prohibited',
               'icmp-admin-prohibited' ],
      '6' => [ 'icmp6-no-route', 'no-route', 'icmp6-adm-prohibited',
               'adm-prohibited', 'icmp6-addr-unreachable', 'addr-unreach',
               'icmp6-port-unreachable', 'port-unreach' ]
    }

    if ( ver == '4' and valid_rejects['6'].include?(rej) ) or
       ( ver == '6' and valid_rejects['4'].include?(rej) ) then
       rej = translations[rej]
    end
    return "--reject-with #{rej}"
  
  end
end
