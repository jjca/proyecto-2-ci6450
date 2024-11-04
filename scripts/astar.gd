class_name AStar extends Node

func astar(graph: Graph,start: NodeTile, goalNode: NodeTile, heuristic: Heuristic): #  [Connection]:
	var startRecord : NodeRecord
	startRecord = NodeRecord.new(start,null,0,heuristic.estimate(start))
	var openList : PathfindingList = PathfindingList.new()
	openList.list.append(startRecord)
	var closedList : PathfindingList = PathfindingList.new()
	var current : NodeRecord
	
	while openList.list.size() > 0:
		# Obtiene el elemento con menor costo en la lista usando el agloritmo de
		# estimatedTotalCost
		current = openList.smallestElement()
	
		# Si estamos en el nodo meta, terminamos
		if current.node.coord == goalNode.coord:
			break
		# Obtenemos todas las conexiones del nodo
		var connections : Array[Connection] = graph.getConnections(current.node)
		
		for connection in connections:
			# Creamos el endNode de cada conexion
			var endNode : NodeTile = connection.getToNode()
			var endNodeCost : float = current.getCostSoFar() + connection.getCost()
			var endNodeHeuristic : float
			var endNodeRecord : NodeRecord
			
			if closedList.nodeTileInList(endNode):
				endNodeRecord = closedList.getNodeRecord(endNode)
				if endNodeRecord.getCostSoFar() <= endNodeCost:
					continue
				closedList.list.erase(endNodeRecord)
				endNodeHeuristic = endNodeRecord.getEstimatedTotalCost() - endNodeRecord.getCostSoFar()
				
			elif openList.nodeTileInList(endNode):
				endNodeRecord = openList.getNodeRecord(endNode)
				#print("dentro del open",endNodeRecord)
				if endNodeRecord.getCostSoFar() <= endNodeCost:
					continue
				endNodeHeuristic = endNodeRecord.getEstimatedTotalCost() - endNodeRecord.getCostSoFar()
				
			else:
				endNodeRecord = NodeRecord.new(endNode,connection,endNodeCost)
				#endNodeRecord.node = endNode
				endNodeHeuristic = heuristic.estimate(endNode)
			endNodeRecord.setCostSoFar(endNodeCost)
			endNodeRecord.setConnection(connection)
			endNodeRecord.setEstimatedTotalCost(endNodeCost + endNodeHeuristic)

			if not (endNodeRecord in openList.list):
				openList.list.append(endNodeRecord)
		openList.list.erase(current)
		closedList.list.append(current)

	if current.node.coord != goalNode.coord:
		return null
	else:
		var path : Array[Connection] = []
		var nodes : PackedVector2Array
		while current.node.coord != start.coord:
			var node = current.getConnection().getToNode()
			nodes.append(node.coord)
			path.append(current.getConnection())
			current = closedList.getNodeRecord(current.getConnection().getFromNode())
		path.reverse()
		nodes.reverse()
		print(nodes)
		print(path)
		return path
