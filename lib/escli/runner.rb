require 'config'
require 'thor'

require 'escli/helpers'
require 'escli/params'
require 'escli/subcommands/all'

module Escli
  CURL = 'curl -sS'
  ES = 'http://prod8-elasticsearch-client.logging:9200'
  WRAPPER = 'kubectl exec -it -n zan ruby --'

  class Runner < Thor
    include Helpers

    class_option :'dry-run', type: :boolean, defaut: false, aliases: '-d'
    class_option :output, type: :string, default: 'table', aliases: '-o'
    class_option :params, type: :hash, default: {}, aliases: '-p'
    class_option :verbose, type: :boolean, default: false, aliases: '-v'
    class_option :wrap, type: :boolean, default: false, aliases: '-w'

    def initialize(*args)
      super
      Config.load_and_set_settings([File.expand_path('~/.escli/config.yaml')])
      # Verify clusters exists
      raise "FATAL: No clusters set in config file. Verify at least 1 cluster is configured." unless Settings.has_key? :clusters
      # Load current_cluster settings
      Settings.es = Settings.has_key?(:current_cluster) ? Settings.clusters[Settings.current_cluster] : Settings.clusters.first
      # If we don't have a valid endpoint then Error
      unless Settings.es.has_key? :endpoint
        raise 'FATAL: No endpoint is set for the currently configured cluster'
      end
      Settings.options = options
      options.each do |k,v|
        Settings[k] = v
      end
      binding.pry
    end

    desc 'cluster', 'Cluster level commands'
    subcommand 'cluster', Cluster

    desc 'nodes', 'Nodes level commands'
    subcommand 'nodes', Nodes

    desc 'health', 'Displays cluster health - alias to "escli cluster health"'
    def health
      cluster = Cluster.new
      cluster.options = options
      cluster.health
    end

    desc 'repl', 'Start this application in REPL (interactive) mode.'
    def repl
      require 'readline'
      require 'thor_repl'
      ThorRepl.start(self.class, prompt: 'escli> ')
    end
  end
end
