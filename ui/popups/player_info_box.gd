

## UI container that displays player name and profile -
## from playroom playerstate profile

class_name PlayerInfoBox
extends MarginContainer

@export var test_image = "https://cdn.discordapp.com/attachments/621586338759835668/1196891483740045472/17054315603897718671402080319310.jpg?ex=65b9470e&is=65a6d20e&hm=854ea07670209fd714a406e9c54d6a66af354db3d3118ef257243e5c3e769386&"

@onready var player_name = $VBoxContainer/PlayerName
@onready var icon_texrect = $VBoxContainer/TextureRect
@onready var lap_label = $VBoxContainer/LapLabel


func setup(racer):
	
	var state
	
	if racer is RacerPuppet:
		state = racer.player_state
	
	# player state
	elif racer is JavaScriptObject:
		state = racer
	
	var name_text = state.getProfile().name
	var color = state.getProfile().color.hexString # color as hexstring
	
	# bbcode parses hexstring
	player_name.text = "[center][color=" + color + "]" + name_text + "[center]"
	
	# try to get image
	var image_dataurl = state.getProfile().photo
	var image = _parse_dataurl(image_dataurl)
	var texture = ImageTexture.create_from_image(image)
	icon_texrect.texture = texture


func update_lap(lap):
	print("player box updating lap")
	lap_label.text = "laps: " + str(lap)


func hide_laps():
	lap_label.visible = false


func _parse_dataurl(data_url : String) -> Image:
	
	var url_data = data_url.split(",")[1] # clips the preface 
	var svg_data = url_data.uri_decode() # String.uri_decode() - parses uri
	
	var image = Image.new()
	var error = image.load_svg_from_string(svg_data) # loads svg from string
	if error != OK:
		push_error("Couldn't load the image.")
		
	return image
