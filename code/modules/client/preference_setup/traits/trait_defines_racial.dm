/datum/trait/modifier/racial
	category = "Racial/Genemods"
	can_be_removed = FALSE
	racial = TRUE
	var/list/allowed_races = list()


/datum/trait/modifier/racial/reptilian
	name = "Reptilian"
	can_be_removed = TRUE
	modifier_type = /datum/modifier/trait/racial/reptilian
	desc = "You're a robust cold-blooded reptile. Hiss."
	allowed_races = list(SPECIES_UNATHI)
	mutually_exclusive = list(/datum/trait/modifier/racial/amphibian, /datum/trait/modifier/physical/flimsy, /datum/trait/modifier/physical/frail, /datum/trait/modifier/physical/wimpy, /datum/trait/modifier/physical/weak)

/datum/trait/modifier/racial/amphibian
	name = "Amphibian"
	can_be_removed = TRUE
	modifier_type = /datum/modifier/trait/racial/amphibian
	desc = "Glub glub glub."
	allowed_races = list(SPECIES_SKRELL, SPECIES_AKULA)
	mutually_exclusive = list(/datum/trait/modifier/racial/reptilian)