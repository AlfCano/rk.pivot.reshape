// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!

function preview(){
	
    var data_frame = getValue("data_slot");
    var cols_full_string = getValue("cols_slot");
    var names_to = getValue("names_to");
    var values_to = getValue("values_to");
    var names_repair = getValue("names_repair");
    var drop_na = getValue("drop_na");

    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\[\[\"(.*?)\"\]\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var options = new Array();
    options.push("data = " + data_frame);
    var cols_array = cols_full_string.split(/\s+/).filter(function(n){ return n != "" });
    var col_names = cols_array.map(function(item) { return getColumnName(item); });
    options.push("cols = c('" + col_names.join("', '") + "')");
    options.push("names_to = \"" + names_to + "\"");
    options.push("values_to = \"" + values_to + "\"");
    if(names_repair != "check_unique"){ options.push("names_repair = \"" + names_repair + "\""); }
    if(drop_na == "1"){ options.push("values_drop_na = TRUE"); }
    echo("preview_data <- tidyr::pivot_longer(" + options.join(", ") + ")\n");

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

    var data_frame = getValue("data_slot");
    var cols_full_string = getValue("cols_slot");
    var names_to = getValue("names_to");
    var values_to = getValue("values_to");
    var names_repair = getValue("names_repair");
    var drop_na = getValue("drop_na");

    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\[\[\"(.*?)\"\]\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var options = new Array();
    options.push("data = " + data_frame);
    var cols_array = cols_full_string.split(/\s+/).filter(function(n){ return n != "" });
    var col_names = cols_array.map(function(item) { return getColumnName(item); });

    // Safer join
    options.push("cols = c('" + col_names.join("', '") + "')");
    options.push("names_to = \"" + names_to + "\"");
    options.push("values_to = \"" + values_to + "\"");

    if(names_repair != "check_unique"){ options.push("names_repair = \"" + names_repair + "\""); }
    if(drop_na == "1"){ options.push("values_drop_na = TRUE"); }
    echo("data.long <- tidyr::pivot_longer(" + options.join(", ") + ")\n");

}

function printout(is_preview){
	// read in variables from dialog


	// printout the results

    if(getValue("save_long.active")) {
        echo("rk.header(\"Pivot Data (Longer)\")\n");
        echo("rk.header(\"Result saved in: " + getValue("save_long") + "\", level=3, toc=TRUE)\n");
    }

	if(!is_preview) {
		//// save result object
		// read in saveobject variables
		var saveLong = getValue("save_long");
		var saveLongActive = getValue("save_long.active");
		var saveLongParent = getValue("save_long.parent");
		// assign object to chosen environment
		if(saveLongActive) {
			echo(".GlobalEnv$" + saveLong + " <- data.long\n");
		}	
	}

}

