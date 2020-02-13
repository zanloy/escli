require 'escli/helpers'

module Escli
  class Cluster < Thor
    include Escli::Helpers

    desc 'health', 'Display cluster health'
    def health
      result = curl('_cluster/health')
      output(result)
    end
  end
end
