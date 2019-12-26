/mob/living/simple_animal/curator
	name = "mysterious figure"
	desc = "A mysterious cloaked figure, speak in high-pitched whispers. They seem to be hunched under that cloak."
	var/desc_unveiled = "Intelligent, sizeable chiroptera, speaking in high-pitched whispers."
	icon = 'icons/mob/curator.dmi'
	icon_state = "curator"
	faction = "curator"
	mob_size = MOB_HUGE
	intelligence_level = SA_HUMANOID

	var/robe_state = "robed"

	var/icon/eye_layer = null

	maxHealth = 300
	health = 300

	move_to_delay = 2
	speed = 1
	see_in_dark = 10 //bats
	has_hands = TRUE //bat hands
	seedarkness = FALSE //b a t s
	attack_sound = 'sound/weapons/bladeslice.ogg'
	has_langs = list(LANGUAGE_GALCOM)

	attacktext = list("clawed", "slashed")

	var/deathmessage = "lets out an ear-piercing screech and disappears in a puff of smoke!"


	melee_damage_lower = 12
	melee_damage_upper = 23
	//SPACE BATS
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0


	var/veiled = TRUE
	var/eye_color = "#ffff00"
	var/fur_color = "#654321"
	var/robe_color = "#800080"

/mob/living/simple_animal/curator/initialize()
	update_icon()
	add_spell(new/spell/aoe_turf/knock)
	add_spell(new/spell/targeted/ethereal_jaunt/shift/curator)
	add_spell(new/spell/targeted/ambush_mode)
	verbs += /mob/living/proc/set_size
	spawn(50)
		if(!client)
			visible_message("[src] disappears in a puff of smoke!")
			qdel(src)

/mob/living/simple_animal/curator/death()
	..()
	visible_message("[src] [deathmessage]")
	sleep(1)
	qdel(src)

/mob/living/simple_animal/curator/update_icon()
	overlays.Cut()
	if(veiled)
		desc = initial(desc)
		icon_state = robe_state
		color = robe_color
	else
		icon_state = initial(icon_state)
		desc = desc_unveiled
		color = fur_color
		var/image/eyes_image = image(icon, "eyes")
		eyes_image.appearance_flags = RESET_COLOR
		eyes_image.plane = PLANE_LIGHTING_ABOVE
		eyes_image.color = eye_color
		add_overlay(eyes_image)



/mob/living/simple_animal/curator/IsAdvancedToolUser()
	return 1


/mob/living/simple_animal/curator/verb/change_fur_color()
	set name = "Select Fur Color"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 25

	var/new_skin = input("Please select a new body color.", "Shapeshifter Color") as color
	if(!new_skin)
		return
	fur_color = new_skin
	update_icon()

/mob/living/simple_animal/curator/verb/change_eye_color()
	set name = "Select Eye Color"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 25

	var/neweyecolor = input("Please select a new eye color.", "Shapeshifter Color") as color
	if(!neweyecolor)
		return
	eye_color = neweyecolor
	update_icon()

/mob/living/simple_animal/curator/verb/change_robe_color()
	set name = "Select Robe Color"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 25

	var/robecolornew = input("Please select a new robe color.", "Shapeshifter Color") as color
	if(!robecolornew)
		return
	robe_color = robecolornew
	update_icon()

/mob/living/simple_animal/curator/verb/swap_veil()
	set name = "Veil/Unveil"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 25

	veiled = !veiled
	if(veiled)
		visible_message("[src] produces a cloak out of nowhere and wraps themselves in it!")
	else
		visible_message("[src]'s pulls away their cloak, revealing a giant chiroptera!")

	update_icon()



/mob/living/simple_animal/curator/sacks
	name = "festive figure"
	desc = "A mysterious cloaked figure, speaking in high-pitched whispers. They seem to be hunched under their festive robe."
	robe_state = "sacks"
	robe_color = "white"
	deathmessage = "lets out an ear-piercing screech and disappears in a puff of smoke, leaving behind their sack!"
	maxHealth = 750
	health = 750
	var/obj/item/weapon/storage/backpack/santabag/mrsacks/sackssack = null

/mob/living/simple_animal/curator/sacks/initialize()
	..()
	sackssack = new /obj/item/weapon/storage/backpack/santabag/mrsacks(src)
	sackssack.forceMove(src)

/mob/living/simple_animal/curator/sacks/change_robe_color()
	set name = "Select Robe Color"
	set category = "Abilities"

	to_chat(usr, "<span class='warning'>You cannot change the color of your festive robe!</span>")
	return

/mob/living/simple_animal/curator/sacks/death()
	sackssack.forceMove(get_turf(src))
	..()

/mob/living/simple_animal/curator/sacks/update_icon()
	..()
	var/image/sack = image(icon, "sack")
	if(veiled)
		sack.plane = PLANE_LIGHTING_ABOVE
		overlays += sack
	else
		overlays -= sack

/mob/living/simple_animal/curator/sacks/verb/scoop_up()
	set name = "Scoop up a person"
	set category = "Abilities"
	var/obj/item/item_to_pocket = get_active_hand()
	var/list/victims = list()
	for(var/mob/living/victim in viewers(3))
		victims += victim
	victims -= usr

	var/mob/living/M = input("Who do you wish to scoop up?") as null|anything in victims
	if(!usr || !src || !M) return
	if(item_to_pocket)
		to_chat(usr, "<span class='warning'>Your hand is full!</span>")
	else
		M.get_scooped(usr, 0)


/mob/living/simple_animal/curator/sacks/verb/open_sack()
	set name = "Browse your sack"
	set category = "Abilities"
	sackssack.open(usr)


/spell/targeted/ethereal_jaunt/shift/curator
	name = "Ethereal Jaunt"
	desc = "This spell creates your ethereal form, temporarily making you invisible and able to pass through walls."

/spell/targeted/ethereal_jaunt/shift/curator/jaunt_disappear(var/atom/movable/overlay/animation, var/mob/living/target)
	return

/spell/targeted/ethereal_jaunt/shift/curator/jaunt_reappear(var/atom/movable/overlay/animation, var/mob/living/target)
	return

/spell/targeted/ethereal_jaunt/shift/curator/jaunt_steam(var/mobloc)
	var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
	steam.set_up(10, 0, mobloc)
	steam.start()


