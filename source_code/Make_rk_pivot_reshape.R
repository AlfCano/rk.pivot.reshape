local({
# Golden Rule 1: This R script is the single source of truth.
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
      version = "0.01.10",
      date = format(Sys.Date(), "%Y-%m-%d"),
      url = "https://github.com/AlfCano/rk.pivot.reshape",
      license = "GPL (>= 3)",
      dependencies = "R (>= 3.00)"
    )
)

# =========================================================================================
# COMPONENT 1: pivot_longer
# =========================================================================================
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
longer_preview_button <- rk.XML.preview(mode = "data")

longer_dialog <- rk.XML.dialog(label = "Pivot Data from Wide to Long", child = rk.XML.row(longer_df_selector, rk.XML.col(longer_data_slot, longer_cols_slot, longer_names_to_input, longer_values_to_input, longer_names_repair_dropdown, longer_values_drop_na_cbox, longer_save_object, longer_preview_button)))

longer_help <- rk.rkh.doc(summary = rk.rkh.summary(text = "Lengthens data by converting multiple columns into two: a 'key' column and a 'value' column."), title = rk.rkh.title(text = "Pivot Longer"))

js_longer_calculate <- '
    var data_frame = getValue("data_slot");
    var cols_full_string = getValue("cols_slot");
    var names_to = getValue("names_to");
    var values_to = getValue("values_to");
    var names_repair = getValue("names_repair");
    var drop_na = getValue("drop_na");

    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\\[\\[\\"(.*?)\\"\\]\\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var options = new Array();
    options.push("data = " + data_frame);
    var cols_array = cols_full_string.split(/\\s+/).filter(function(n){ return n != "" });
    var col_names = cols_array.map(function(item) { return getColumnName(item); });

    // Safer join
    options.push("cols = c(\'" + col_names.join("\', \'") + "\')");
    options.push("names_to = \\"" + names_to + "\\"");
    options.push("values_to = \\"" + values_to + "\\"");

    if(names_repair != "check_unique"){ options.push("names_repair = \\"" + names_repair + "\\""); }
    if(drop_na == "1"){ options.push("values_drop_na = TRUE"); }
    echo("data.long <- tidyr::pivot_longer(" + options.join(", ") + ")\\n");
'

js_longer_preview <- '
    var data_frame = getValue("data_slot");
    var cols_full_string = getValue("cols_slot");
    var names_to = getValue("names_to");
    var values_to = getValue("values_to");
    var names_repair = getValue("names_repair");
    var drop_na = getValue("drop_na");

    function getColumnName(fullName) {
        if (!fullName) return "";
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\\[\\[\\"(.*?)\\"\\]\\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var options = new Array();
    options.push("data = " + data_frame);
    var cols_array = cols_full_string.split(/\\s+/).filter(function(n){ return n != "" });
    var col_names = cols_array.map(function(item) { return getColumnName(item); });
    options.push("cols = c(\'" + col_names.join("\', \'") + "\')");
    options.push("names_to = \\"" + names_to + "\\"");
    options.push("values_to = \\"" + values_to + "\\"");
    if(names_repair != "check_unique"){ options.push("names_repair = \\"" + names_repair + "\\""); }
    if(drop_na == "1"){ options.push("values_drop_na = TRUE"); }
    echo("preview_data <- tidyr::pivot_longer(" + options.join(", ") + ")\\n");
'

# UPDATED: Added headers
js_longer_printout <- '
    if(getValue("save_long.active")) {
        echo("rk.header(\\"Pivot Data (Longer)\\")\\n");
        echo("rk.header(\\"Result saved in: " + getValue("save_long") + "\\", level=3, toc=TRUE)\\n");
    }
'

# =========================================================================================
# COMPONENT 2: pivot_wider (With Auto-Sequence)
# =========================================================================================
wider_df_selector <- rk.XML.varselector(id.name = "wider_df_source", label = "Data frames")
wider_data_slot <- rk.XML.varslot(label = "Data (data.frame)", source = "wider_df_source", id.name = "data_slot_wide", required = TRUE, classes = "data.frame")
wider_values_from_slot <- rk.XML.varslot(label = "Column(s) for cell values (values_from)", source = "wider_df_source", id.name = "values_from_slot", required = TRUE, multi = TRUE)
wider_id_cols_slot <- rk.XML.varslot(label = "ID columns (id_cols, optional)", source = "wider_df_source", id.name = "id_cols_slot", multi = TRUE)
wider_names_repair_dropdown <- rk.XML.dropdown(label = "Handle duplicate column names", id.name = "names_repair_wide", options=list("Check for unique names (default)" = list(val="check_unique", chk=TRUE), "Minimal" = list(val="minimal"), "Make unique" = list(val="unique"), "Make universal" = list(val="universal")))

wider_names_from_slot <- rk.XML.varslot(label = "Column for new column names (names_from)", source = "wider_df_source", id.name = "names_from_slot")
seq_cbox <- rk.XML.cbox(label="Generate Sequence/Index Column (Handles duplicates)", value="1", id.name="create_seq")
seq_name_input <- rk.XML.input(label="Name for new sequence variable", initial="repet", id.name="seq_name")
seq_group_slot <- rk.XML.varslot(label="Group sequence by (usually ID)", source="wider_df_source", multi=TRUE, id.name="seq_group")
seq_include_cbox <- rk.XML.cbox(label="Include index variable in output (values_from)", value="1", id.name="seq_include")

attr(wider_names_from_slot, "dependencies") <- list(enabled = list(string = "create_seq.state != '1'"))
attr(seq_name_input, "dependencies") <- list(enabled = list(string = "create_seq.state == '1'"))
attr(seq_group_slot, "dependencies") <- list(enabled = list(string = "create_seq.state == '1'"))
attr(seq_include_cbox, "dependencies") <- list(enabled = list(string = "create_seq.state == '1'"))

seq_frame <- rk.XML.frame(seq_cbox, seq_name_input, seq_group_slot, seq_include_cbox, label="Automatic Sequence Generation")

wider_save_object <- rk.XML.saveobj(label = "Save wider data to", chk=TRUE, initial = "data.wide", id.name = "save_wide")
wider_preview_button <- rk.XML.preview(mode = "data")

wider_tabs <- rk.XML.tabbook(tabs = list(
    "Data & Values" = rk.XML.col(wider_data_slot, wider_id_cols_slot, wider_values_from_slot, wider_names_repair_dropdown),
    "Column Naming" = rk.XML.col(wider_names_from_slot, seq_frame),
    "Output" = rk.XML.col(wider_save_object, wider_preview_button)
))

wider_dialog <- rk.XML.dialog(label = "Pivot Data from Long to Wide", child = rk.XML.row(wider_df_selector, wider_tabs))

wider_help <- rk.rkh.doc(summary = rk.rkh.summary(text = "Widens data by converting a key/value pair of columns into multiple columns."), title = rk.rkh.title(text = "Pivot Wider"))

# Shared JS Generator for Wider
js_gen_wider <- function(is_preview) {
  paste0('
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
        if (fullName.indexOf("[[") > -1) { return fullName.match(/\\[\\[\\"(.*?)\\"\\]\\]/)[1]; }
        else if (fullName.indexOf("$") > -1) { return fullName.substring(fullName.lastIndexOf("$") + 1); }
        else { return fullName; }
    }

    var input_data_obj = data_frame;

    // Sequence Generation Logic
    if (create_seq == "1") {
        var temp_obj = "data_seq";
        // Create temp obj copy
        echo(temp_obj + " <- " + data_frame + "\\n");

        var group_vars = seq_group_string.split(/\\s+/).filter(function(n){ return n != "" }).map(function(item) { return getColumnName(item); });

        if (group_vars.length > 0) {
            // Join with quote-comma-quote safely
            var grp_str = group_vars.join(", ");
            var primary_grp = group_vars[0];
            echo(temp_obj + "[[\'" + seq_name + "\']] <- with(" + temp_obj + ", stats::ave(seq_along(" + primary_grp + "), " + grp_str + ", FUN = seq_along))\\n");
        } else {
             echo(temp_obj + "[[\'" + seq_name + "\']] <- seq_len(nrow(" + temp_obj + "))\\n");
        }
        input_data_obj = temp_obj;
    }

    var options = new Array();
    options.push("data = " + input_data_obj);

    if(id_cols_full_string){
        var id_cols_array = id_cols_full_string.split(/\\s+/).filter(function(n){ return n != "" });
        var id_col_names = id_cols_array.map(function(item) { return getColumnName(item); });
        options.push("id_cols = c(\'" + id_col_names.join("\', \'") + "\')");
    }

    if (create_seq == "1") {
        options.push("names_from = " + seq_name);
    } else {
        options.push("names_from = " + getColumnName(names_from_full));
    }

    // Handle multiple values_from
    var val_cols_array = values_from_full.split(/\\s+/).filter(function(n){ return n != "" });
    var val_col_names = val_cols_array.map(function(item) { return getColumnName(item); });

    // If sequence is created AND checkbox is checked, add it to values_from list
    if (create_seq == "1" && seq_include == "1") {
        val_col_names.push(seq_name);
    }

    options.push("values_from = c(\'" + val_col_names.join("\', \'") + "\')");

    if(names_repair != "check_unique"){
        options.push("names_repair = \\"" + names_repair + "\\"");
    }

    ', if(is_preview) '
    echo("preview_data <- tidyr::pivot_wider(" + options.join(", ") + ")\\n");
    ' else '
    echo("data.wide <- tidyr::pivot_wider(" + options.join(", ") + ")\\n");
    '
  )
}

# UPDATED: Added headers
js_wider_printout <- '
    if(getValue("save_wide.active")) {
        echo("rk.header(\\"Pivot Data (Wider)\\")\\n");
        echo("rk.header(\\"Result saved in: " + getValue("save_wide") + "\\", level=3, toc=TRUE)\\n");
    }
'

pivot_wider_component <- rk.plugin.component("Pivot Wider", xml = list(dialog = wider_dialog), js = list(require="tidyr", calculate=js_gen_wider(FALSE), preview=js_gen_wider(TRUE), printout=js_wider_printout, results.header=FALSE), rkh = list(help = wider_help), hierarchy = list("data", "Pivot reshape"), provides = "logic")

plugin.dir <- rk.plugin.skeleton(
    about = package_about, path = ".",
    xml = list(dialog = longer_dialog),
    js = list(require="tidyr", calculate=js_longer_calculate, preview=js_longer_preview, printout=js_longer_printout, results.header=FALSE),
    rkh = list(help = longer_help), provides = "logic",
    components = list(pivot_wider_component),
    pluginmap = list(name = "Pivot Longer", hierarchy = list("data", "Pivot reshape"), po_id = plugin_name),
    create = c("pmap", "xml", "js", "desc", "rkh"), overwrite = TRUE, load = TRUE, show = FALSE
)

message(paste0('Plugin package \'', plugin_name, '\' created successfully in \'', plugin.dir, '\'!\n'))
})
