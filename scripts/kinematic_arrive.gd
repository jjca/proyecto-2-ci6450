class_name KinematicArrive extends Node2D

var maxSpeed : float = 10
var velocity : Vector2 = Vector2.ZERO
var radius : float = 0.5
var timeToTarget : float = 0.5

func getSteering(target : Vector2i,character : Vector2i ):
	var char_velocity = target
	
	if char_velocity.length() < radius:
		return Vector2.ZERO
		
	char_velocity /= timeToTarget
	
	if char_velocity.length() > maxSpeed:
		char_velocity = char_velocity.normalized() * maxSpeed

	return char_velocity
