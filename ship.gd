extends CharacterBody3D

@export var acceleration: Vector3 = Vector3.ONE
@export var max_speed: Vector3 = Vector3.ONE
@export var drag_coefficient: float = 1

@export var linear_velocity: Vector3 = Vector3.ZERO
@export var angular_velocity = 0

@export var mouse_sensitivity: float = 0.1
@export var roll_sensitivity: float = 1
@export var rotation_speed: float = 1
@export var target_rotation_basis = Basis()

var yaw_input: float = 0
var pitch_input: float = 0
var roll_input: float = 0

signal speed_publisher(new_speed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		yaw_input += event.relative.x * mouse_sensitivity
		pitch_input += event.relative.y * mouse_sensitivity		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_input(delta: float) -> void:
	#print("FPS: " + str(1/delta))
	
	var lateral_input: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var vertical_input: float = Input.get_axis("move_down", "move_up")
	
	var linear_input = Vector3(lateral_input.x, vertical_input, lateral_input.y)
	
	linear_velocity += linear_input * delta * acceleration
	linear_velocity = linear_velocity.clamp(-max_speed, max_speed)
	
	
	# Rotation
	roll_input = Input.get_axis("roll_right", "roll_left") * roll_sensitivity
	
	var rotation_euler = Vector3(pitch_input, yaw_input, roll_input) * delta
	target_rotation_basis = target_rotation_basis * Basis.from_euler(rotation_euler)
	target_rotation_basis = target_rotation_basis.orthonormalized()
	
	pitch_input = 0
	yaw_input = 0
	
func _physics_process(delta: float) -> void:
	get_input(delta)
	
	# Rotation
	transform.basis = transform.basis.slerp(target_rotation_basis, rotation_speed * delta)
	transform.basis = transform.basis.orthonormalized()
	
	# Linear
	var global_velocity: Vector3 = global_transform.basis * linear_velocity
	speed_publisher.emit(global_velocity.length())
	move_and_collide(global_velocity * delta)
