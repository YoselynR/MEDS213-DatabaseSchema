# Industrial Energy Efficiency Data Table Visuals

This project was developed as part of UCSB MEDS 213: DataBases and Data Management

---

## Overview

This repository supports a data exploration project analyzing industrial energy efficiency opportunities in the U.S. manufacturing sector. The focus is on:
- Creating normalized database tables from raw CSV data using SQL.
- Building visualizations in Python to uncover patterns and trends related to emissions and implementation costs.

---

## Repository Structure

```
├── data (excluded on GitHub)
├── exports
│   ├── arc.csv
│   ├── assess.csv
│   └── emissions.csv
├── figures
│   ├── impcost_vs_payback.png
│   ├── impcost_by_year_arc.png
│   ├── arc_category_frequency.png
│   └── emissions_vs_impcost.png
├── .gitignore
├── ReadMe.md
├── LICENSE
├── Capstone.py
└── Capstone.sql
```


- SQL code is used to clean and normalize the raw dataset into three main tables: `assess`, `arc`, and `emissions`.
- Python is used for exploratory visualizations.

---

## SQL Workflow

Tables are created using Duckdb and SQL syntax in VSCode. 

**Key steps include:**
- Reading `iac_integrated_data.csv` into a temporary raw table.
- Creating cleaned tables: `clean_raw_data`, `industrialenergy.assess`, `industrialenergy.arc`, `industrialenergy.emissions`.
- Using `COPY TO` statements to export the tables into the `exports/` folder.

---

## Python Visualizations

Python and Matplotlib are used to generate visualizations

- **Scatter Plot**: `impcost` vs `payback`, highlighting cost-benefit patterns.
- **Histogram**: Emission factor distributions by `arc2` categories.
- **Color-coded scatterplot**: Emissions avoided vs implementation cost by arc group.
- **Arc frequency bar plot**: Reduced `arc2` codes (2 digits) with labels.

---

## Data Access

Raw data lives in data/iac_integrated_data.csv. (Not on GitHub)
Processed tables are exported to exports/*.csv using DuckDB and can be downloaded.
The raw dataset was originally sourced from the Industrial Energy Efficiency Data Explorer [Temporary Link to Data Explorer](http://128.111.110.37:3009/dashboard) the full dataset will be accesible soon on the site soon. The dataset for this project is stored in the Capstone Project Industrial Energy Drive. 

---

## Acknowledgements

The data used in this project was provided by the Industrial Energy Efficiency Data Explorer:

"A Data-Driven Support Tool for Industrial Energy Modelers."

**A product by:**

Eva Newby
Oksana Protsuhka
Naomi Moraes
Yos Ramirez
Eric Masanet

---

## Author

Yos Ramirez


 
