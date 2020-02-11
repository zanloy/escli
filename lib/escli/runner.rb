require 'json'
require 'lp'
require 'pry'
require 'thor'
require 'yaml'

require 'main'

module ESCLI
  CURL = 'curl -sS'
  ES = 'http://prod8-elasticsearch-client.logging:9200'
  WRAPPER = 'kubectl exec -it -n zan ruby --'

  class CLI < Thor
    include Helpers

    class_option :'dry-run', type: :boolean, defaut: false, aliases: '-d'
    class_option :output, type: :string, default: 'table', aliases: '-o'
    class_option :verbose, type: :boolean, default: false, aliases: '-v'
    class_option :wrap, type: :boolean, default: false, aliases: '-w'

    #desc 'curl PATH', 'Curl the PATH'
    #method_option :path, default: '/', aliases: '-p'
    #def curl(path)
    #  cmd = "#{CURL} #{ES}/#{path}"
    #  cmd = "#{WRAPPER} #{cmd}" if options.wrap
    #  puts ".curl.cmd => #{cmd}" if options.verbose
    #  resp = %x(#{cmd}) unless options[:'dry-run']
    #  begin
    #    JSON.parse(resp)
    #  rescue
    #    resp
    #  end
    #end

    desc 'health', 'Display cluster health'
    def health
      result = curl('_cluster/health')
      output(result)
    end

    desc 'nodes', 'Subcommand for nodes'
    subcommand 'nodes', Nodes
  end #Class::CLI
end #Module::ESCLI

# vim: set ft=ruby shiftwidth=2 expandtab
