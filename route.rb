require 'csv'
require 'fc'
require 'pry'

def read_edges
  edges = []
  CSV.open("edges.csv").each do |csv|
    edges << Edge.new(csv[0], csv[1], csv[2].to_f, [csv[3]])
  end

  Graph.new(edges)
end

Edge = Struct.new(:source, :destination, :cost, :line)

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
    @edge_table = Hash.new { |h, k| h[k] = [] }
    @edges.each do |e|
      @edge_table[e.source] << e
    end
  end
end


# dijkstra(read_edges, "1", "260")
# crazy example, it's cheaper to swith to line 6 than to go straight from 1 to 12
# should go straight from line 1 to line 12
# seems to still be a bug; with a super high switch cost, this should flip back to to the two hop transit

def dijkstra(graph, source, destination)
  switch_cost = 20
  dist = {}
  dist[source] = 0
  visited = {}
  q = FastContainers::PriorityQueue.new(:min)
  graph.find_edges(source).map do |e|
    q.push(e, e.cost)
  end
  visited[source] = []

  q.pop_each do |e, cost|
    if e.destination == destination
      binding.pry
      return [cost, visited[e.source]+[e]]
    end
    if visited.key?(e.destination) && cost > dist[e.destination]
      next
    end
    dist[e.destination] = cost
    visited[e.destination] = visited[e.source] + [e]

    graph.find_edges(e.destination).map do |next_e|      
      line_switch = if e.line == next_e.line
        0
      else
        switch_cost
      end

      q.push(next_e, next_e.cost + line_switch + cost)
    end
  end

  return nil
end

# def class Route
#   attr_reader :cost, :path
#   def intitialize(cost:, path:)
#     @cost = cost
#     @path = path
#   end
# end

# def dijkstra_all(graph, source)
#   switch_cost = 20
#   visited = {}
#   q = FastContainers::PriorityQueue.new(:min)
#   graph.find_edges(source).map do |e|
#     q.push(e, e.cost)
#   end
#   visited[source] = Route.new(0, [])

  

#   q.pop_each do |e, cost|
#     if e.destination == destination
#       binding.pry
#       return [cost, visited[e.source]+[e]]
#     end
#     if visited.key?(e.destination) && cost > dist[e.destination]
#       next
#     end
#     dist[e.destination] = cost
#     visited[e.destination] = visited[e.source] + [e]

#     graph.find_edges(e.destination).map do |next_e|      
#       line_switch = if e.line == next_e.line
#         0
#       else
#         switch_cost
#       end

#       q.push(next_e, next_e.cost + line_switch + cost)
#     end
#   end

#   return nil
# end

def print_q(q)
  q.each { |z, c| puts "#{z}=>#{c}" }
end