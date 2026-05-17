extends TextureRect

const WIDTH := 2000
const HEIGHT := 1500
const NUM_STARS := 2500
const MIN_RADIUS := 1
const MAX_RADIUS := 4

func _ready():
	randomize()

	var img := Image.create(WIDTH, HEIGHT, false, Image.FORMAT_RGB8)
	img.fill(Color(0, 0, 0))

	for i in range(NUM_STARS):
		var x := randi() % WIDTH
		var y := randi() % HEIGHT
		var radius := randi() % (MAX_RADIUS - MIN_RADIUS + 1) + MIN_RADIUS

		var r := (randi() % 65 + 191) / 255.0
		var g := (randi() % 65 + 191) / 255.0
		var b := (randi() % 65 + 191) / 255.0
		var col := Color(r, g, b)

		for dy in range(-radius, radius + 1):
			for dx in range(-radius, radius + 1):
				if dx * dx + dy * dy <= radius * radius:
					var px := x + dx
					var py := y + dy
					if px >= 0 and px < WIDTH and py >= 0 and py < HEIGHT:
						img.set_pixel(px, py, col)

	var tex := ImageTexture.create_from_image(img)

	self.texture = tex
