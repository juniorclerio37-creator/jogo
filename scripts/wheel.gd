extends Control
var angle: float = 0:
 set(value):
  angle = value
  queue_redraw()
func _draw():
 var c = size/2
 var colors = ["e8ad55","48b99a","6f9ddb","df8c83","a78bd0","d7bc68"]
 var names = ["Moedas","XP","Giros","Baú","Cristais","Bônus"]
 for i in range(6):
  var points = PackedVector2Array([c])
  for j in range(21):
   var a = angle + (i+j/20.0)*TAU/6 - PI/2
   points.append(c+Vector2.from_angle(a)*145)
  draw_colored_polygon(points,Color(colors[i]))
  var middle = angle+(i+0.5)*TAU/6-PI/2
  draw_string(ThemeDB.fallback_font,c+Vector2.from_angle(middle)*95-Vector2(25,-6),names[i],HORIZONTAL_ALIGNMENT_CENTER,65,18,Color("102b3a"))
 draw_circle(c,26,Color("123445"))
 draw_colored_polygon(PackedVector2Array([c+Vector2(-15,-158),c+Vector2(15,-158),c+Vector2(0,-132)]),Color("fff0bf"))
