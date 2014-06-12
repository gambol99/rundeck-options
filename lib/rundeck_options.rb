require "settings"
require "openstack-build"

module RundeckOptions
  class Application < Sinatra::Base
    set :port, Settings[:port]
    set :bind, Settings[:bind]

    def initialize 
      super
      @stack = OpenstackBuild.new(Settings[:openstack])
    end

    get '/domains' do
      domains = {}
      @stack.servers.each do |name|
        if name =~ /\./
          domain  = name.split('.').drop(1).join('.')
          domains[domain] = true unless domains.has_key? domain
        end
      end
      @list = domains.keys.map do |name|
         { :name => name, :value => name }
      end
      render
    end

    get '/hostnames' do
      domain = '\.' << ( params["domain"] || '.*' )
      @list  = @stack.servers.select { |name|
        name if name =~ /#{domain}$/
      }.map { |name|
        hostname = name.split('.').first
        { :name => hostname, :value => hostname }
      }
      render
    end
    
    get '/images' do 
      @list = @stack.images.map do |name|
        { :name => name, :value => name }
      end
      render
    end

    get '/flavors' do 
      @list = @stack.flavors.map do |name|
        { :name => name, :value => name }
      end
      render
    end

    get '/floats' do 
      @list = @stack.floats.map do |name|
        { :name => name, :value => name }
      end
      render
    end

    get '/free' do 
      @list = @stack.floats_free.map do |name|
        { :name => name, :value => name }
      end
      render
    end

    get '/networks' do 
      @list = @stack.networks.map do |name|
        { :name => name, :value => name }
      end
      render
    end  

    get '/keypairs' do 
      @list = @stack.keypairs.map do |name|
        { :name => name, :value => name }
      end
      render
    end

    get '/computes' do 
      @list = @stack.computes.map do |name|
        { :name => name, :value => name }
      end
      render
    end

    get '/servers' do
      domain = '\.' << ( params["domain"] || '.*' )
      @list  = @stack.servers.select { |name|
        name if name =~ /#{domain}$/
      }.map { |name|
        { :name => name, :value => name }
      }
      render
    end

    private 
    def render list = @list
      content_type :json
      list.to_json
    end
  end
end

