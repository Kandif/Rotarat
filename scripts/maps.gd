extends Node2D

func succed(index):
	if index<12:
		$maps1.get_node("map"+str(index)).succed()
		$maps2.get_node("map"+str(index)).succed()
		
		$maps1.get_node("map"+str(index+1)).unlock()
		$maps2.get_node("map"+str(index+1)).unlock()
	else:
		$maps1.get_node("map"+str(index)).succed()
		$maps2.get_node("map"+str(index)).succed()

func _ready():
	for map in $maps1.get_children():
		map.get_node("Container").connect("mouse_entered",self,"focus",[map])
	for map in $maps2.get_children():
		map.get_node("Container").connect("mouse_entered",self,"focus",[map])
	for map in $maps1.get_children():
		map.get_node("Container").connect("gui_input",self,"click",[map])
	for map in $maps2.get_children():
		map.get_node("Container").connect("gui_input",self,"click",[map])
		
	$rat1.rotation_degrees = $maps1/map1.rotation_degrees
	$rat1.global_position = $maps1/map1.global_position+Vector2(0,-50).rotated($rat1.rotation)
	$rat2.rotation_degrees = $maps2.get_node("map1").rotation_degrees
	$rat2.global_position = $maps2.get_node("map1").global_position+Vector2(0,-50).rotated($rat2.rotation)	
		
	var index = 1
	for map in GameStatus.maps:
		if index==1 && map==false:
			$maps1.get_node("map"+str(index)).unlock()
			$maps2.get_node("map"+str(index)).unlock()
		if map && index<12:
			$maps1.get_node("map"+str(index)).succed()
			$maps2.get_node("map"+str(index)).succed()
			$maps1.get_node("map"+str(index+1)).unlock()
			$maps2.get_node("map"+str(index+1)).unlock()
		elif map:
			$maps1.get_node("map"+str(index)).succed()
			$maps2.get_node("map"+str(index)).succed()	
		index+=1

func focus(map):
	if !map.disabled_map:
		if map.get_parent().name == "maps1":
			$rat1.rotation_degrees = map.rotation_degrees
			$rat1.global_position = map.global_position+Vector2(0,-50).rotated($rat1.rotation)
			$rat2.rotation_degrees = $maps2.get_node(map.name).rotation_degrees
			$rat2.global_position = $maps2.get_node(map.name).global_position+Vector2(0,-50).rotated($rat2.rotation)
			
		if map.get_parent().name == "maps2":
			$rat2.rotation_degrees = map.rotation_degrees
			$rat2.global_position = map.global_position+Vector2(0,-50).rotated($rat2.rotation)
			$rat1.rotation_degrees = $maps1.get_node(map.name).rotation_degrees
			$rat1.global_position = $maps1.get_node(map.name).global_position+Vector2(0,-50).rotated($rat1.rotation)

func click(event,map):
	if event.is_pressed() && event is InputEventMouseButton && visible && !map.disabled_map:	
		var id = int(map.name.substr(3))
		get_parent().to_game(id)
