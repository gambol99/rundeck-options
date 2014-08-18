#
#   Author: Rohith
#   Date: 2014-08-16 15:16:03 +0100 (Sat, 16 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
module RundeckOptions
  module Plugins
    require 'plugin/plugin'
    require 'plugin/openstack'
    require 'plugin/rackspace'

    def plugin name, configuration = {}
      raise ArgumentError, "the plugin: #{name} does not exists" unless plugin? name
      RundeckOptions::Plugins.const_get( name.to_sym ).new configuration
    end

    def plugin? name
      plugins.include? name.to_sym
    end

    private
    def plugins
      RundeckOptions::Plugins.constants.select do |x|
        Class === RundeckOptions::Plugins.const_get( x )
      end
    end
  end
end
