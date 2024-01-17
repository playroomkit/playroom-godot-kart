
class_name PlayerInfoBox
extends MarginContainer

@export var test_image = "https://cdn.discordapp.com/attachments/621586338759835668/1196891483740045472/17054315603897718671402080319310.jpg?ex=65b9470e&is=65a6d20e&hm=854ea07670209fd714a406e9c54d6a66af354db3d3118ef257243e5c3e769386&"

@onready var http_image_loader = $HttpImageLoader
@onready var player_name = $VBoxContainer/PlayerName
@onready var icon_texrect = $VBoxContainer/TextureRect
@onready var lap_label = $VBoxContainer/LapLabel


func setup(racer : RacerPuppet):
	
	var state = racer.player_state
	player_name.text = state.getProfile().name
	#var image = state.getProfile().photo
	
	# image
	#http_image_loader.create_http_request(image, _on_icon_retrieved)


func update_lap(lap):
	print("player box updating lap")
	lap_label.text = lap


func _on_icon_retrieved(tex : ImageTexture):
	icon_texrect.texture = tex
