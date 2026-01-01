local({
# Golden Rule 1: This R script is the single source of truth.
# It programmatically defines and generates all plugin files.

# --- PRE-FLIGHT CHECK ---
# Stop if the user is accidentally running this inside an existing plugin folder
if(basename(getwd()) == "rk.pivot.reshape") {
  stop("Your current working directory is already 'rk.pivot.reshape'. Please navigate to the parent directory ('..') before running this script to avoid creating a nested folder structure.")
}

# Require "rkward.replaces"
require(rkwarddev)
rkwarddev.required("0.08-1")

# --- GLOBAL SETTINGS ---
plugin_name <- "rk.pivot.reshape"

# =========================================================================================
# PACKAGE DEFINITION (GLOBAL METADATA)
# =========================================================================================
package_about <- rk.XML.about(
    name = plugin_name,
    author = person(
      given = "Alfonso",
      family = "Cano Robles",
      email = "alfonso.cano@correo.buap.mx",
      role = c("aut", "cre")
    ),
    about = list(
      desc = "An RKWard plugin to reshape data by pivoting it longer or wider using functions from the 'tidyr' package.",
      # UPDATED VERSION
      version = "0.01.9",
      date = format(Sys.Date(), "%Y-%m-%d"),
      url = "https://github.com/AlfCano/rk.pivot.reshape",
      license = "GPL",
      dependencies = "R (>= 3.00)"
    )
)

# =========================================================================================
# COMPONENT DEFINITION 1: pivot_longer (Main Component)
# =========================================================================================

# --- UI Definition for pivot_longer ---
longer_df_selector <- rk.XML.varselector(id.name = "longer_df_source", label = "Data frames")
longer_data_slot <- rk.XML.varslot(label = "Data (data.frame)", source = "longer_df_source", id.name = "data_slot", required = TRUE, classes = "data.frame")
longer_cols_slot <- rk.XML.varslot(label= "Columns to pivot (cols)", source= "longer_df_source", required = TRUE, multi = TRUE, min = 2, id.name = "cols_slot")
longer_names_to_input <- rk.XML.input(label = "Name for new key column (names_to)", initial = "name", id.name = "names_to")
longer_values_to_input <- rk.XML.input(label = "Name for new value column (values_to)", initial = "value", id.name = "values_to")
longer_names_repair_dropdown <- rk.XML.dropdown(label = "Handle duplicate column names (names_repair)", id.name = "names_repair", options=list(
    "Check for unique names (default)" = list(val="check_unique", chk=TRUE), "Minimal" = list(val="minimal"), "Make unique" = list(val="unique"), "Make universal" = list(val="universal")
))
longer_values_drop_na_cbox <- rk.XML.cbox(label = "Drop rows with NA values (values_drop_na)", value="1", id.name = "drop_na")
longer_save_object <- rk.XML.saveobj(label = "Save longer data to", chk=TRUE, initial = "data.long", id.name = "save_long")
longer_preview_button <- rk.XML.preview(mode = "data") # NEW

longer_dialog <- rk.XML.dialog(
    label = "Pivot Data from Wide to Long",
    child = rk.XML.row(
        longer_df_selector,
        rk.XML.col(
            longer_data_slot, longer_cols_slot, longer_names_to_input, longer_values_to_input,
            longer_names_repair_dropdown, longer_values_drop_na_cbox, longer_save_object,
            longer_preview_button # ADDED to layout
        )
    )
)

# --- Help File for pivot_longer ---
longer_help <- rk.rkh.doc(
    summary = rk.rkh.summary(text = "Lengthens data by converting multiple columns into two: a 'key' column and a 'value' column."),
    usage = rk.rkh.usage(text = "Select a data frame and at least two columns you wish to pivot into a longer format. The result is saved to a new R object."),
    sections = list(
        rk.rkh.section(title="Options", text="<p><b>Columns to pivot (cols):</b> Select two or more columns that will be gathered into the new key/value pair columns.</p><p><b>Name for new key column (names_to):</b> The name for the new column that will contain what were previously column headers.</p><p><b>Name for new value column (values_to):</b> The name for the new column that will contain the values previously spread across the selected pivot columns.</p>")
    ),
    title = rk.rkh.title(text = "Pivot Longer")
)


# --- JavaScript Logic for pivot_longer ---
js_longer_calculate <- '
    // Load GUI values
    var data_frame = getValue("data_slot");
    var cols_full_string = getValue("cols_slot");
    var names_to = getValue("names_to");
    var values_to = getValue("values_to");
    var names_repair = getValue("names_repair");
    var drop_na = getValue("drop_na");

    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\\[\\[\\\"(.*?)\\\"\\]\\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var options = new Array();
    options.push("data = " + data_frame);
    var cols_array = cols_full_string.split(/\\s+/).filter(function(n){ return n != "" });
    var col_names = cols_array.map(function(item) { return getColumnName(item); });
    options.push("cols = c(\\"" + col_names.join("\\", \\"") + "\\")");
    options.push("names_to = \\"" + names_to + "\\"");
    options.push("values_to = \\"" + values_to + "\\"");
    if(names_repair != "check_unique"){
        options.push("names_repair = \\"" + names_repair + "\\"");
    }
    if(drop_na == "1"){
        options.push("values_drop_na = TRUE");
    }
    echo("data.long <- tidyr::pivot_longer(" + options.join(", ") + ")\\n");
'

# NEW: JavaScript for pivot_longer preview
js_longer_preview <- '
    // Load GUI values
    var data_frame = getValue("data_slot");
    var cols_full_string = getValue("cols_slot");
    var names_to = getValue("names_to");
    var values_to = getValue("values_to");
    var names_repair = getValue("names_repair");
    var drop_na = getValue("drop_na");

    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\\[\\[\\\"(.*?)\\\"\\]\\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var options = new Array();
    options.push("data = " + data_frame);
    var cols_array = cols_full_string.split(/\\s+/).filter(function(n){ return n != "" });
    var col_names = cols_array.map(function(item) { return getColumnName(item); });
    options.push("cols = c(\\"" + col_names.join("\\", \\"") + "\\")");
    options.push("names_to = \\"" + names_to + "\\"");
    options.push("values_to = \\"" + values_to + "\\"");
    if(names_repair != "check_unique"){
        options.push("names_repair = \\"" + names_repair + "\\"");
    }
    if(drop_na == "1"){
        options.push("values_drop_na = TRUE");
    }
    echo("preview_data <- tidyr::pivot_longer(" + options.join(", ") + ")\\n");
'

js_longer_printout <- '
    if(getValue("save_long") == "1"){
        echo("rk.header(\\"Pivot Longer results saved to object: " + getValue("save_long.objectname") + "\\")\\n");
    }
'

# =========================================================================================
# COMPONENT DEFINITION 2: pivot_wider (Additional Component)
# =========================================================================================

# --- UI Definition for pivot_wider ---
wider_df_selector <- rk.XML.varselector(id.name = "wider_df_source", label = "Data frames")
wider_data_slot <- rk.XML.varslot(label = "Data (data.frame)", source = "wider_df_source", id.name = "data_slot_wide", required = TRUE, classes = "data.frame")
wider_id_cols_slot <- rk.XML.varslot(label = "ID columns (id_cols, optional)", source = "wider_df_source", id.name = "id_cols_slot", multi = TRUE)
wider_names_from_slot <- rk.XML.varslot(label = "Column for new column names (names_from)", source = "wider_df_source", id.name = "names_from_slot", required = TRUE)
wider_values_from_slot <- rk.XML.varslot(label = "Column for cell values (values_from)", source = "wider_df_source", id.name = "values_from_slot", required = TRUE)
wider_names_repair_dropdown <- rk.XML.dropdown(label = "Handle duplicate column names (names_repair)", id.name = "names_repair_wide", options=list(
    "Check for unique names (default)" = list(val="check_unique", chk=TRUE), "Minimal" = list(val="minimal"), "Make unique" = list(val="unique"), "Make universal" = list(val="universal")
))
wider_save_object <- rk.XML.saveobj(label = "Save wider data to", chk=TRUE, initial = "data.wide", id.name = "save_wide")
wider_preview_button <- rk.XML.preview(mode = "data") # NEW

wider_dialog <- rk.XML.dialog(
    label = "Pivot Data from Long to Wide",
    child = rk.XML.row(
        wider_df_selector,
        rk.XML.col(
            wider_data_slot, wider_id_cols_slot, wider_names_from_slot,
            wider_values_from_slot, wider_names_repair_dropdown, wider_save_object,
            wider_preview_button # ADDED to layout
        )
    )
)

# --- Help File for pivot_wider ---
wider_help <- rk.rkh.doc(
    summary = rk.rkh.summary(text = "Widens data by converting a key/value pair of columns into multiple columns."),
    usage = rk.rkh.usage(text = "Select a data frame, the key column to get new column names from, and the value column to fill the cells. The result is saved to a new R object."),
    sections = list(
        rk.rkh.section(title="Options", text="<p><b>ID columns:</b> Optional columns that uniquely identify each row. If left blank, all columns not used in `names_from` or `values_from` will be used.</p><p><b>Column for new column names (names_from):</b> Select the column whose values will become the new column headers.</p><p><b>Column for cell values (values_from):</b> Select the column whose values will fill the cells of the new columns.</p>")
    ),
    title = rk.rkh.title(text = "Pivot Wider")
)


# --- JavaScript Logic for pivot_wider ---
js_wider_calculate <- '
    // Load GUI values
    var data_frame = getValue("data_slot_wide");
    var id_cols_full_string = getValue("id_cols_slot");
    var names_from_full = getValue("names_from_slot");
    var values_from_full = getValue("values_from_slot");
    var names_repair = getValue("names_repair_wide");

    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\\[\\[\\\"(.*?)\\\"\\]\\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var options = new Array();
    options.push("data = " + data_frame);
    if(id_cols_full_string){
        var id_cols_array = id_cols_full_string.split(/\\s+/).filter(function(n){ return n != "" });
        var id_col_names = id_cols_array.map(function(item) { return getColumnName(item); });
        options.push("id_cols = c(\\"" + id_col_names.join("\\", \\"") + "\\")");
    }
    options.push("names_from = " + getColumnName(names_from_full));
    options.push("values_from = " + getColumnName(values_from_full));
    if(names_repair != "check_unique"){
        options.push("names_repair = \\"" + names_repair + "\\"");
    }
    echo("data.wide <- tidyr::pivot_wider(" + options.join(", ") + ")\\n");
'

# NEW: JavaScript for pivot_wider preview
js_wider_preview <- '
    // Load GUI values
    var data_frame = getValue("data_slot_wide");
    var id_cols_full_string = getValue("id_cols_slot");
    var names_from_full = getValue("names_from_slot");
    var values_from_full = getValue("values_from_slot");
    var names_repair = getValue("names_repair_wide");

    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\\[\\[\\\"(.*?)\\\"\\]\\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var options = new Array();
    options.push("data = " + data_frame);
    if(id_cols_full_string){
        var id_cols_array = id_cols_full_string.split(/\\s+/).filter(function(n){ return n != "" });
        var id_col_names = id_cols_array.map(function(item) { return getColumnName(item); });
        options.push("id_cols = c(\\"" + id_col_names.join("\\", \\"") + "\\")");
    }
    options.push("names_from = " + getColumnName(names_from_full));
    options.push("values_from = " + getColumnName(values_from_full));
    if(names_repair != "check_unique"){
        options.push("names_repair = \\"" + names_repair + "\\"");
    }
    echo("preview_data <- tidyr::pivot_wider(" + options.join(", ") + ")\\n");
'

js_wider_printout <- '
    if(getValue("save_wide") == "1"){
        echo("rk.header(\\"Pivot Wider results saved to object: " + getValue("save_wide.objectname") + "\\")\\n");
    }
'

# Create the rk.plugin.component object for pivot_wider
pivot_wider_component <- rk.plugin.component(
    "Pivot Wider",
    xml = list(dialog = wider_dialog),
    # UPDATED: js list now includes the preview script
    js = list(
        require="tidyr",
        calculate=js_wider_calculate,
        preview=js_wider_preview,
        printout=js_wider_printout,
        results.header=FALSE
    ),
    rkh = list(help = wider_help),
    hierarchy = list("data", "Pivot reshape"),
    provides = "logic"
)

# =========================================================================================
# PACKAGE CREATION (THE MAIN CALL)
# =========================================================================================
plugin.dir <- rk.plugin.skeleton(
    about = package_about,
    path = ".",
    # Define the main component (pivot_longer) here
    xml = list(dialog = longer_dialog),
    # UPDATED: js list now includes the preview script
    js = list(
        require="tidyr",
        calculate=js_longer_calculate,
        preview=js_longer_preview,
        printout=js_longer_printout,
        results.header=FALSE
    ),
    rkh = list(help = longer_help),
    provides = "logic",
    # Pass the list of ADDITIONAL components.
    components = list(pivot_wider_component),
    pluginmap = list(
        name = "Pivot Longer",
        hierarchy = list("data", "Pivot reshape"), # Hierarchy of the main component
        # ADDED PO_ID HERE
        po_id = plugin_name
    ),
    create = c("pmap", "xml", "js", "desc", "rkh"),
    overwrite = TRUE,
    load = TRUE,
    show = FALSE
)

# Separation of concerns.
message(
  paste0('Plugin package \'', plugin_name, '\' created successfully in \'', plugin.dir, '\'\n\n'),
  'NEXT STEPS:\n',
  '1. Open RKWard.\n',
  '2. In the R console, run:\n',
  paste0('   rk.updatePluginMessages(pluginmap="inst/rkward/', plugin_name, '.rkmap")\n'),
  '3. Then, to install the plugin, run:\n',
  paste0('   # devtools::install()')
)
})
