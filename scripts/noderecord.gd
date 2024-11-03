class_name NodeRecord extends Node

var node: NodeTile
var connection : Connection
var costSoFar : float
var estimatedTotalCost : float

func _init(nodeArg=null,connectionArg=null,costSoFarArg = 0, estimatedTotalCostArg = 0):
	node = nodeArg
	connection = connectionArg
	costSoFar = costSoFarArg
	estimatedTotalCost = estimatedTotalCostArg
	node.getConnections()

func getNode() -> NodeTile:
	return node

func getConnection() -> Connection:
	return connection

func getCostSoFar() -> float:
	return costSoFar
	
func getEstimatedTotalCost() -> float:
	return estimatedTotalCost
	
func setCostSoFar(cost : float) -> void:
	costSoFar = cost
	
func setEstimatedTotalCost(cost : float) -> void:
	estimatedTotalCost = cost
	
func setConnection(conn : Connection) -> void:
	connection = conn
func _to_string() -> String:
	return "Nodo: "+node._to_string()+" ETC: " + str(getEstimatedTotalCost()) + " CSF" + str(getCostSoFar())  + "\n"
