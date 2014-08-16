require 'settings'
require 'plugins'

module RundeckOptions
  class Application < Sinatra::Base
    include RundeckOptions::Plugins

    enable :logging, :static, :raise_errors
    #disable :dump_errors, :show_exceptions
    set :port, Settings[:port] || 8080
    set :bind, Settings[:bind] || '0.0.0.0'

    def initialize
      super
      load_plugins
    end

    [ :flavors, :floats, :floats_free, :networks, :images, :keypairs, :computes ].each do|m|
      get "/#{m}" do
        render_list stack.send m if stack.respond_to? m
      end
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

    get '/hostnames' do
      domain = '\.' << ( params["domain"] || '.*' )
      render_list stack.servers.select { |name|
        name if name =~ /#{domain}$/
      }.map { |name|
        name.split('.').first
      }
    end

    get '/servers' do
      domain = '[\.]?' << ( params["domain"] || '.*' )
      render_list stack.servers.select { |name|
        name if name =~ /#{domain}$/
      }
    end

    get '/stacks' do
      render_list @stacks.keys.reject { |x| x if x == :default }
    end

    private
    def stack name = params['stack']
      # step: set to the default stack if no param is set
      name = :default if name.nil?
      halt 500, "the stack: #{name} is invalid, please check"         unless name =~ /^[[:alnum:]_]+$/
      halt 500, "we have no cloud configuration defined in config"    if @stacks.empty?
      halt 500, "the stack: #{name} does not exist in configuration"  if @stacks[name].nil?
      @stacks[name]
    end

    def load_plugins
      @stacks ||= {}
      ( RundeckOptions::Settings['stacks'] || {} ).each_pair do |cloud,config|
        # step: we must have a provider
        raise ArgumentError, "the cloud configuration for: #{name} does not have a provider" unless config['provider']
        raise ArgumentError, "the cloud provider: #{config['provider']} is not supported at present" unless plugin? config['provider']
        # step: create a plugin for this cloud
        @stacks[cloud] = plugin( config )
      end
      default_stack  = Settings['default_stack']
      @stacks[:default] = ( default_stack and @stacks[default_stack] ) ? @stacks[default_stack] : @stacks[@stacks.keys.first]
      @stacks
    end

    def render_list list = []
      content_type :json
      list.map { |item|
        { :name => item, :value => item }
      }.to_json
    end
  end
end

