#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(config.usewhitelist)
		load_whitelist()
	return 1

/proc/load_whitelist()
	whitelist = file2list(WHITELISTFILE)
	if(!whitelist.len)	whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!whitelist)
		return 0
	return ("[M.ckey]" in whitelist)

/var/list/alien_whitelist = list()

/hook/startup/proc/loadAlienWhitelist()
	if(config.usealienwhitelist)
		load_alienwhitelist()
	return 1

/proc/load_alienwhitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
	else
		alien_whitelist = splittext(text, "\n")

/proc/is_alien_whitelisted(mob/M, var/datum/species/species)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return 1

	//You did something wrong
	if(!M || !species)
		return 0

	//The species isn't even whitelisted
	if(!(species.spawn_flags & SPECIES_IS_WHITELISTED))
		return 1

	//If we have a loaded file, search it
	if(alien_whitelist)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [species.name]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1

/proc/is_lang_whitelisted(mob/M, var/datum/language/language)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return 1

	//You did something wrong
	if(!M || !language)
		return 0

	//The language isn't even whitelisted
	if(!(language.flags & WHITELISTED))
		return 1

	//If we have a loaded file, search it
	if(alien_whitelist)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [language.name]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1

/proc/whitelist_overrides(mob/M)
	if(!config.usealienwhitelist)
		return 1
	if(check_rights(R_ADMIN, 0, M))
		return 1

	return 0

/var/list/hard_whitelist = list()

/hook/startup/proc/loadhardWhitelist()
	load_hardwhitelist()
	return 1

/proc/load_hardwhitelist()
	var/text = file2text("config/jobwhitelist.txt")		//Eclipse edit?
	if (!text)
		log_misc("Failed to load config/jobwhitelist.txt")		//Eclipse edit
	else
		hard_whitelist = splittext(text, "\n")

/proc/is_hard_whitelisted(mob/M, var/datum/job/jobs)		//Eclipse Note: "Is Player (Hard-) Whitelisted?"
	//They are admin or the whitelist isn't in use
//	if(whitelist_overrides(M))
//		return 1
	
	
	// // // BEGIN ECLIPSE EDITS // // //
	// Rationale: Config-based job whitelisting.
	
	// Job whitelist disabled
	if(!config.usejobwhitelist)
		return 1
	
	//The job isn't even whitelisted
	if(!jobs.hard_whitelisted)
		return TRUE
	
	//Admin overrides
	if(!config.wl_admins_too && check_rights(R_ADMIN, 0))		//"If the admins are not required to go through whitelist checks, and they have the perms flag R_ADMIN, they pass whitelisting." Note for future Spitzer. ^Past Spitzer
		return 1
		
	//Admin-only jobs
	if(jobs.wl_admin_only && check_rights(R_ADMIN, 0))		//"If the job is admin-only and the admin has the perms flag R_ADMIN, pass 'em."
		return 1

	// // // END ECLIPSE EDITS // // //

	if(jobs.title == "President") // Only the player who is president and their allotted character can be president
		if(!SSelections.current_president || !SSelections.current_president.ckey || !SSelections.current_president.name) //Just in case. Also prevents runtimes in local testing
			return FALSE

		if(M.ckey == SSelections.current_president.ckey && M.client.prefs.real_name == SSelections.current_president.name)
			return TRUE
		else
			return FALSE

	//If we have a loaded file, search it
	if(jobs.hard_whitelisted)
		for (var/s in hard_whitelist)
			if(findtext(s,"[lowertext(M.ckey)] - [lowertext(jobs.title)]"))
				return 1
			if(findtext(s,"[M.ckey] - [jobs.title]"))
				return 1
			if(findtext(s,"[M.ckey] - [lowertext(jobs.title)]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1


/proc/get_available_classes(client/C)

	if(!isnum(C.player_age))
		return ECONOMIC_CLASS	// if there's no database, or hard player age saves, let's just enable all.

	if(config.upper_class_age < C.player_age)
		return ECONOMIC_CLASS //60 days unlocks all classes

	else if (config.middle_class_age < C.player_age)
		return list(CLASS_WORKING, CLASS_MIDDLE)

	else
		return CLASS_WORKING


	return CLASS_WORKING



#undef WHITELISTFILE
