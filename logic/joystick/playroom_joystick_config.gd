
## struct node to save and edit playroom joystick configurations - 
## consumed by playroom instance.
## To add buttons, add PlayroomJoyButtonConfig resources to buttons array

class_name PlayroomJoystickConfig
extends Resource


enum JOY_TYPE {DPAD, ANGULAR}

@export var joystick_type = JOY_TYPE.ANGULAR
@export var buttons : Array[Resource]


# returns a playroom joystickoptions for joystick creation
func create_joy_options() -> JavaScriptObject :
	
	# get config
	var joy_options = JavaScriptBridge.create_object("Object")
	
	# set joy type
	if joystick_type == JOY_TYPE.DPAD: joy_options.type = "dpad"
	else: joy_options.type = "angular"
	
	# JS configs
	var joy_buttons = [] 
	
	# add buttons
	for b in buttons:
		
		var joy_button = JavaScriptBridge.create_object("Object")
		
		# set up button from config
		joy_button.id = b.id
		joy_button.label = b.label
		if b.icon_url != null: joy_button.icon = b.icon_url
		
		joy_buttons.push_back(joy_button)
	
	# add buttons to joystick config
	joy_options.buttons = joy_buttons
	
	return joy_options
