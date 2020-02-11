module ESCLI
  module Helpers
    def curl(path)
      cmd = "#{CURL} #{ES}/#{path}"
      cmd = "#{WRAPPER} #{cmd}" if options.wrap
      puts ".curl.cmd => #{cmd}" if options.verbose
      resp = %x(#{cmd}) unless options[:'dry-run']
      begin
        JSON.parse(resp)
      rescue
        resp
      end
    end

    def output(data)
      jump_to = 'table'
      jump_to = options.output if ['json', 'table', 'yaml'].include?(options.output)
      self.send("output_#{jump_to}", data)
    end

    def output_json(data)
      puts JSON.generate(data)
    end

    def output_table(data)
      lp data
    end

    def output_yaml(data)
      puts YAML.generate(data)
    end
  end #Module::Helpers
end #Module::ESCLI
