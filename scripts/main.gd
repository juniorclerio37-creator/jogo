extends Control
const State = preload("res://scripts/state.gd")
const MapView = preload("res://scripts/map.gd")
var game = State.new()
var page = "Início"
var root: VBoxContainer
var body: VBoxContainer
var status: Label
var message: Label
var busy = false
var selected = 0
var last_stamp = false
var explore_ready = true
var ads = preload("res://scripts/ads.gd").new()

func _ready():
 game.load_game()
 last_stamp = not game.completed.is_empty()
 var theme_new = Theme.new()
 theme_new.default_font_size = 22
 for type in ["Button","PanelContainer"]:
  var style = StyleBoxFlat.new()
  style.bg_color = Color("1a4353")
  style.set_corner_radius_all(16)
  style.content_margin_left = 15
  style.content_margin_right = 15
  style.content_margin_top = 12
  style.content_margin_bottom = 12
  theme_new.set_stylebox("normal" if type == "Button" else "panel",type,style)
 theme = theme_new
 var margin = MarginContainer.new()
 margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 margin.add_theme_constant_override("margin_left",24)
 margin.add_theme_constant_override("margin_right",24)
 margin.add_theme_constant_override("margin_top",22)
 margin.add_theme_constant_override("margin_bottom",20)
 add_child(margin)
 root = VBoxContainer.new()
 root.add_theme_constant_override("separation",12)
 margin.add_child(root)
 var brand = Label.new()
 brand.text = "BRASIL QUEST   /   PASSAPORTE DAS CIDADES"
 brand.add_theme_font_size_override("font_size",22)
 brand.modulate = Color("ffd78c")
 root.add_child(brand)
 status = Label.new()
 root.add_child(status)
 var nav = HFlowContainer.new()
 root.add_child(nav)
 for name_page in ["Início","Cidade","Roleta","Missões","Passaporte","Brasil","Loja","Ajustes"]:
  var dest = name_page
  button(nav,dest,func():
   if not busy:
    page = dest
    render())
 var scroll = ScrollContainer.new()
 scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
 root.add_child(scroll)
 body = VBoxContainer.new()
 body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 body.add_theme_constant_override("separation",14)
 scroll.add_child(body)
 message = Label.new()
 message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 message.custom_minimum_size.y = 65
 message.modulate = Color("ffd78c")
 root.add_child(message)
 render()

func button(parent: Node, text: String, callback: Callable) -> Button:
 var b = Button.new()
 b.text = text
 b.custom_minimum_size.y = 56
 b.pressed.connect(callback)
 parent.add_child(b)
 return b

func label(text: String, size_font: int = 23) -> Label:
 var l = Label.new()
 l.text = text
 l.add_theme_font_size_override("font_size",size_font)
 l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 body.add_child(l)
 return l

func toast(text: String):
 message.text = text
 var tween = create_tween()
 message.modulate = Color("ffd78c")
 tween.tween_property(message,"modulate",Color.WHITE,1.5)

func refresh_status():
 status.text = "%d moedas  •  %d cristais  •  %d giros\n%d XP  /  Nova Iguaçu: %d%%" % [game.coins,game.crystals,game.spins,game.xp,game.progress()]

func render():
 for child in body.get_children():
  body.remove_child(child)
  child.queue_free()
 refresh_status()
 match page:
  "Início":
   label("Sua próxima aventura\ncomeça aqui.",44)
   label("Explore a Baixada Fluminense, desenvolva bairros e guarde memórias no seu passaporte.")
   var icon = TextureRect.new()
   icon.texture = load("res://assets/icon.svg")
   icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
   icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
   icon.custom_minimum_size.y = 260
   body.add_child(icon)
   button(body,"Continuar em Nova Iguaçu →",func(): page = "Cidade"; render())
   label("Como jogar\n1. Explore ou gire para ganhar moedas.\n2. Toque nos bairros para desbloquear e melhorar.\n3. Complete as 21 obras e receba seu selo.\n\nSem compras reais, apostas ou anúncios obrigatórios.")
  "Cidade": city_page()
  "Roleta": wheel_page()
  "Missões": missions_page()
  "Passaporte": passport_page()
  "Brasil": brazil_page()
  "Loja": shop_page()
  "Ajustes": settings_page()
  "Licenças":
   label("GODOT ENGINE • LICENÇA MIT",28)
   label(FileAccess.get_file_as_string("res://data/GODOT_LICENSE.txt"),18)

func art(path: String, height: int):
 var image = TextureRect.new()
 image.texture = load(path)
 image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 image.custom_minimum_size.y = height
 body.add_child(image)

func city_page():
 var map_view = MapView.new()
 map_view.game = game
 map_view.selected = func(i): selected = i; render()
 map_view.custom_minimum_size = Vector2(0,570)
 body.add_child(map_view)
 var r = game.world.regions[selected]
 label(r.name + "  •  Etapa %d/3" % game.levels[selected],28)
 label(r.description,20)
 var stages = ["Desbloquear região","Construir centro comunitário","Melhorar e descobrir a paisagem","Região concluída ✓"]
 var level = int(game.levels[selected])
 var action = button(body,stages[level] + (" • %d moedas" % game.price(selected) if level < 3 else ""),func():
  if game.build(selected):
   toast("Obra concluída! +25 XP")
   if not game.completed.is_empty() and not last_stamp:
    last_stamp = true
    page = "Passaporte"
    render()
    stamp_animation()
   else: render()
  else: toast("Explore ou gire para conseguir mais moedas."))
 action.disabled = level >= 3
 button(body,"Explorar trilha • +35 moedas e +1 giro",explore)
 label("Mapa artístico esquemático, com norte para cima. Não serve para navegação. Toque nos bairros.",17)

func explore():
 if not explore_ready: return
 explore_ready = false
 game.explore()
 refresh_status()
 toast("Trilha explorada! +35 moedas, +1 giro e +2 XP")
 await get_tree().create_timer(1.0).timeout
 explore_ready = true

func wheel_page():
 label("ROLETA DO VIAJANTE",32)
 label("Cada giro usa 1 giro virtual. Probabilidades públicas; sem dinheiro real.",20)
 var wheel = preload("res://scripts/wheel.gd").new()
 wheel.custom_minimum_size.y = 340
 body.add_child(wheel)
 button(body,"Girar • %d disponíveis" % game.spins,func(): spin_wheel(wheel))
 button(body,"Explorar • ganhar 1 giro grátis",explore)
 label("Probabilidades por giro",25)
 for reward in game.world.rewards:
  label("%s: %d%%  •  %s" % [reward.name,reward.weight,reward_text(reward)],18)

func reward_text(r: Dictionary) -> String:
 var parts: Array[String] = []
 for key in ["coins","xp","spins","crystals"]:
  if r.has(key): parts.append("+%d %s" % [r[key],{"coins":"moedas","xp":"XP","spins":"giros","crystals":"cristais"}[key]])
 return ", ".join(parts)

func spin_wheel(wheel):
 if busy: return
 var reward = game.spin()
 if reward.is_empty(): toast("Explore uma trilha para ganhar giros gratuitos."); return
 busy = true
 # Outcome is persisted before animation to prevent duplicate rewards after closing.
 var idx = game.world.rewards.find(reward)
 var target = TAU * 5 - (idx + 0.5) * TAU / 6.0
 var tween = create_tween()
 tween.tween_property(wheel,"angle",target,2.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
 await tween.finished
 busy = false
 toast(reward.name + "! " + reward_text(reward))
 render()

func missions_page():
 label("MISSÕES DA JORNADA",32)
 var names = ["Gire 5 vezes","Desbloqueie 3 regiões","Alcance 50% da cidade","Conclua Nova Iguaçu"]
 for i in range(4):
  var id = i
  label(names[i] + " • %d moedas + 2 cristais" % [150,250,500,1000][i])
  var b = button(body,"Resgatado ✓" if i in game.claimed else ("Resgatar recompensa" if game.mission_ready(i) else "Em andamento"),func():
   if game.claim(id): toast("Missão cumprida!"); render())
  b.disabled = i in game.claimed or not game.mission_ready(i)

func passport_page():
 label("PASSAPORTE\nBRASILEIRO",42).modulate = Color("ffd78c")
 label("Coleção de viagens • Baixada Fluminense")
 for i in range(game.world.cities.size()):
  var city = game.world.cities[i]
  if i == 0:
   label("NOVA IGUAÇU   %d%%" % game.progress(),28)
   if not game.completed.is_empty(): art("res://assets/stamp.svg",210)
   label("Selo: Guardião da Serra\n" + ("CARIMBADO ✓  " + game.completed if not game.completed.is_empty() else "Complete todas as regiões para carimbar."))
   art("res://assets/monument.svg",190)
   label("Monumento original: Farol da Mata — uma torre-jardim fictícia que homenageia a natureza e as antigas rotas da cidade. Não é um monumento real.",20)
  else:
   label(city + (" • desbloqueada para a próxima atualização" if i == 1 and not game.completed.is_empty() else " • em breve"),20)
 label("Conquistas: %d/4 missões resgatadas" % game.claimed.size())

func stamp_animation():
 toast("NOVA IGUAÇU CONCLUÍDA! Queimados desbloqueada no passaporte.")
 var stamp = Label.new()
 stamp.text = "✓ NOVA IGUAÇU\nGUARDIÃO DA SERRA"
 stamp.position = Vector2(90,450)
 stamp.add_theme_font_size_override("font_size",32)
 stamp.modulate = Color("ffd78c")
 stamp.rotation = -0.17
 stamp.scale = Vector2(2,2)
 add_child(stamp)
 var tween = create_tween()
 tween.tween_property(stamp,"scale",Vector2.ONE,0.5).set_trans(Tween.TRANS_BACK)
 tween.tween_interval(2)
 tween.tween_property(stamp,"modulate:a",0.0,0.5)
 tween.tween_callback(stamp.queue_free)

func brazil_page():
 label("BRASIL • ROTAS DA BAIXADA",32)
 label("Rio de Janeiro é o ponto de partida da sua coleção. A primeira cidade jogável é Nova Iguaçu.")
 var atlas = preload("res://scripts/atlas.gd").new()
 atlas.custom_minimum_size.y = 340
 body.add_child(atlas)
 for i in range(game.world.cities.size()):
  label("%02d  %s  %s" % [i+1,game.world.cities[i],"← jogar agora" if i == 0 else "• próxima expansão"],20)
 button(body,"Visitar Nova Iguaçu",func(): page = "Cidade"; render())

func shop_page():
 label("EMPÓRIO DO VIAJANTE",32)
 label("Troque apenas recursos virtuais. Não há compras com dinheiro real.")
 button(body,"Trocar 2 cristais por 200 moedas",func():
  if game.crystals < 2: toast("Você precisa de 2 cristais."); return
  game.crystals -= 2
  game.coins += 200
  game.save_game()
  render()
  toast("Troca concluída: +200 moedas"))
 button(body,"Explorar trilha grátis",explore)
 label("Bônus por anúncio • indisponível nesta compilação",25)
 label("A integração nativa do AdMob ainda precisa ser instalada e validada. Nenhum vídeo ou anúncio é simulado como anúncio real. O progresso permanece totalmente gratuito.",20)
 for placement in ["Giros extras","Moedas adicionais","Baú especial"]:
  var b = button(body,placement + " • anúncio não disponível",func(): pass)
  b.disabled = true

func settings_page():
 label("CONFIGURAÇÕES",32)
 label("Salvamento automático local. Sem conta, coleta de localização ou conexão obrigatória. Desinstalar o aplicativo pode apagar o progresso.")
 button(body,"Salvar agora",func(): game.save_game(); toast("Progresso salvo neste dispositivo."))
 label("Privacidade e anúncios",26)
 label("Esta versão não carrega SDKs publicitários nem transmite dados. Antes de ativar AdMob: integrar SDK, consentimento UMP, política de privacidade e classificação etária. Apenas IDs de teste estão documentados.",20)
 label("Créditos",26)
 label("Arte vetorial e código originais Brasil Quest. Godot Engine (MIT). Geografia aproximada, ainda pendente de revisão cartográfica. Não afiliado a prefeituras.",20)
 button(body,"Licença do Godot Engine",func(): page = "Licenças"; render())
 label("Versão 0.1 • vertical jogável offline",18)
