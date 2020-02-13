require 'escli/helpers'
require 'filesize'

module Escli
  class Nodes < Thor
    include Escli::Helpers

    LIST_FILTER = [:id, :name, :host, :ip, :version, :roles]
    STATS_METRICS = [:adaptive_selection, :breaker, :discovery, :fs, :http, :indices, :ingest, :jvm, :os, :process, :thread_pool, :transport]
    STATS_FILTER = [
      'name',
      'host',
      'ip',
      'roles',
      'indices.indexing.index_total',
      'indices.indexing.index_time_in_millis',
      'indices.indexing.index_failed',
      'indices.indexing.is_throttled',
      'indices.get.total',
      'indices.get.time_in_millis',
      'indices.search.query_total',
      'indices.search.query_time_in_millis',
      'indices.merges.current',
      'indices.merges.total',
      'os.cpu.percent',
      'os.cpu.load_average.1m',
      'os.cpu.load_average.5m',
      'os.cpu.load_average.15m',
      'os.mem.used_percent',
      'process.cpu.percent',
      'jvm.mem.heap_used_percent',
      'fs.total.total_in_bytes',
      'fs.total.free_in_bytes',
      'transport.rx_size_in_bytes',
      'transport.tx_size_in_bytes',
      'ingest.total.count',
      'ingest.total.time_in_millis',
      'ingest.total.current',
      'ingest.total.failed'
    ]

    desc 'list', 'list all nodes'
    def list
      resp = curl('_nodes')
      if options.raw then
        output(resp)
        return
      end
      # Filter response down
      results = []
      resp['nodes'].each do |node|
        id, values = node
        values['id'] = id
        values['roles'] = values['roles'].join(', ')
        results << values.slice(*stringify(LIST_FILTER))
      end
      output(results)
    end

    desc 'stats', 'show stats for nodes'
    method_option :list, type: :boolean, default: false, aliases: 'l'
    def stats(args = nil)
      if options.list then
        output(stringify(STATS_METRICS))
        return
      end
      # TODO: Validate each args value to STATS_METRICS
      Params.instance.add('metric', args) if args
      resp = curl('_nodes/stats')
      if options.raw then
        output(resp)
        return
      end
      # Start filtering out lesser used data
      results = []
      resp['nodes'].each do |node|
        _, values = node
        values_flat = flatten_hash(values)
        values = values_flat.slice(*STATS_FILTER)
        values['roles'] = values['roles'].join(', ')
        results << values.each_pair.reduce({}) do |a,(k,v)|
          if k.end_with?('_in_bytes') then
            a.merge(k.delete_suffix('_in_bytes') => Filesize.from("#{v} B").pretty)
          else
            a.merge(k => v)
          end
        end
      end
      output(results)
    end
  end
end
