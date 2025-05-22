import pandas as pd
import matplotlib.pyplot as plt
import os

# Create a folder for figures if it doesn't exist
os.makedirs('figures', exist_ok=True)

# --- Assess Table Visuals ---

# Load assess data
assess_df = pd.read_csv("exports/assess.csv")

# Scatter Plot of Implementation Cost vs Payback Period
plt.figure(figsize=(8, 6))
plt.scatter(assess_df['impcost'], assess_df['payback'])
plt.title('Implementation Cost vs Payback Period')
plt.xlabel('Implementation Cost')
plt.ylabel('Payback Period (Years)')
plt.tight_layout()
plt.savefig('figures/impcost_vs_payback.png')
plt.show()

# Scatter Plot of Implementation Cost vs Fiscal Year with ARC categories
plt.figure(figsize=(10, 6))
scatter = plt.scatter(
    assess_df['impcost'], assess_df['fy'],
    c=assess_df['arc2'].astype('category').cat.codes,
    cmap='viridis'
)
plt.title('Implementation Cost by Year and ARC Category')
plt.xlabel('Implementation Cost')
plt.ylabel('Fiscal Year')
plt.colorbar(scatter, label='ARC Categories')
plt.tight_layout()
plt.savefig('figures/impcost_by_year_arc.png')
plt.show()


# --- ARC Table Visual ---

# Load arc data
arc_df = pd.read_csv("exports/arc.csv")

# Prepare arc2 category
arc_df['arc2'] = arc_df['arc2'].astype(str)
arc_df['arc2_reduced'] = arc_df['arc2'].str[:3]

# Frequency count of reduced arc categories
arc_counts = arc_df['arc2_reduced'].value_counts()

# Bar plot of ARC category frequencies
plt.figure(figsize=(10, 6))
arc_counts.plot(kind='bar', color='blue')
plt.title('Frequency of Reduced ARC Categories')
plt.xlabel('ARC Categories (First 3 Characters)')
plt.ylabel('Count')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('figures/arc_category_frequency.png')
plt.show()


# --- Emissions vs Cost Visual ---

# Load emissions data
emissions_df = pd.read_csv("exports/emissions.csv")

# Merge emissions with assess data on 'superid'
merged_df = pd.merge(emissions_df, assess_df, on='superid')

# Drop missing values
merged_df = merged_df[['emissions_avoided', 'impcost']].dropna()

# Scatter plot of Emissions Avoided vs Implementation Cost
plt.figure(figsize=(10, 6))
plt.scatter(
    merged_df['impcost'], merged_df['emissions_avoided'],
    alpha=0.6, color='teal', edgecolors='k'
)
plt.title('Emissions Avoided vs Implementation Cost')
plt.xlabel('Implementation Cost')
plt.ylabel('Emissions Avoided')
plt.grid(True)
plt.tight_layout()
plt.savefig('figures/emissions_vs_impcost.png')
plt.show()
