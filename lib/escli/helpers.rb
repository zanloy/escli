require 'json'
require 'lp'
require 'yaml'

require 'pry'

module Escli
  module Helpers
    def curl(path)
      cmd = "#{CURL} #{ES}/#{path}#{parsed_params}"
      cmd = "#{WRAPPER} #{cmd}" if options.wrap
      puts ".curl.cmd => #{cmd}" if options.verbose
      resp = %x(#{cmd}) unless options[:'dry-run']
      begin
        JSON.parse(resp)
      rescue
        resp
      end
    end

    def flatten_hash(param, prefix = nil)
      param.each_pair.reduce({}) do |a, (k, v)|
        v.is_a?(Hash) ? a.merge(flatten_hash(v, "#{prefix}#{k}.")) : a.merge("#{prefix}#{k}" => v)
      end
    end

    def stringify(obj)
      case obj
      when Array
        obj.map(&:to_s)
      when Hash
        obj.deep_merge(obj) { |_,_,v| v.to_s }
      else
        obj
      end
    end

    def output(data)
      jump_to = 'table'
      jump_to = options.output if ['json', 'table', 'yaml'].include?(options.output)
      self.send("output_#{jump_to}", data)
    end

    def output_json(data)
      puts JSON.pretty_generate(data)
    end

    def output_table(data)
      lp data
    end

    def output_yaml(data)
      puts YAML.generate(data)
    end

    def parsed_params
      return '' if options.params.empty? and Params.instance.data.empty?
      params = options.params.merge(Params.instance.data)
      out = '?'
      params.each do |k, v|
        out += k
        out += "=#{v}" if v
        out += '&'
      end
      out.delete_suffix('&')
    end
  end
end
