
class_name PlayerInfoBox
extends MarginContainer

@export var test_image = "https://cdn.discordapp.com/attachments/621586338759835668/1196891483740045472/17054315603897718671402080319310.jpg?ex=65b9470e&is=65a6d20e&hm=854ea07670209fd714a406e9c54d6a66af354db3d3118ef257243e5c3e769386&"

@onready var http_image_loader = $HttpImageLoader
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


func update_lap(lap):
	print("player box updating lap")
	lap_label.text = "laps: " + str(lap)


func hide_laps():
	lap_label.visible = false


func _on_icon_retrieved(tex : ImageTexture):
	icon_texrect.texture = tex
