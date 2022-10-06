extends Node


static func print_all_nodes(node: Node):
	if "hint_tooltip" in node and not node.hint_tooltip.empty():
		printt(node.get_path(), node.hint_tooltip)
	for n in node.get_children():
		print_all_nodes(n)
		
		
static func get_play_button_control_group(node: Node) -> Node:
	if "hint_tooltip" in node and node.hint_tooltip == "Play the project.":
		return node.get_parent()
	
	for n in node.get_children():
		var parent: Control = get_play_button_control_group(n)
		if parent: return parent
		
	return null
