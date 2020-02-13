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

    desc 'cluster', 'Cluster level commands'
    subcommand 'cluster', Cluster
    desc 'nodes', 'Nodes level commands'
    subcommand 'nodes', Nodes

    desc 'health', 'Displays Cluster health'
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
