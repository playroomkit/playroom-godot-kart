

## UI container that displays player name and profile -
## from playroom playerstate profile

class_name PlayerInfoBox
extends MarginContainer


@onready var player_name = $VBoxContainer/PlayerName
@onready var icon_texrect = $VBoxContainer/TextureRect
@onready var lap_label = $VBoxContainer/LapLabel


func setup(racer):
	
	var state
	
	# input is racer
	if racer is RacerPuppet:
		state = racer.player_state
	
	# input is player state
	elif racer is JavaScriptObject:
		state = racer
	
	#print("RACER INFO BOX SETUP :")
	#print(state.getProfile().photo)
	
	var name_text = state.getProfile().name
	var color = state.getProfile().color.hexString # color as hexstring
	
	# bbcode parses hexstring
	player_name.text = "[center][color=" + color + "]" + name_text + "[center]"
	
	# try to get image
	var image_dataurl = await _wait_get_image(state)
	var image = _parse_dataurl(image_dataurl)
	var texture = ImageTexture.create_from_image(image)
	icon_texrect.texture = texture


func update_lap(lap):
	print("player box updating lap")
	lap_label.text = "laps: " + str(lap)


func hide_laps():
	lap_label.visible = false


# TODO awaits the state image profile 
func _wait_get_image(state):
	# temp?
	var photo = null
	
	while !photo is String:
		print("pinging profile...")
		photo = state.getProfile().photo
		await get_tree().create_timer(1).timeout
	
	return photo 
	


func _parse_dataurl(data_url : String) -> Image:
	
	var url_data = data_url.split(",")[1] # clips the preface 
	var svg_data = url_data.uri_decode() # String.uri_decode() - parses uri
	
	var image = Image.new()
	var error = image.load_svg_from_string(svg_data) # loads svg from string
	if error != OK:
		push_error("Couldn't load the image.")
		
	return image
