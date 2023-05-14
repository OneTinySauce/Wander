extends Sprite2D

@export var puzzle_size = 3
@export var gap = 32
var rng = RandomNumberGenerator.new()
signal sloved
signal wrong

var torchs = []

func _ready():
	# hide self
	self.texture = null
	# start at top left to generate torches
	# generate every torch with gap
	for i in range(puzzle_size):
		var row = []
		for j in range(puzzle_size):
			var torch_res = load("res://Puzzle/torch.tscn")
			var torch = torch_res.instantiate()
#			# set up the startding puzzle by turn on light randomly
#			rng.randomize()
#			if rng.randi_range(0, 1):
#				torch.light = true
			# set up postion
			torch.position.x = j * gap
			torch.position.y = i * gap
			# set up index
			torch.row_idx = i
			torch.col_idx = j
			# set up signal
			torch.toggled.connect(torch_toggled)
			row.append(torch)
		torchs.append(row)
	# a defualt set up for the puzzle WARING 3x3 only
	torchs[0][0].light = true
	torchs[0][2].light = true
	torchs[1][1].light = true
	torchs[2][0].light = true
	torchs[2][2].light = true
	# add all child in list
	for row in torchs:
		for torch in row:
			add_child(torch)

func torch_toggled(torch):
	var row = torch.row_idx
	var col = torch.col_idx
	# toggle the up down left and right torch if exsis
	if row + 1 < puzzle_size:
		torchs[row+1][col].toggle()
	if row - 1 >= 0:
		torchs[row-1][col].toggle()
	if col + 1 < puzzle_size:
		torchs[row][col+1].toggle()
	if col - 1 >= 0:
		torchs[row][col-1].toggle()
	# run check see if puzzle passed
	check()

func check():
	var correct = true
	# check to see if puzzle soulved, all light on
	for row in torchs:
		for torch in row:
			if not torch.light:
				correct = false
	if correct:
		emit_signal("sloved")
	# check if puzzle solved by all light off
	for row in torchs:
		for torch in row:
			if torch.light:
				return
	emit_signal("wrong")
	
