tool
extends EditorPlugin


var debug = preload("res://addons/crucial_shortcuts/debug.gd")


var _last_played_scene: String

# TODO: Close and reopen a script


func _ready():
#	debug.print_all_nodes(get_tree().root)
	pass
	
	
func _enter_tree():
	var button: Button = Button.new()
	button.text = "Play Memorized Scene"
	button.hint_tooltip = "Play Last Memorized Scene"
	
	var play_buttons_container: Control = _get_play_button_control_group(get_tree().root)
	play_buttons_container.add_child(button)
	
	var c = button.connect("pressed", self, "play_last_played_scene")
	assert(c == OK)


func _unhandled_key_input(event: InputEventKey) -> void:
	if not event.is_pressed(): return
	if get_editor_interface().get_script_editor().has_focus(): return

	match event.scancode:
		KEY_L:
			position_nodes_to_mouse_position()
		KEY_H:
			toggle_visibility_of_nodes()
		KEY_P:
			select_parent_of_node()
		KEY_O:
			open_selected_nodes_script()
		KEY_M, KEY_F7:
			play_last_played_scene()


func position_nodes_to_mouse_position():
	var nodes: Array = get_editor_interface().get_selection().get_selected_nodes()
	for node_ in nodes:
		if node_ as Node2D:
			var node: Node2D = node_
			node.global_position = node.get_global_mouse_position()
		elif node_ as Control:
			var node: Control = node_
			node.rect_position = node.get_global_mouse_position()


func toggle_visibility_of_nodes():
	var nodes: Array = get_editor_interface().get_selection().get_selected_nodes()
	for node_ in nodes:
		if node_ as CanvasItem:
			var node: CanvasItem = node_
			node.visible = not node.visible


func select_parent_of_node():
	var selected_nodes: Array = get_editor_interface().get_selection().get_selected_nodes()
	if selected_nodes.empty(): return

	for node in selected_nodes:
		get_editor_interface().get_selection().remove_node(node)

	get_editor_interface().get_selection().add_node(selected_nodes[0].get_parent())
	
	
func open_selected_nodes_script():
	var selected_nodes: Array = get_editor_interface().get_selection().get_selected_nodes()
	if selected_nodes.empty(): return
	
	var selected_node: Node = selected_nodes[0]
	var script: Script = selected_node.get_script()
	
	if not script: return
	
	get_editor_interface().edit_script(script)
	get_editor_interface().set_main_screen_editor("Script")
	
	
func play_last_played_scene():
	if Input.is_key_pressed(KEY_SHIFT) or _last_played_scene.empty():
		_last_played_scene = get_editor_interface().get_edited_scene_root().filename
	
	if _last_played_scene.empty(): return
	
	get_editor_interface().play_custom_scene(_last_played_scene)
	
	
func _get_play_button_control_group(node: Node) -> Node:
	if "hint_tooltip" in node and node.hint_tooltip == "Play the project.":
		return node.get_parent()
	
	for n in node.get_children():
		var parent: Control = _get_play_button_control_group(n)
		if parent: return parent
		
	return null
