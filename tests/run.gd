extends SceneTree
const State = preload("res://scripts/state.gd")
var checks = 0
var failures = 0
func check(ok: bool, description: String):
 checks += 1
 if not ok:
  failures += 1
  printerr("FAIL: ",description)
 else: print("PASS: ",description)
func _initialize():
 call_deferred("run")
func run():
 var ads = preload("res://scripts/ads.gd").new()
 check(not ads.available(),"native ads unavailable safely")
 check(not ads.request_reward(func(): failures += 1),"no ad means no reward callback")
 var s = State.new()
 s.rng.seed = 12345
 check(s.progress() == 0,"fresh progression")
 check(not s.build(-1) and not s.build(7),"invalid regions rejected")
 s.coins = 0
 check(not s.build(0),"insufficient balance rejected")
 check(not s.claim(0),"mission cannot be claimed early")
 var sum = 0
 for r in s.world.rewards: sum += int(r.weight)
 check(sum == 100,"reward probabilities total 100")
 var counts = {}
 s.spins = 10000
 for i in range(10000):
  var reward = s.spin()
  counts[reward.name] = counts.get(reward.name,0)+1
 for r in s.world.rewards:
  check(abs(counts.get(r.name,0)/100.0-r.weight)<2.0,"distribution: "+r.name)
 s = State.new()
 var explorations = 0
 for region in range(7):
  for level in range(3):
   while s.coins < s.price(region):
    s.explore()
    explorations += 1
   check(s.build(region),"build region %d stage %d" % [region,level+1])
 check(s.progress() == 100 and not s.completed.is_empty(),"city completion and stamp date")
 check(not s.build(0),"completed region cannot consume currency")
 check(s.claim(3) and not s.claim(3),"mission reward is granted once")
 var t = State.new()
 check(t.load_game(),"save can be loaded")
 check(t.coins == s.coins and t.levels == s.levels and t.completed == s.completed,"full progression round trip")
 var f = FileAccess.open(State.SAVE,FileAccess.WRITE)
 f.store_string("broken")
 f.close()
 check(State.new().load_game(),"corrupted save recovers from backup")
 s.spins = 0
 check(s.spin().is_empty(),"zero spins cannot play")
 s.explore()
 check(s.spins == 1,"free offline route replenishes spins")
 print("FULL JOURNEY: ",explorations," free explorations; 21 buildings; no ads or payments")
 # Exercise actual UI scene, navigation, map rendering and animation.
 var ui = load("res://scenes/main.tscn").instantiate()
 root.add_child(ui)
 await process_frame
 for page in ["Início","Cidade","Roleta","Missões","Passaporte","Brasil","Loja","Ajustes"]:
  ui.page = page
  ui.render()
  await process_frame
  check(ui.body.get_child_count()>0,"UI page: "+page)
 ui.page = "Roleta"
 ui.game.spins = 2
 ui.render()
 var before = ui.game.total_spins
 ui.spin_wheel(ui.body.get_child(2))
 await create_timer(3).timeout
 check(not ui.busy and ui.game.total_spins == before+1,"animated spin resolves once")
 ui.page = "Passaporte"
 ui.render()
 ui.stamp_animation()
 await create_timer(3.2).timeout
 print("RESULT: %d checks, %d failures" % [checks,failures])
 quit(1 if failures else 0)
