require 'csv'
require 'fc'
require 'pry'

def read_edges
  edges = []
  CSV.open("edges.csv").each do |csv|
    edges << Edge.new(csv[0], csv[1], csv[2].to_f, csv[3])
  end

  Graph.new(edges)
end

Edge = Struct.new(:source, :destination, :cost, :line)
class Edge2
  attr_accessor :source, :destination, :cost, :line

  def initialize
    @line = []
  end
end

class Graph
  attr_reader :edge_table
  def initialize(edges)
    @edges = edges
    build_edge_table
  end

  def find_edges(node)
    @edge_table[node]
  end

  def build_edge_table
    builder = Hash.new { |h, k| h[k] = Edge2.new }
    @edges.each do |e|
      builder["#{e.source}-#{e.destination}"].source = e.source
      builder["#{e.source}-#{e.destination}"].destination = e.destination
      builder["#{e.source}-#{e.destination}"].cost = e.cost
      builder["#{e.source}-#{e.destination}"].line << e.line
    end

    @edge_table = Hash.new { |h, k| h[k] = [] }
    # binding.pry
    builder.each do |_, e|
      @edge_table[e.source] << e
    end
  end
end

class Route
  attr_reader :cost, :path
  def intitialize(cost:, path:)
    @cost = cost
    @path = path
  end
end


# dijkstra(read_edges, "1", "260")
# crazy example, it's cheaper to swith to line 6 than to go straight from 1 to 12
# should go straight from line 1 to line 12
# at node 93, there are two paths with the same cost to get there
# we end up needing the other path
# to carry forward with the lowest cost

def dijkstra(graph, source, destination)
  dist = {}
  dist[source] = 0
  visited = {}
  path = {}
  q = FastContainers::PriorityQueue.new(:min)
  q.push(source, 0)
  path[source] = []

  q.pop_each do |point, cost|
    if point == destination
      return [cost, path[point]]
    end
    if visited.key?(point) && cost >= dist[point]
      next
    end
    visited[point] = 1
    dist[point] = cost

    current_path = path[point]

    graph.find_edges(point).map do |next_e|      
      path[next_e.destination] = current_path + [next_e]

      cp_line = source != point ? current_path.last.line : []
      line_switched = source != point && (cp_line & next_e.line).length == 0
      line_switch = line_switched ? 15 : 0

      q.push(next_e.destination, next_e.cost + line_switch + cost)
    end
  end

  return nil
end

def dijkstra_all(graph, source)
  dist = {}
  dist[source] = 0
  visited = {}
  path = {}
  q = FastContainers::PriorityQueue.new(:min)
  q.push(source, 0)
  path[source] = []

  q.pop_each do |point, cost|
    if visited.key?(point) && cost >= dist[point]
      next
    end
    visited[point] = 1
    dist[point] = cost

    current_path = path[point]

    graph.find_edges(point).map do |next_e|      
      path[next_e.destination] = current_path + [next_e]

      cp_line = source != point ? current_path.last.line : []
      line_switched = source != point && (cp_line & next_e.line).length == 0
      line_switch = line_switched ? 15 : 0

      q.push(next_e.destination, next_e.cost + line_switch + cost)
    end
  end

  return [dist, path]
end

def print_q(q)
  q.each { |z, c| puts "#{z}=>#{c}" }
end

def run
  # pp dijkstra(read_edges, "1", "260")
  full_edges = []
  full_matrix = []
  0.upto(303).each do |source|
    source = source.to_s
    dist, path = dijkstra_all(read_edges, source)
    matrix_row = []
    0.upto(303).map do |dest|
      dest = dest.to_s
      matrix_row << dist[dest].to_i || 100000
      # full_edges << [source, dest, dist[dest], path.map(&:destination)]
    end
    full_matrix << matrix_row
  end

  CSV.open("full_matrix.csv", "w") do |csv|
    full_matrix.each do |r|
      csv << r
    end
  end

  "done"
  # pp full_edges
  # full_matrix.map { |r| puts(r.map{ |c| c.to_s.rjust(5)}.join) }
end
