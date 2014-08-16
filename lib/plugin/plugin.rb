#
#   Author: Rohith
#   Date: 2014-08-16 15:34:46 +0100 (Sat, 16 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
module RundeckOptions
  module Plugins
    class Plugin
      module AbstractMethods
        [ :servers, :domains, :hostnames, :flavors, :floats, :floats_free, :networks, :images, :keypairs, :computes ].each do|m|
          raise ArgumentError, "the methods: #{m} has not been implemented by the plugin: #{self.class}"
        end
      end

      include AbstractMethods
    end
  end
end
