extends Node3D

# Función llamada cuando el jugador entra en el área de "Trabuc"
func _on_Trabuc_area_entered(area):
	# Desactivar el ítem "Trabuc" en la escena
	queue_free()

	# Activar el script de pistola en el personaje
	$PlayerPistolScript.set_active(true)
