/datum/job
	//Is this job whitelisted based on config files?
	var/wl_config_heads = FALSE		//heads of staff
	var/wl_config_sec = FALSE		//security
	var/wl_config_borgs = FALSE		//silicons

	//Is this job intended for admins only?
	var/wl_admin_only = FALSE