extends Control
var game
var selected: Callable
var phase: float = 0
func _process(delta):
 phase += delta
 queue_redraw()
func diamond(c: Vector2, size: Vector2, color: Color):
 draw_colored_polygon(PackedVector2Array([c+Vector2(0,-size.y),c+Vector2(size.x,0),c+Vector2(0,size.y),c-Vector2(size.x,0)]),color)
func _draw():
 if game == null: return
 var scale_map = size / Vector2(660,850)
 draw_rect(Rect2(Vector2.ZERO,size),Color("123e48"))
 for j in range(10):
  for i in range(9):
   var pos = Vector2(25+i*80+(j%2)*25,65+j*83)*scale_map
   diamond(pos,Vector2(53,30)*scale_map,Color("205d57") if (i+j)%3 else Color("286b5a"))
 var points = PackedVector2Array()
 for r in game.world.regions: points.append(Vector2(r.x,r.y)*scale_map)
 draw_polyline(PackedVector2Array([points[4],points[3],points[0],points[2],points[5]]),Color("719b8f"),12)
 draw_polyline(PackedVector2Array([points[6],points[1],points[0]]),Color("719b8f"),10)
 for idx in range(points.size()):
  var pos = points[idx]
  var level = int(game.levels[idx])
  diamond(pos+Vector2(0,10),Vector2(65,34)*scale_map,Color("11343f"))
  diamond(pos,Vector2(65,34)*scale_map,Color("67be89") if level else Color("547770"))
  if level:
   for b in range(level):
    var base = pos+Vector2((b-1)*22,-8)
    draw_rect(Rect2(base-Vector2(9,32+b*6),Vector2(18,34+b*6)),Color("f9d38a") if b%2 else Color("8cd3df"))
    diamond(base-Vector2(0,32+b*6),Vector2(13,7),Color("ed8a6a"))
    draw_rect(Rect2(base-Vector2(4,22),Vector2(5,8)),Color("275169"))
  else:
   draw_circle(pos-Vector2(0,10),12,Color("203f49"))
   draw_arc(pos-Vector2(0,23),8,PI,TAU,12,Color("f5d780"),3)
  draw_string(ThemeDB.fallback_font,Vector2(pos.x-65,minf(pos.y+49,size.y-5)),game.world.regions[idx].name,HORIZONTAL_ALIGNMENT_CENTER,130,17,Color("fff0c6"))
  for t in range(3):
   var tree = pos+Vector2(45+t*11,-35-t*9)
   draw_line(tree,tree+Vector2(0,12),Color("9f8b60"),3)
   draw_circle(tree,8+sin(phase+t)*0.6,Color("46a679"))
 if game.progress() == 100:
  var center = Vector2(580,300)*scale_map
  diamond(center,Vector2(40,20),Color("e6ba69"))
  draw_rect(Rect2(center-Vector2(10,62),Vector2(20,62)),Color("ffe0a1"))
  diamond(center-Vector2(0,62),Vector2(27,14),Color("ee9679"))
  draw_circle(center-Vector2(0,78),11,Color("75c6a1"))
 draw_string(ThemeDB.fallback_font,Vector2(20,30),"N ↑     NOVA IGUAÇU",HORIZONTAL_ALIGNMENT_LEFT,-1,20,Color("ffe7a4"))
func _gui_input(event):
 if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
  var s = size / Vector2(660,850)
  for i in range(game.world.regions.size()):
   var r = game.world.regions[i]
   if event.position.distance_to(Vector2(r.x,r.y)*s) < 58:
    selected.call(i)
    accept_event()
    return
