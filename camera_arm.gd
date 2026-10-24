extends Node3D

@export var target: CharacterBody3D
@export var offset: Vector3 = Vector3(0, 1, 2)
@export var lead_time: float = 0.25

@export var spring_strength: float = 18.0
@export var damping: float = 6.0

@export var rot_strength: float = 12.0
@export var rot_damping: float = 5.0

var velocity: Vector3 = Vector3.ZERO
var ang_velocity: Vector3 = Vector3.ZERO  # radians/sec axis-angle form


func _physics_process(delta: float) -> void:
	# Target
	var target_pos = target.global_position - target.linear_velocity * lead_time
	# Position Spring
	var move_to_pos = target_pos + (target.basis * offset)

	var displacement = move_to_pos - global_position
	var accel = displacement * spring_strength - velocity * damping

	velocity += accel * delta
	global_position += velocity * delta

	look_at(target_pos, target.global_basis.y)
