// Eclipse-specific behaviour for Sellatrons.

/obj/machinery/selling_machine/Initialize()
// Wait for config to be loaded first, so we know if we want the Sellatron to
// charge to the ID department by default, or if we need to select it manually.
	while(!config.eclipse_config_loaded)
		sleep(5)
	
	//Config should be loaded now that the while-loop is broken
	
	allow_select_department = !sellatron_auto
	//I know that looks ass-backwards, but if it's NOT set to allow you to
	//choose your department, it will automatically pick it based on your ID.
	
	//say shit so we know it worked
	log_debug("Sellatron at [x], [y], [z]: department selection set to [allow_select_department ? "manual" : "automatic"]")
