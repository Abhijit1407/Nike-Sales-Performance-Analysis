# 🏀 Nike Global Sales Performance Analysis

This project presents a comprehensive data-driven analysis of Nike's global sales performance using real-world data from Kaggle. Developed using **R**, the analysis employs statistical testing, predictive modeling, and advanced data visualization techniques to uncover the influence of pricing, product categories, regions, seasonality, and online sales channels on Nike’s global business outcomes.

> 📘 Developed as part of the Intermediate Analytics course (ALY6015) at Northeastern University.

---

## 📌 Objectives

- Examine whether **price tiers**, **regions**, and **product categories** affect units sold and revenue.
- Evaluate the **seasonality impact** across global markets and specific regions.
- Predict sales using **Generalized Linear Models** and improve model performance via **Ridge and LASSO regression**.
- Provide **business recommendations** to optimize sales forecasting and marketing strategies.

---

## 🛠️ Tools & Technologies

- **Language**: R
- **Libraries**: `ggplot2`, `dplyr`, `car`, `stats`
- **Techniques Used**:
  - ANOVA, Chi-Square Test, Kruskal-Wallis Test, Shapiro-Wilk Test
  - Poisson Generalized Linear Models (GLM)
  - Ridge Regression, LASSO Regression
- **Visualization**: ggplot2 (boxplots, violin plots, scatter plots, heatmaps)

---

## 📊 Exploratory Data Analysis

Nike's dataset includes 1,000 observations across attributes like `Units_Sold`, `Retail_Price`, `Region`, `Product_Category`, `Month`, and `Online_Sales_Percentage`.

### 🔍 Visual Insights

| Figure | Visualization Description |
|--------|----------------------------|
| 📊 **Fig 1** | Data Structure Snapshot |
| 📊 **Fig 2** | Missing Values Check |
| 📊 **Fig 3** | Summary Statistics for Key Variables |
| 📊 **Fig 4** | **Boxplot** - Units Sold by Price Tier |
| 📊 **Fig 5** | **Grouped Bar Chart** - Product Category Sales by Region |
| 📊 **Fig 6** | **Violin Plot** - Revenue Distribution Across Regions |
| 📊 **Fig 7** | **Boxplot** - Monthly Revenue Distribution |
| 📊 **Fig 8** | **Heatmap** - Monthly Sales by Region |
| 📊 **Fig 9** | **Scatter Plot** - Retail Price vs. Units Sold |
| 📊 **Fig 10** | **Bar Plot** - Units Sold by Month |
| 📊 **Fig 11** | **Scatter Plot** - Online Sales % vs. Units Sold |
| 📊 **Fig 12** | **Faceted Scatter Plot** - Online Sales % vs. Units Sold by Region |
| 📊 **Fig 13–15** | **Histogram**, **Q-Q Plot**, and **Shapiro-Wilk Test** - Normality Check of Units Sold |

---

## 📈 Statistical Testing & Results

### ✅ Price Tier Impact – ANOVA
- 🔬 **Result**: No significant difference in sales volume across Budget, Mid-Range, and Premium.
- 📌 **Business Insight**: Price alone isn’t a driver; emphasize perceived value and bundling.

### ✅ Product Category by Region – Chi-Square Test
- 🔬 **Result**: No significant difference; Nike’s global branding is consistent.
- 📌 **Strategy**: Standardized marketing works, but local tweaks (e.g., athlete endorsements) could enhance results.

### ✅ Regional Revenue Patterns – Kruskal-Wallis
- 🔬 **Result**: No significant variation in overall regional revenue.
- 📌 **Strategy**: Focus on micro-segmentation or market-specific campaigns for improved traction.

---

## 📆 Seasonality Analysis

### ✅ Global Sales Patterns – Kruskal-Wallis
- 🔬 **Result**: No statistically significant global seasonal effect.

### ✅ Region-Level Seasonality Tests
| Region        | Seasonality (p-value) | Interpretation                        |
|---------------|------------------------|----------------------------------------|
| Europe        | 0.009                  | Significant seasonal effects (Summer dip) |
| Southeast Asia| 0.0757                 | Marginal seasonal trends               |
| Others        | > 0.05                 | Sales stable across seasons            |

### 📊 Seasonal Visualizations

| Figure | Description |
|--------|-------------|
| 📊 **Fig 19** | Kruskal-Wallis Rank Sum Test |
| 📊 **Fig 20** | Regional Differences in Seasonality |
| 📊 **Fig 21** | Boxplot - Seasonal Revenue by Region |
| 📊 **Fig 22** | Bar Chart - Total Revenue by Season & Region |
| 📊 **Fig 23** | Bar Chart - Best Performing Season for Each Region |

---

## 🤖 Predictive Modeling

### ✅ Poisson GLM
- Two models were created:
  - 📍 **Internal Factors**: Retail Price, Price Tier, Product Line
  - 📍 **External Factors**: Month, Region, Online Sales %
- 🔍 Findings:
  - Premium tiers correlated with higher sales.
  - Online Sales % had a **negative** influence on total sales (possible cannibalization).
  - Regional and seasonal variations influence outcomes, notably in Europe and Southeast Asia.

### ✅ Regularization Models

| Model         | Goal                        | Result                                 |
|---------------|-----------------------------|----------------------------------------|
| **Ridge**     | Reduce multicollinearity    | Improved stability & RMSE (0.561)      |
| **LASSO**     | Feature selection           | Simplified model; many predictors dropped |
| **Linear**    | Baseline comparison         | RMSE: 0.597                            |

### 📊 Modeling Visuals

| Figure | Description |
|--------|-------------|
| 📊 **Fig 24** | GLM for Internal Factors |
| 📊 **Fig 25** | GLM for External Factors |
| 📊 **Fig 27** | Multiple Linear Regression Coefficients |
| 📊 **Fig 28** | Ridge Regression - Cross Validation Plot |
| 📊 **Fig 29** | LASSO Regression - Cross Validation Plot |
| 📊 **Fig 30** | Ridge Regression Coefficients |
| 📊 **Fig 31** | LASSO Regression Coefficients |
| 📊 **Fig 32** | RMSE Comparison – Linear vs Ridge vs LASSO |

---

## 💡 Key Business Takeaways

- **Pricing Strategy**: Focus on **value perception**, **bundling**, and **dynamic pricing** over static discounts.
- **Online Sales Optimization**: Align omnichannel strategies to reduce internal competition.
- **Localized Campaigns**: Regions like Europe (Summer dip) and Greater China (Winter peaks) need tailored campaigns.
- **Forecasting Accuracy**: Ridge and LASSO outperform traditional models in predictive power and interpretability.

---

## 🗂️ Project Structure

```plaintext
nike-sales-performance-analysis/
├── README.md
│   # This file
│
├── data/
│   └── nike_sales_2024.csv
│   # Cleaned or sample dataset
│
├── scripts/
│   └── nike_sales_analysis.R
│   # R code with analysis, tests, and modeling
│
├── outputs/
│   └── visualizations/
│       ├── boxplot_units_by_price_tier.png
│       ├── grouped_bar_category_by_region.png
│       ├── violinplot_revenue_by_region.png
│       ├── boxplot_monthly_revenue.png
│       ├── heatmap_sales_by_region.png
│       ├── scatter_retail_price_vs_units_sold.png
│       ├── barplot_units_by_month.png
│       ├── scatter_online_sales_vs_units_sold.png
│       ├── faceted_scatter_online_sales_by_region.png
│       ├── histogram_units_sold.png
│       ├── qqplot_units_sold.png
│       ├── seasonal_boxplot_by_region.png
│       ├── barplot_total_revenue_by_season_region.png
│       ├── bar_best_season_by_region.png
│       ├── ridge_cv_plot.png
│       ├── lasso_cv_plot.png│
└── report/
    └── Nike_Sales_Performance_Analysis_Report.pdf
    # Final PDF report with all results and interpretations
