// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(tidyr)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    // Load GUI values
    var data_frame = getValue("data_slot");
    var cols_full_string = getValue("cols_slot");
    var names_to = getValue("names_to");
    var values_to = getValue("values_to");
    var names_repair = getValue("names_repair");
    var drop_na = getValue("drop_na");

    // Robust helper function to extract pure column names
    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\[\[\"(.*?)\"\]\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    // Start building R command
    var options = new Array();
    options.push("data = " + data_frame);
    
    // CORRECTED PARSING: Split the string by any whitespace and filter out empty strings.
    var cols_array = cols_full_string.split(/\s+/).filter(function(n){ return n != "" });
    var col_names = cols_array.map(function(item) { return getColumnName(item); });
    options.push("cols = c(\"" + col_names.join("\", \"") + "\")");

    options.push("names_to = \"" + names_to + "\"");
    options.push("values_to = \"" + values_to + "\"");
    
    if(names_repair != "check_unique"){
        options.push("names_repair = \"" + names_repair + "\"");
    }
    // Golden Rule 6: Robust checkbox handling
    if(drop_na == "1" || drop_na == 1 || drop_na == true){
        options.push("values_drop_na = TRUE");
    }
    
    echo("data.long <- tidyr::pivot_longer(" + options.join(", ") + ")\n");

}

function printout(is_preview){
	// printout the results

    echo("rk.header(\"Pivot Longer results saved to object.\")\n");

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

