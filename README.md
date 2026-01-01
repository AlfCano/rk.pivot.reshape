# RKWard Plugin: Pivot Reshape (`rk.pivot.reshape`)

![Version](https://img.shields.io/badge/Version-0.01.9-blue.svg)
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

### Pivot Wider
-   Select a long-format data frame to widen.
-   Specify the "key" column whose values will become the new column headers (`names_from`).
-   Specify the "value" column whose values will fill the cells of the new columns (`values_from`).
-   Optionally select one or more ID columns (`id_cols`) to keep fixed, ensuring each row remains unique.
-   Save the reshaped, wider data frame to a new R object.

### Internationalization
**Internationalization (i18n):** Fully localized interface available in multiple languages.

#### Supported Languages
As of version 0.01.9, this plugin is available in:
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
3.  In the "Column for new column names (names_from)" slot, select the single column that contains the keys (i.e., the future column headers).
4.  In the "Column for cell values (values_from)" slot, select the single column that contains the values.
5.  Optionally, select any ID columns that should be preserved.
6.  Specify a name for the output object and click **Submit**.

## Output

Both plugins are designed for data transformation. Their primary output is a **new data frame object** saved to your R workspace with the name you specified. A confirmation message will appear in the RKWard Output window upon successful completion.

## License

This plugin is licensed under the GPL (>= 3).

## Author
* Alfonso Cano (alfonso.cano@correo.buap.mx)
* Assisted by Gemini, a large language model from Google.
