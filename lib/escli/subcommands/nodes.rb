module ESCLI
  class Nodes < Thor
    desc 'list', 'list all nodes'
    def list
      curl('_nodes')
    end
  end
end
