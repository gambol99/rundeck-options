#
#   Author: Rohith
#   Date: 2014-08-16 15:15:44 +0100 (Sat, 16 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
module RundeckOptions
  module Plugins
    class Openstack < Plugin
      def initialize configuration
        @configuration = configuration
        @openstack = nil
      end
      module OpenstackMethods
        [:servers, :images, :flavors].each do |x|
          define_method x do
            compute.send( x ).map { |i| i.name }
          end
        end
      end
      include OpenstackMethods

      def security_groups
        compute.security_groups.map { |x| x.name }
      end

      def keypairs
        compute.key_pairs.map { |x| x.name }
      end

      def networks
        network.networks.map { |x| x.name }
      end

      def computes
        compute.list_hosts.body['hosts'].inject([]) do |a,host|
          a << host['host_name'] if host['service'] == 'compute'
          a
        end
      end

      def floats
        network.list_floating_ips.body['floatingips'].map { |float| float['floating_ip_address'] }
      end

      def floats_free
        network.list_floating_ips.body['floatingips'].select { |float|
          float if float['port_id'].nil?
        }.map { |float| float['floating_ip_address'] }.sort
      end

      private
      def compute
        openstack[:compute]
      end

      def network
        openstack[:network]
      end

      def openstack
        unless @openstack
          @openstack = {}
          @configuration.merge!( {
            :provider => :OpenStack
          })
          @openstack[:compute] = ::Fog::Compute.new( @configuration )
          @openstack[:network] = ::Fog::Network.new( @configuration )
        end
        @openstack
      end
    end
  end
end

