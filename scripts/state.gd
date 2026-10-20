extends RefCounted
const SAVE = "user://passport.json"
var world: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/world.json"))
var coins: int = 350
var xp: int = 0
var crystals: int = 0
var spins: int = 10
var levels: Array = [0,0,0,0,0,0,0]
var total_spins: int = 0
var claimed: Array = []
var completed: String = ""
var sound: bool = true
var rng = RandomNumberGenerator.new()

func _init():
 rng.randomize()

func price(i: int) -> int:
 return int(world.regions[i].cost) * (int(levels[i])+1)

func build(i: int) -> bool:
 if i < 0 or i >= levels.size() or levels[i] >= 3 or coins < price(i): return false
 coins -= price(i)
 levels[i] += 1
 xp += 25
 if progress() == 100 and completed.is_empty(): completed = Time.get_date_string_from_system()
 save_game()
 return true

func progress() -> int:
 var count = 0
 for level in levels: count += int(level)
 return int(count * 100.0 / 21)

func spin() -> Dictionary:
 if spins <= 0: return {}
 spins -= 1
 total_spins += 1
 var roll = rng.randi_range(1,100)
 var cumulative = 0
 for reward in world.rewards:
  cumulative += int(reward.weight)
  if roll <= cumulative:
   coins += int(reward.get("coins",0))
   xp += int(reward.get("xp",0))
   crystals += int(reward.get("crystals",0))
   spins += int(reward.get("spins",0))
   save_game()
   return reward
 return {}

func explore():
 # Always available: no energy gate, ads, purchases or clock dependency.
 coins += 35
 xp += 2
 spins += 1
 save_game()

func mission_ready(id: int) -> bool:
 return [total_spins >= 5, levels.count(0) <= 4, progress() >= 50, progress() == 100][id]

func claim(id: int) -> bool:
 if id < 0 or id > 3 or id in claimed or not mission_ready(id): return false
 claimed.append(id)
 coins += [150,250,500,1000][id]
 crystals += 2
 save_game()
 return true

func save_game():
 var data = {"version":1,"coins":coins,"xp":xp,"crystals":crystals,"spins":spins,"levels":levels,"total_spins":total_spins,"claimed":claimed,"completed":completed,"sound":sound}
 var file = FileAccess.open(SAVE + ".tmp", FileAccess.WRITE)
 if file == null: return
 file.store_string(JSON.stringify(data))
 file.close()
 if FileAccess.file_exists(SAVE):
  DirAccess.copy_absolute(SAVE,SAVE + ".bak")
 DirAccess.rename_absolute(SAVE + ".tmp", SAVE)

func load_game() -> bool:
 for path in [SAVE, SAVE + ".bak"]:
  if not FileAccess.file_exists(path): continue
  var parser = JSON.new()
  if parser.parse(FileAccess.get_file_as_string(path)) != OK: continue
  var data = parser.data
  if not data is Dictionary or data.get("version") != 1: continue
  var lv = data.get("levels",[])
  if not lv is Array or lv.size() != 7: continue
  var valid = true
  for level in lv:
   if not (level is float or level is int) or level < 0 or level > 3: valid = false
  if not valid: continue
  for key in ["coins","xp","crystals","spins","total_spins"]:
   set(key,maxi(0,int(data.get(key,0))))
  levels = []
  for value in lv: levels.append(int(value))
  claimed = data.get("claimed",[]) if data.get("claimed",[]) is Array else []
  completed = str(data.get("completed",""))
  sound = bool(data.get("sound",true))
  return true
 return false
