require 'singleton'

module Escli
  class Params
    include Singleton

    attr_accessor :data

    def initialize
      @data = {}
    end

    def add(key, value)
      @data[key] = value
    end
  end
end
