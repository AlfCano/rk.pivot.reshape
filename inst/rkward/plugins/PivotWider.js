// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!

function preview(){
	
    // Load GUI values
    var data_frame = getValue("data_slot_wide");
    var id_cols_full_string = getValue("id_cols_slot");
    var names_from_full = getValue("names_from_slot");
    var values_from_full = getValue("values_from_slot");
    var names_repair = getValue("names_repair_wide");

    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\[\[\"(.*?)\"\]\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var options = new Array();
    options.push("data = " + data_frame);
    if(id_cols_full_string){
        var id_cols_array = id_cols_full_string.split(/\s+/).filter(function(n){ return n != "" });
        var id_col_names = id_cols_array.map(function(item) { return getColumnName(item); });
        options.push("id_cols = c(\"" + id_col_names.join("\", \"") + "\")");
    }
    options.push("names_from = " + getColumnName(names_from_full));
    options.push("values_from = " + getColumnName(values_from_full));
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

    // Load GUI values
    var data_frame = getValue("data_slot_wide");
    var id_cols_full_string = getValue("id_cols_slot");
    var names_from_full = getValue("names_from_slot");
    var values_from_full = getValue("values_from_slot");
    var names_repair = getValue("names_repair_wide");

    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\[\[\"(.*?)\"\]\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var options = new Array();
    options.push("data = " + data_frame);
    if(id_cols_full_string){
        var id_cols_array = id_cols_full_string.split(/\s+/).filter(function(n){ return n != "" });
        var id_col_names = id_cols_array.map(function(item) { return getColumnName(item); });
        options.push("id_cols = c(\"" + id_col_names.join("\", \"") + "\")");
    }
    options.push("names_from = " + getColumnName(names_from_full));
    options.push("values_from = " + getColumnName(values_from_full));
    if(names_repair != "check_unique"){
        options.push("names_repair = \"" + names_repair + "\"");
    }
    echo("data.wide <- tidyr::pivot_wider(" + options.join(", ") + ")\n");

}

function printout(is_preview){
	// read in variables from dialog


	// printout the results

    if(getValue("save_wide") == "1"){
        echo("rk.header(\"Pivot Wider results saved to object: " + getValue("save_wide.objectname") + "\")\n");
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

