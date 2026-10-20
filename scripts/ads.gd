extends RefCounted
# Optional Poing Studios bridge. No SDK loads without the native Android plugin.
# Google official sample IDs only; production IDs are intentionally unsupported.
const TEST_APP_ID = "ca-app-pub-3940256099942544~3347511713"
const TEST_REWARDED_ID = "ca-app-pub-3940256099942544/5224354917"
const API = "res://addons/admob/gdscript/src/api/"
var ad = null
var loading = false
var load_callback = null
var reward_listener = null
var content_callback = null
var reward_action: Callable
var enabled = false
var consumed = true

func available() -> bool:
 return enabled and OS.get_name() == "Android" and Engine.has_singleton("PoingGodotAdMobRewardedAd") and ResourceLoader.exists(API + "RewardedAdLoader.gd")

func request_reward(action: Callable) -> bool:
 if not available() or loading or ad != null: return false
 loading = true
 reward_action = action
 load_callback = load(API + "listeners/RewardedAdLoadCallback.gd").new()
 load_callback.on_ad_failed_to_load = func(_error): loading = false; ad = null
 load_callback.on_ad_loaded = func(loaded):
  loading = false
  ad = loaded
  consumed = false
  reward_listener = load(API + "listeners/OnUserEarnedRewardListener.gd").new()
  reward_listener.on_user_earned_reward = func(_item):
   if consumed: return
   consumed = true
   reward_action.call()
  content_callback = load(API + "listeners/FullScreenContentCallback.gd").new()
  content_callback.on_ad_dismissed_full_screen_content = clear
  content_callback.on_ad_failed_to_show_full_screen_content = func(_error): clear()
  ad.full_screen_content_callback = content_callback
  ad.show(reward_listener)
 var loader = load(API + "RewardedAdLoader.gd").new()
 loader.load(TEST_REWARDED_ID,load(API + "core/AdRequest.gd").new(),load_callback)
 return true

func clear():
 if ad != null: ad.destroy()
 ad = null
 consumed = true
 loading = false
