require "yaml"

module RundeckOptions
  class Settings
    CONFIG_FILE = File.join(File.dirname(__FILE__),'../config/settings.yml')

    def self.settings
      @settings ||= YAML.load(File.read(CONFIG_FILE))
    end

    def self.[](key)
      settings[key.to_s]
    end
  end
end
