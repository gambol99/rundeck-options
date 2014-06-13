require "settings"
require "openstack-build"

module RundeckOptions
  class Application < Sinatra::Base
    set :port, Settings[:port] || 8080
    set :bind, Settings[:bind] || '0.0.0.0'

    def initialize 
      super
      @stacks = validate_config
    end

    get '/computes' do 
      render_list stack.computes
    end

    get '/domains' do
      domains = {}
      stack.servers.each do |name|
        if name =~ /\./
          domain  = name.split('.').drop(1).join('.')
          domains[domain] = true unless domains.has_key? domain
        end
      end
      render_list domains.keys
    end

    get '/flavors' do 
      render_list stack.flavors
    end

    get '/floats' do 
      render_list stack.floats
    end

    get '/free' do 
      render_list stack.floats_free
    end
    
    get '/hostnames' do
      domain = '\.' << ( params["domain"] || '.*' )
      render_list stack.servers.select { |name|
        name if name =~ /#{domain}$/
      }.map { |name|
        name.split('.').first
      }
    end

    get '/images' do 
      render_list stack.images.map
    end

    get '/networks' do 
      render_list stack.networks
    end  

    get '/keypairs' do 
      render_list stack.keypairs
    end

    get '/servers' do
      domain = '\.' << ( params["domain"] || '.*' )
      render_list stack.servers.select { |name|
        name if name =~ /#{domain}$/
      }
    end

    get '/stacks' do 
      render_list @stacks.keys
    end

    private 
    def stack name = params['stack']
      name = :default if name.nil?
      halt 500, "the stack: #{name} is invalid, please check"         unless name =~ /^[[:alnum:]_]+$/ 
      halt 500, "we have not openstack cluster defined"               if @stacks.empty?
      halt 500, "the stack: #{name} does not exist in configuration"  unless @stacks[name].nil?
      @stacks[name]
    end

    def validate_config 
      stacks = {}
      ( Settings['stacks'] || {} ).keys.each do |stack|
        # step: skip unless we have everything we need
        next unless Settings['stacks'][stack].is_a? Hash
        next unless %w(username tenant api_key auth_url).all { |x| true if Settings['stacks'][stack].has_key? x }
        stacks[name] = OpenstackBuild.new(Settings['stacks'][stack])
      end
      default_stack    = Settings['default_stack']
      stacks[:default] = ( default_stack and stacks[default_stack] ) ? Settings[default_stack] : stacks.keys.first 
      stacks
    end

    def render_list list = []
      content_type :json
      list.map { |item|
        { :name => name, :value => name }  
      }.to_json
    end
  end
end

