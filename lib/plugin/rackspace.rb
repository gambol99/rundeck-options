#
#   Author: Rohith
#   Date: 2014-08-16 15:15:49 +0100 (Sat, 16 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
module RundeckOptions
  module Plugins
    class Rackspace
      def initialize configuration
        @configuration = configuration
        @rackspace = nil
      end
      module RackspaceMethods
        [:servers, :images, :flavors, :keypairs ].each do |x|
          define_method x do
            rackspace.send( x ).map { |i| i.name }
          end
        end
      end
      include RackspaceMethods

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
