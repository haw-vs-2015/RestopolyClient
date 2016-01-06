extends Node

var playerid = null
var playerName = null

var gameUri = null

var myTurn = false;
var money = 0
var cards = []
var responsePort = 3560
var ha_proxy = "141.22.88.102"
var ha_proxy_port = 4567
var playerUri ="http://" + IP.get_local_addresses()[1] + ":" + str(responsePort)
var players = []

var games = {}
var game = null

var ip = "http://" + ha_proxy + ":" + str(ha_proxy_port)
#var yellow_pages = "https://vs-docker.informatik.haw-hamburg.de/ports/8053/services"


var loader
var wait_frames
var time_max = 100 #msec
var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	
func get_ha_proxy():
	return ha_proxy

func get_ha_proxy_port():
	return ha_proxy_port
	
func set_resopnse_port(port):
	responsePort = port
	
func get_resopnse_port():
	return responsePort

func goto_scene(path):
	
	
	loader = ResourceLoader.load_interactive(path)
	if loader == null:
		show_error()
		return
	set_process(true)
	
	current_scene.queue_free() # delet all the old scenes
	
	#play loading animation
	wait_frames = 1
	
func _process(time):
    if loader == null:
        # no need to process anymore
        set_process(false)
        return

    if wait_frames > 0: # wait for frames to let the "loading" animation to show up
        wait_frames -= 1
        return

    var t = OS.get_ticks_msec()
    while OS.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread

        # poll your loader
        var err = loader.poll()

        if err == ERR_FILE_EOF: # load finished
            var resource = loader.get_resource()
            loader = null
            set_new_scene(resource)
            break
        elif err == OK:
            update_progress()
        else: # error during loading
            show_error()
            loader = null
            break
    
func update_progress():
    var progress = float(loader.get_stage()) / loader.get_stage_count()
    # update your progress bar?
   # get_node("progress").set_progress(progress)

    # or update a progress animation?
  #  var len = get_node("animation").get_current_animation_length()

    # call this on a paused animation. use "true" as the second parameter to force the animation to update
  #  get_node("animation").seek(progress * len, true)

func set_new_scene(scene_resource):
    current_scene = scene_resource.instance()
    get_node("/root").add_child(current_scene)

func setMyTurn(boolean):
	myTurn  = boolean
	
func getMyTurn():
	return myTurn
	
func setPlayerName(name):
	playerName = name
	print("PLAYERNAME SET TO : " + playerName)
	
func getPlayerName():
	return playerName
