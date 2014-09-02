#
#   Author: Rohith
#   Date: 2014-08-16 15:15:49 +0100 (Sat, 16 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
module RundeckOptions
  module Plugins
    class Rackspace < Plugin
      def initialize configuration
        @configuration = configuration
        @rackspace = nil
      end
      module RackspaceMethods
        [:servers, :images, :flavors ].each do |x|
          define_method x do
            rackspace.send( x ).map { |i| i.name }
          end
        end
      end
      include RackspaceMethods

      def networks
        rackspace.networks.map { |x| x.label }
      end

      alias_method :floats, :unsupported
      alias_method :floats_free, :unsupported
      alias_method :keypairs, :unsupported
      alias_method :security_groups, :unsupported
      alias_method :computes, :unsupported

      private
      def rackspace
        unless @rackspace
          @rackspace = {}
          @configuration.merge!( {
            :provider => :Rackspace
          })
          @rackspace = ::Fog::Compute.new( @configuration )
        end
        @rackspace
      end
    end
  end
end
