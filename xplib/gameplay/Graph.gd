extends Object

# We assume that the graph is 1-indexed but the graph
# itself is zero-indexed, watch for off-by-ones

var _adjacency_matrix

func _init(n):
	_adjacency_matrix = []
	for i in range(n + 1):
		var row = PackedInt32Array()
		for j in range(n + 1):
			row.append(0)
		_adjacency_matrix.append(row)

# Given two nodes, start and end, returns an array with the shortest
# path between the two. In the event that end is unreachable from start,
# returns an empty array.
# End can also be an array of nodes, in which case we return the shortest
# path that reaches any of them.
func shortest_path(start: int, end) -> Array:
	var queue = []
	var visited = {}
	var parents = {}
	var path = []
	var end_nodes = {}
	if typeof(end) == TYPE_ARRAY:
		for i in end:
			end_nodes[i] = i
	else:
		end_nodes[end] = end
	queue.push_front(start)
	visited[start] = start
	while queue.size() != 0:
		var v = queue.pop_back()
		# if we find the end node, reconstruct the path
		if end_nodes.has(v):
			path.push_back(v)
			while v != start:
				v = parents[v]
				path.push_front(v)
			return path
		for neighbor in neighbors(v):
			if not visited.get(neighbor):
				parents[neighbor] = v
				visited[neighbor] = neighbor
				queue.push_front(neighbor)
	return path

# Given an array of nodes, sort them in an order that will preserve the connected
# component, this ends up being kind of a flood fill.
func sort_nodes(nodes) -> Array:
	var queue = []
	var visited = {}
	var sorted = []
	var nodes_set = {}
	for node in nodes:
		nodes_set[node] = node
	if !nodes_set.has(1):
		push_error("A node set should contain node 1")
		return []
	nodes_set.erase(1)
	queue.push_front(1)
	visited[1] = 1
	sorted.push_back(1)
	while queue.size() != 0:
		var v = queue.pop_back()
		for neighbor in neighbors(v):
			if nodes_set.get(neighbor) and !visited.get(neighbor):
				visited[neighbor] = neighbor
				nodes_set.erase(neighbor)
				sorted.push_back(neighbor)
				queue.push_front(neighbor)
	return sorted

# Given an array of nodes, checks if all of them are connected in a way that is
# allowed by the graph. Returns true if the nodes are connected, false if not.
# An empty array of nodes returns true.
func is_connected_component(nodes) -> bool: 
	nodes = nodes.duplicate()
	if nodes.size() <= 1:
		# an empty set of nodes is connected, as is a set of 1 node
		return true
	var queue = []
	var visited = {}
	var nodes_set = {}
	var first = nodes.pop_front()
	for node in nodes:
		nodes_set[node] = node
	queue.push_front(first)
	visited[first] = first
	while queue.size() != 0:
		var v = queue.pop_back()
		for neighbor in neighbors(v):
			if not visited.get(neighbor) and nodes_set.get(neighbor):
				visited[neighbor] = neighbor
				nodes_set.erase(neighbor)
				queue.push_front(neighbor)
	return nodes_set.size() == 0

func add_edge(from, to, edge_type = 1):
	#TODO: handle edge_type for wormholes, etc.... maybe?
	_adjacency_matrix[from - 1][to - 1] = 1
	_adjacency_matrix[to - 1][from - 1] = 1

func neighbors(node) -> Array:
	var row = _adjacency_matrix[node - 1]
	var neighbors = []
	for i in range(row.size() - 1):
		if row[i] == 1:
			neighbors.push_back(i + 1)
	return neighbors

func neighboring_edges(node) -> Array:
	var row = _adjacency_matrix[node - 1]
	var edges = []
	for i in range(row.size() - 1):
		if row[i] == 1:
			var edge
			if node < i + 1:
				edge = [node, i + 1]
			else:
				edge = [i + 1, node]
			edges.push_back(edge)
	return edges
