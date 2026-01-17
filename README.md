# RKWard Plugin: Pivot Reshape (`rk.pivot.reshape`)

![Version](https://img.shields.io/badge/Version-0.01.10-blue.svg)
![License](https://img.shields.io/badge/License-GPL--3-green.svg)
[![R Linter](https://github.com/AlfCano/rk.pivot.reshape/actions/workflows/lintr.yml/badge.svg)](https://github.com/AlfCano/rk.pivot.reshape/actions/workflows/lintr.yml)

> An RKWard plugin package to easily reshape data frames by pivoting them from wide to long (`pivot_longer`) or long to wide (`pivot_wider`), powered by the `tidyr` package.

## Overview

This plugin package provides two powerful data reshaping tools within the RKWard graphical user interface, making common data wrangling tasks more accessible. It acts as a friendly front-end for two core functions from the popular `tidyr` package:

1.  **Pivot Longer**: Lengthens data by converting multiple columns into two new columns: a "key" column (containing the original column headers) and a "value" column. This is useful for tidying data for analysis and plotting.
2.  **Pivot Wider**: Widens data by taking a key-value pair of columns and spreading them out into multiple new columns. This is the inverse of `pivot_longer` and is often used for creating summary tables or preparing data for specific modeling formats.

## Features

### Pivot Longer
-   Select a data frame and two or more columns to pivot.
-   Specify custom names for the new "key" (`names_to`) and "value" (`values_to`) columns.
-   Choose a strategy for handling potentially non-unique column names (`names_repair`).
-   Optionally remove rows where the new value column contains `NA` (`values_drop_na`).
-   Save the reshaped, longer data frame to a new R object.

### Pivot Wider (Updated in v0.0.10)
-   Select a long-format data frame to widen.
-   **Multiple Value Columns:** Select **one or more** columns whose values will fill the cells of the new columns (`values_from`).
-   **Automatic Sequence Generation:** Automatically handles duplicate identifiers (where a single ID has multiple rows) by generating an index/sequence column.
    -   *Example:* If a Teacher has 3 classes, it creates a counter (1, 2, 3) to spread the classes into columns `Class_1`, `Class_2`, `Class_3`.
    -   Option to include this generated index variable in the final output.
-   Specify the "key" column whose values will become the new column headers (`names_from`).
-   Optionally select any ID columns (`id_cols`) to keep fixed.
-   Save the reshaped, wider data frame to a new R object.

### Internationalization
**Internationalization (i18n):** Fully localized interface available in multiple languages.

#### Supported Languages
As of version 0.01.10, this plugin is available in:
*   🇺🇸 English (Default)
*   🇪🇸 Spanish (`es`)
*   🇫🇷 French (`fr`)
*   🇩🇪 German (`de`)
*   🇧🇷 Portuguese (Brazil) (`pt_BR`)

## Installation

### With `devtools` (Recommended)
You can install this plugin directly from its repository using the `devtools` package in R.

```r
# If you don't have devtools installed:
# install.packages("devtools")
local({
## Prepare
require(devtools)
## Compute
  install_github(
    repo="AlfCano/rk.pivot.reshape",
    force = TRUE
  )
## Print result
rk.header ("Installation from git result")
})
```

### Manual Installation
1.  Download this repository as a `.zip` file.
2.  In RKWard, go to **Settings -> R Packages -> Install package(s) from local zip file(s)** and select the downloaded file.
3.  **Restart RKWard** (This is required for the new plugin and translations to load).
4.  The plugin will be available in the `Data` menu.

## Usage

Once installed, the plugins can be found in the **Data -> Pivot reshape** menu in RKWard.

### Using "Pivot Longer"
1.  Navigate to **Data -> Pivot reshape -> Pivot Longer**.
2.  Select the input `data.frame` you want to make longer.
3.  In the "Columns to pivot (cols)" slot, select **at least two** columns that you want to gather.
4.  Optionally, change the default names for the new key and value columns.
5.  Set other options as needed and specify a name for the output object.
6.  Click **Submit**.

### Using "Pivot Wider"
1.  Navigate to **Data -> Pivot reshape -> Pivot Wider**.
2.  Select the input `data.frame` you want to make wider.
3.  **Tab: Data & Values**:
    *   Select the ID columns (optional) and the **Column(s) for cell values**.
4.  **Tab: Column Naming**:
    *   **Standard Method:** Select the column containing the new headers in "Column for new column names".
    *   **Sequence Method:** If you have duplicates, check **"Generate Sequence/Index Column"**. This will disable the standard name selector and automatically create headers based on a sequence (e.g., `variable_1`, `variable_2`).
5.  **Tab: Output**:
    *   Specify a name for the output object.
    *   Click **Preview** to check the result.
6.  Click **Submit**.

## Output

Both plugins are designed for data transformation. Their primary output is a **new data frame object** saved to your R workspace with the name you specified. A confirmation message will appear in the RKWard Output window upon successful completion.

## Dependencies

This plugin relies on the following R packages:

*   `tidyr` (Core logic)
*   `rkwarddev` (Plugin generation)

### Troubleshooting: Errors installing `devtools` or missing binary dependencies (Windows)

If you encounter errors mentioning "non-zero exit status", "namespace is already loaded", or requirements for compilation (compiling from source) when installing packages, it is likely because the R version bundled with RKWard is older than the current CRAN standard.

**Workaround:**
Until a new, more recent version of R (current bundled version is 4.3.3) is packaged into the RKWard executable, these issues will persist. To fix this:

1.  Download and install the latest version of R (e.g., 4.5.2 or newer) from [CRAN](https://cloud.r-project.org/).
2.  Open RKWard and go to the **Settings** (or Preferences) menu.
3.  Run the **"Installation Checker"**.
4.  Point RKWard to the newly installed R version.

This "two-step" setup (similar to how RStudio operates) ensures you have access to the latest pre-compiled binaries, avoiding the need for RTools and manual compilation.

## License

This plugin is licensed under the GPL (>= 3).

## Author
* Alfonso Cano (alfonso.cano@correo.buap.mx)
* Assisted by Gemini, a large language model from Google.
