
/mob/living/carbon/human/proc/zombify()
	for(var/datum/antagonist/zombie/W)
		W.add_antagonist(mind)

	set_species("Zombie")

	faction = "zombie"

	for(var/obj/item/W in src)
		src.drop_from_inventory(W)

	revive()

