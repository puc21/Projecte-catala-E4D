extends Node3D

# Variables para el control de la cámara
var sensitivity_mouse_camera = 0.3
var pitch_degrees_camera = 0.0

# Variables para el control del movimiento
var speed_character = 5.0

# Referencias a los nodos internos
var character_body: CharacterBody3D
var camera_node: Camera3D
var audio_player: AudioStreamPlayer

# Variables para el sonido
var sound_timer = 0.0
var sound_interval = 1.0  # Intervalo de reproducción de sonido en segundos
var sound_files: Array = ["sound1.ogg", "sound2.ogg", "sound3.ogg"]

# Referencia al script de la pistola
var pistol_script: PlayerPistolScript

func _ready():
	# Obtener referencias a los nodos internos
	character_body = $CharacterBody3D  # Ajusta según la estructura real de tu escena
	camera_node = $Camera3D
	audio_player = $AudioStreamPlayer  # Ajusta según el nombre real de tu nodo AudioStreamPlayer
	pistol_script = $PlayerPistolScript  # Ajusta según el nombre real del script de la pistola

	# Preload de los sonidos
	for sound_index in sound_files.size():
		sound_files[sound_index] = "res://sounds/" + sound_files[sound_index]

func _process(delta):
	# Obtener la entrada del ratón
	var mouse_motion = Input.get_action_strength("mouse_x")  # Ajusta "mouse_x" según la acción que maneja el ratón
	var mouse_speed_y = Input.get_action_strength("mouse_y")  # Ajusta "mouse_y" según la acción que maneja el ratón

	# Rotar el personaje en el eje Y (giro horizontal)
	rotate_y(deg_to_rad(-mouse_motion * sensitivity_mouse_camera))

	# Actualizar la inclinación (pitch) en el eje X (giro vertical)
	pitch_degrees_camera += mouse_speed_y * sensitivity_mouse_camera
	pitch_degrees_camera = clamp(pitch_degrees_camera, -90, 90)

	# Aplicar la rotación a la cámara
	camera_node.rotation_degrees.x = pitch_degrees_camera

	# Obtener la entrada del teclado para el movimiento
	var movement = Vector3()

	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		# Se ha presionado alguna de las teclas w, a, s, d
		sound_timer += delta
		if sound_timer > 0.5:
			# Ha pasado 0.5 segundos desde que se presionó la tecla
			sound_timer = 0.0  # Reiniciar el temporizador

			# Reproducir sonido aleatorio
			var random_sound_path = sound_files[randi() % sound_files.size()]
			var random_sound = ResourceLoader.load(random_sound_path)

			if random_sound:
				audio_player.stream = random_sound
				audio_player.play()

			# Activar el script de la pistola
			pistol_script.set_active(true)
	else:
		# No se está presionando ninguna tecla, reiniciar el temporizador
		sound_timer = 0.0

		# Desactivar el script de la pistola
		pistol_script.set_active(false)

	# Normalizar el vector de movimiento para que la velocidad sea la misma en todas las direcciones
	movement = movement.normalized()

	# Obtener la matriz de transformación del personaje
	var character_transform = character_body.global_transform

	# Transformar el vector de movimiento en relación con la rotación del personaje
	movement = character_transform.basis.xform(movement)

	# Aplicar el movimiento al personaje
	character_body.translation += movement * speed_character * delta
