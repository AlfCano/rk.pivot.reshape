// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!

function preview(){
	
    var data_frame = getValue("data_slot_wide");
    var id_cols_full_string = getValue("id_cols_slot");
    var values_from_full = getValue("values_from_slot");
    var names_repair = getValue("names_repair_wide");
    var create_seq = getValue("create_seq");
    var seq_name = getValue("seq_name");
    var seq_group_string = getValue("seq_group");
    var seq_include = getValue("seq_include");
    var names_from_full = getValue("names_from_slot");

    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\[\[\"(.*?)\"\]\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var input_data_obj = data_frame;

    // Sequence Generation Logic
    if (create_seq == "1") {
        var temp_obj = "data_seq";
        // Create temp obj copy
        echo(temp_obj + " <- " + data_frame + "\n");

        var group_vars = seq_group_string.split(/\s+/).filter(function(n){ return n != "" }).map(function(item) { return getColumnName(item); });

        if (group_vars.length > 0) {
            // Join with quote-comma-quote safely
            var grp_str = group_vars.join(", ");
            var primary_grp = group_vars[0];
            echo(temp_obj + "[['" + seq_name + "']] <- with(" + temp_obj + ", stats::ave(seq_along(" + primary_grp + "), " + grp_str + ", FUN = seq_along))\n");
        } else {
             echo(temp_obj + "[['" + seq_name + "']] <- seq_len(nrow(" + temp_obj + "))\n");
        }
        input_data_obj = temp_obj;
    }

    var options = new Array();
    options.push("data = " + input_data_obj);

    if(id_cols_full_string){
        var id_cols_array = id_cols_full_string.split(/\s+/).filter(function(n){ return n != "" });
        var id_col_names = id_cols_array.map(function(item) { return getColumnName(item); });
        options.push("id_cols = c('" + id_col_names.join("', '") + "')");
    }

    if (create_seq == "1") {
        options.push("names_from = " + seq_name);
    } else {
        options.push("names_from = " + getColumnName(names_from_full));
    }

    // Handle multiple values_from
    var val_cols_array = values_from_full.split(/\s+/).filter(function(n){ return n != "" });
    var val_col_names = val_cols_array.map(function(item) { return getColumnName(item); });

    // If sequence is created AND checkbox is checked, add it to values_from list
    if (create_seq == "1" && seq_include == "1") {
        val_col_names.push(seq_name);
    }

    options.push("values_from = c('" + val_col_names.join("', '") + "')");

    if(names_repair != "check_unique"){
        options.push("names_repair = \"" + names_repair + "\"");
    }

    
    echo("preview_data <- tidyr::pivot_wider(" + options.join(", ") + ")\n");
    
}

function preprocess(is_preview){
	// add requirements etc. here
	if(is_preview) {
		echo("if(!base::require(tidyr)){stop(" + i18n("Preview not available, because package tidyr is not installed or cannot be loaded.") + ")}\n");
	} else {
		echo("require(tidyr)\n");
	}
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var data_frame = getValue("data_slot_wide");
    var id_cols_full_string = getValue("id_cols_slot");
    var values_from_full = getValue("values_from_slot");
    var names_repair = getValue("names_repair_wide");
    var create_seq = getValue("create_seq");
    var seq_name = getValue("seq_name");
    var seq_group_string = getValue("seq_group");
    var seq_include = getValue("seq_include");
    var names_from_full = getValue("names_from_slot");

    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\[\[\"(.*?)\"\]\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var input_data_obj = data_frame;

    // Sequence Generation Logic
    if (create_seq == "1") {
        var temp_obj = "data_seq";
        // Create temp obj copy
        echo(temp_obj + " <- " + data_frame + "\n");

        var group_vars = seq_group_string.split(/\s+/).filter(function(n){ return n != "" }).map(function(item) { return getColumnName(item); });

        if (group_vars.length > 0) {
            // Join with quote-comma-quote safely
            var grp_str = group_vars.join(", ");
            var primary_grp = group_vars[0];
            echo(temp_obj + "[['" + seq_name + "']] <- with(" + temp_obj + ", stats::ave(seq_along(" + primary_grp + "), " + grp_str + ", FUN = seq_along))\n");
        } else {
             echo(temp_obj + "[['" + seq_name + "']] <- seq_len(nrow(" + temp_obj + "))\n");
        }
        input_data_obj = temp_obj;
    }

    var options = new Array();
    options.push("data = " + input_data_obj);

    if(id_cols_full_string){
        var id_cols_array = id_cols_full_string.split(/\s+/).filter(function(n){ return n != "" });
        var id_col_names = id_cols_array.map(function(item) { return getColumnName(item); });
        options.push("id_cols = c('" + id_col_names.join("', '") + "')");
    }

    if (create_seq == "1") {
        options.push("names_from = " + seq_name);
    } else {
        options.push("names_from = " + getColumnName(names_from_full));
    }

    // Handle multiple values_from
    var val_cols_array = values_from_full.split(/\s+/).filter(function(n){ return n != "" });
    var val_col_names = val_cols_array.map(function(item) { return getColumnName(item); });

    // If sequence is created AND checkbox is checked, add it to values_from list
    if (create_seq == "1" && seq_include == "1") {
        val_col_names.push(seq_name);
    }

    options.push("values_from = c('" + val_col_names.join("', '") + "')");

    if(names_repair != "check_unique"){
        options.push("names_repair = \"" + names_repair + "\"");
    }

    
    echo("data.wide <- tidyr::pivot_wider(" + options.join(", ") + ")\n");
    
}

function printout(is_preview){
	// read in variables from dialog


	// printout the results

    if(getValue("save_wide.active")) {
        echo("rk.header(\"Pivot Data (Wider)\")\n");
        echo("rk.header(\"Result saved in: " + getValue("save_wide") + "\", level=3, toc=TRUE)\n");
    }

	if(!is_preview) {
		//// save result object
		// read in saveobject variables
		var saveWide = getValue("save_wide");
		var saveWideActive = getValue("save_wide.active");
		var saveWideParent = getValue("save_wide.parent");
		// assign object to chosen environment
		if(saveWideActive) {
			echo(".GlobalEnv$" + saveWide + " <- data.wide\n");
		}	
	}

}

