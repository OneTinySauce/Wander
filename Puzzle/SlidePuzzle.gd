extends Sprite2D 

var puzzle_size = 3
var gap = 32
var space_x = 0
var space_y = 0
var space_row_index = 0
var space_col_index = 0
var pieces = []
var order = []
var is_moving = false

signal sloved

func _ready():
	var order_index = 0
	# hide self
	self.texture = null
	# create pieces randomly
	for i in range(9):
		order.append(i)
	randomize()
	order.shuffle()
	# testing order
	order = [0,1,2,3,4,5,6,8,7]
	for i in range(puzzle_size):
		var row = []
		for j in range(puzzle_size):
			if order[order_index] == 8:
				space_x = j * gap
				space_y = i * gap
				space_row_index = i
				space_col_index = j
				row.append(null)
			else:
				var pieces_res = load("res://Puzzle/slide_pieces.tscn")
				var piece = pieces_res.instantiate()
				# set up texture
				piece.frame = order[order_index]
				# set up postion
				piece.position.x = j * gap
				piece.position.y = i * gap
				# set up index
				piece.row_idx = i
				piece.col_idx = j
				# set up signal
				piece.moved.connect(move_piece)
				piece.move_finished.connect(move_finished)
				row.append(piece)
				add_child(piece)
			order_index += 1
		pieces.append(row)

func move_finished():
	is_moving = false

func check():
	# terverse to see if frames in order
	var correct_order = []
	var current_order = []
	var index = 0
	# init correct order
	for i in range(9):
		correct_order.append(i)
	# init current order
	for row in pieces:
		for piece in row:
			if piece:
				current_order.append(piece.frame)
			else:
				current_order.append(8)
	for num in current_order:
		if num != correct_order[index]:
			return
		index += 1
	sloved.emit()

func move_piece(piece):
	var moveable = false
	var row = piece.row_idx
	var col = piece.col_idx
	# only move piece when not moving
	if not is_moving:
		# check if able to do four directional move if space adjacent
		if row + 1 < puzzle_size:
			if pieces[row+1][col] == null:
				moveable = true
		if row - 1 >= 0:
			if pieces[row-1][col] == null:
				moveable = true
		if col + 1 < puzzle_size:
			if pieces[row][col+1] == null:
				moveable = true
		if col - 1 >= 0:
			if pieces[row][col-1] == null:
				moveable = true
		if moveable:
	#		print('row ',space_row_index,' col ',space_col_index)
			# set up movement
			piece.moving_to_x = space_x
			piece.moving_to_y = space_y
			space_x = piece.position.x
			space_y = piece.position.y
			is_moving = true
			piece.move()
			# switch the index in 2d array
			pieces[piece.row_idx][piece.col_idx] = null
			pieces[space_row_index][space_col_index] = piece
			# update new space position and indexes
			var temp_row_index = space_row_index
			var temp_col_index = space_col_index
			space_row_index = piece.row_idx
			space_col_index = piece.col_idx
			piece.row_idx = temp_row_index
			piece.col_idx = temp_col_index
	#		print('row ',space_row_index,' col ',space_col_index)
			# check if puzzle solved
			check()
		else:
			piece.shake()
	else:
		piece.shake()

func switch(obj, another):
	var obj_idx = found_in_array2d(obj)
	var another_idx = found_in_array2d(another)
	pieces[obj_idx[0]][obj_idx[1]] = another
	pieces[another_idx[0]][another_idx[1]] = obj
	
func found_in_array2d(obj):
	for i in range(pieces.size()):
		for j in range(pieces[0].size()):
			if pieces[i][j] == obj:
				return [i, j]
	
	
