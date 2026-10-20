extends Control
func _draw():
 var offset = Vector2(size.x/2-140,15)
 var shape = PackedVector2Array([Vector2(30,55),Vector2(95,35),Vector2(120,0),Vector2(160,40),Vector2(255,60),Vector2(290,115),Vector2(240,155),Vector2(215,220),Vector2(160,270),Vector2(135,320),Vector2(105,275),Vector2(115,225),Vector2(75,180),Vector2(65,120),Vector2(0,90)])
 for i in range(shape.size()): shape[i] += offset
 draw_colored_polygon(shape,Color("37a385"))
 var rio = offset+Vector2(212,225)
 draw_circle(rio,10,Color("ffd180"))
 draw_string(ThemeDB.fallback_font,rio+Vector2(17,5),"RJ • Nova Iguaçu",HORIZONTAL_ALIGNMENT_LEFT,-1,20,Color("ffe1a0"))
