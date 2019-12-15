/datum/modifier/trait/haste
	name = "small frame/lighter alloys"
	desc = "Your lightweight body allows you to move faster than average."

	slowdown = -0.5
	max_health_percent = 0.75

/datum/modifier/trait/extra_haste
	name = "hollow bones/plastic components"
	desc = "Your very lightweight and fragile body allows you to move far faster than average."

	slowdown = -1
	max_health_percent = 0.5


/datum/modifier/trait/racial


/datum/modifier/trait/racial/reptilian
	name = "reptilian"
	desc = "You're a robust cold-blooded reptile. Hiss."

	on_created_text = "<span class='notice'>You feel like basking on a heated rock and being a proud warrior.</span>"
	on_expired_text = "<span class='notice'>You no longer feel like a lizard.</span>"

	max_health_percent = 1.25
	slowdown = 1.5
	incoming_brute_damage_percent = 0.85
	incoming_fire_damage_percent = 0.85
	metabolism_percent = 0.85
	bleeding_rate_percent = 0.75

/datum/modifier/trait/racial/amphibian
	name = "amphibian"
	desc = "Glub glub glub. \
	You can breathe underwater."

	on_created_text = "<span class='notice'>You feel like submerging yourself into a large body of water and breathing through your gills.</span>"
	on_expired_text = "<span class='notice'>You no longer feel like an amphibian.</span>"

	incoming_fire_damage_percent = 0.9
	thirst_modifier = 0.09

/datum/modifier/trait/racial/amphibian/on_applied()
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		H.alternative_thirst = TRUE
		H.alt_thirst_modifier = thirst_modifier
		H.waterbreathing = TRUE
	.=..()