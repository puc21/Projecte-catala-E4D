extends StaticBody3D

# Variables de movimiento de la bala
var velocity: Vector3 = Vector3.ZERO

# Función llamada en cada frame
func _process(delta):
	# Mover la bala
	transform.origin += velocity * delta

# Función llamada cuando la bala colisiona con algo
func _on_Bullet_body_entered(body):
	# Verificar si la colisión es con un personaje
	if body.has_method("bullet_hit"):
		body.bullet_hit()

	# Eliminar la bala de la escena
	queue_free()
