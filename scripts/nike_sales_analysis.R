# ALY6015 Group Beta Final Project
# install packages
# install.packages(c("dplyr","ggplot2","stats","caret","glmnet")

# Load necessary libraries
library(dplyr)
library(ggplot2)
library(stats)
library(caret)
library(glmnet) 
library(purrr) 

# Load the dataset
nike_sales <- read.csv(file.choose(), sep = ",", header = TRUE, stringsAsFactors = FALSE)

# EDA
# Basic dataset structure
str(nike_sales)
# Check for missing values
colSums(is.na(nike_sales))
# Summary statistics for numerical variables
summary(nike_sales)

# Convert categorical variables into factors
nike_sales$Region <- as.factor(nike_sales$Region)
nike_sales$Main_Category <- as.factor(nike_sales$Main_Category)
nike_sales$Price_Tier <- as.factor(nike_sales$Price_Tier)
nike_sales$Product_Line <- as.factor(nike_sales$Product_Line)

# Convert Month into an ordered factor
nike_sales$Month <- factor(nike_sales$Month, 
                           levels = c("January", "February", "March", "April", 
                                      "May", "June", "July", "August", 
                                      "September", "October", "November", "December"),
                           ordered = TRUE)

# Boxplot: Units Sold by Price Tier
ggplot(nike_sales, aes(x = Price_Tier, y = Units_Sold)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  labs(title = "Effect of Price Tier on Units Sold", x = "Price Tier", y = "Units Sold") +
  theme_minimal()

# Barplot: Product Category Sales Across Regions
ggplot(nike_sales, aes(x = Region, fill = Main_Category)) +
  geom_bar(position = "dodge") +  # "dodge" places bars side-by-side
  labs(title = "Product Category Sales Across Regions",
       x = "Region",
       y = "Count",
       fill = "Product Category") +
  theme_minimal()

# Violin Plot for Revenue Distribution by Region
ggplot(nike_sales, aes(x = Region, y = Revenue_USD, fill = Region)) +
  geom_violin(alpha = 0.7, trim = FALSE) +  
  geom_boxplot(width = 0.2, fill = "white", alpha = 0.5) +  
  labs(title = "Revenue Distribution Across Regions (Violin Plot)",
       x = "Region", y = "Revenue (USD)") +
  theme_minimal() +
  theme(legend.position = "none")

# Boxplot: Revenue by Month
ggplot(nike_sales, aes(x = Month, y = Revenue_USD)) +
  geom_boxplot(fill = "lightblue", color = "black") +
  labs(title = "Distribution of Sales Across Months",
       x = "Month",
       y = "Revenue (USD)") +
  theme_minimal()

# heat map: Seasonal Sales Trends by Region
ggplot(nike_sales, aes(x = Month, y = Region, fill = Revenue_USD)) +
  geom_tile(color = "white") +
  scale_fill_gradientn(colors = c("blue", "lightblue", "white", "orange", "red"), 
                       name = "Revenue (USD)") +  # Blue for low, Red for high revenue
  labs(title = "Seasonal Sales Heatmap", x = "Month", y = "Region") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank()) 

# Scatter plot: Retail Price vs Units Sold
ggplot(nike_sales, aes(x = Retail_Price, y = Units_Sold)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Retail Price vs. Units Sold",
       x = "Retail Price",
       y = "Units Sold") +
  theme_minimal()

# Bar plot: Units Sold by Month
# Define custom colors based on your chart
month_colors <- c("December" = "brown3",  
                  "February" = "#558B2F",
                  "September" = "#984EA3", 
                  "June" = "#377F5C",  
                  "May" = "#377EB8",      
                  "July" = "#F781BF",  
                  "October" = "#D95F02",   
                  "January" = "#E69F00",  
                  "November" = "#4A7EBB", 
                  "August" = "#4DAF4A",
                  "March" = "#FB4D8C", 
                  "April" = "#56B4E9")   

ggplot(nike_sales, aes(x = reorder(Month, -Units_Sold, FUN = sum), y = Units_Sold, fill = Month)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = month_colors) +
  labs(title = "Units Sold by Month (Descending Order)", x = "Month", y = "Units Sold") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none")

# Scatter plot: Scatter plot: Online sales percentage vs Units Sold
ggplot(nike_sales, aes(x = Online_Sales_Percentage, y = Units_Sold)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "blue") +
  labs(title = "Online Sales Percentage vs. Units Sold",
       x = "Online Sales Percentage",
       y = "Units Sold") +
  theme_minimal()

# Scatter plot with faceting by Region
ggplot(nike_sales, aes(x = Online_Sales_Percentage, y = Units_Sold)) +
  geom_point(alpha = 0.5, color = "blue") +
  geom_smooth(method = "lm", method.args = list(family = poisson(link = "log")), se = FALSE, color = "red") +
  facet_wrap(~ Region) +
  labs(title = "Effect of Online Sales Percentage on Units Sold by Region", 
       x = "Online Sales Percentage (%)", y = "Units Sold") +
  theme_minimal()

# Check the normality of Unit Sold
# Plot histogram
ggplot(nike_sales, aes(x = Units_Sold)) +
  geom_histogram(bins = 30, fill = "dodgerblue2", color = "black", alpha = 0.7) +
  scale_x_continuous(breaks = seq(0, 50000, 5000)) + 
  labs(title = "Histogram of Units Sold", x = "Units Sold", y = "Frequency") +
  theme_minimal() 
# Q-Q plot
qqnorm(nike_sales$Units_Sold, main = "Q-Q Plot of Units Sold")
# Add reference line
qqline(nike_sales$Units_Sold, col = "red", lwd = 2)
# Shapiro-Wilk test
shapiro_test <- shapiro.test(nike_sales$Units_Sold)
print(shapiro_test)


# Analysis
# 1.Do different price tiers significantly impact sales volume?
# Perform ANOVA test
anova_result <- aov(Units_Sold ~ Price_Tier, data = nike_sales)
summary(anova_result)

# 2.Are there significant differences in product category performance across regions?
# Create a contingency table
table_data <- table(nike_sales$Region, nike_sales$Main_Category)
# Perform Chi-square test
chi_result <- chisq.test(table_data)
chi_result

# 3.Do different regions show statistically different sales patterns?
# Performing the Kruskal-Wallis Test
kruskal_test <- kruskal.test(Revenue_USD ~ Region, data = nike_sales)
# Kruskal-Wallis test is a non-parametric alternative to ANOVA.
# It determines if at least one region has a significantly different revenue distribution.
print(kruskal_test)  # Display test results

# If Kruskal-Wallis Test is Significant, Perform Pairwise Comparisons
if (kruskal_test$p.value < 0.05) {  
  # If p-value < 0.05, it indicates significant differences exist between at least two regions.
  
  pairwise_wilcox <- pairwise.wilcox.test(nike_sales$Revenue_USD, nike_sales$Region, p.adjust.method = "bonferroni")
  # Wilcoxon rank-sum test is applied pairwise to compare individual regions.
  # Bonferroni adjustment is used to control for multiple comparisons.
  
  print(pairwise_wilcox)  # Display pairwise test results
}

# 4. How does seasonality influence sales, and are the effects consistent across regions?
# Ensure "Month" column is correctly formatted
nike_sales$Month <- as.factor(nike_sales$Month)  # Convert to categorical factor
# Assign Seasons Based on Month
nike_sales <- nike_sales %>%
  mutate(Season = case_when(
    Month %in% c("December", "January", "February") ~ "Winter",
    Month %in% c("March", "April", "May") ~ "Spring",
    Month %in% c("June", "July", "August") ~ "Summer",
    Month %in% c("September", "October", "November") ~ "Fall"
  ))
# Convert Season to Ordered Factor
nike_sales$Season <- factor(nike_sales$Season, levels = c("Winter", "Spring", "Summer", "Fall"))
# Aggregate Revenue by Season & Region
seasonal_sales <- nike_sales %>%
  group_by(Season, Region) %>%
  summarise(Total_Revenue = sum(Revenue_USD, na.rm = TRUE)) %>%
  ungroup()

# Kruskal-Wallis Test: Does Season Affect Sales?
kruskal_season <- kruskal.test(Revenue_USD ~ Season, data = nike_sales)
# Print test results
print(kruskal_season)

# Kruskal-Wallis Test: Seasonality Across Regions
# Perform Kruskal-Wallis test for seasonality within each region
kruskal_region_season <- nike_sales %>%
  group_by(Region) %>%
  summarise(KW_Test = list(kruskal.test(Revenue_USD ~ Season, data = pick(everything()))), .groups = "drop") %>%
  mutate(Statistic = map_dbl(KW_Test, ~ .x$statistic),
         P_Value = map_dbl(KW_Test, ~ .x$p.value)) %>%
  select(Region, Statistic, P_Value)
# Print test results in a readable format
print(kruskal_region_season)

# Visualization
# Define custom colors for each season
season_colors <- c("Winter" = "lightblue", 
                   "Spring" = "palegreen3", 
                   "Summer" = "khaki1", 
                   "Fall" = "lightsalmon")
# Boxplot of Revenue Across Seasons and Regions
ggplot(nike_sales, aes(x = Season, y = Revenue_USD, fill = Season)) +
  geom_boxplot(outlier.colour = "red", outlier.shape = 16, alpha = 0.6) +
  facet_wrap(~ Region) +  # Separate by region
  scale_fill_manual(values = season_colors) +
  labs(title = "Seasonal Revenue Distribution Across Regions",
       x = "Season", y = "Revenue (USD)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none")

# Aggregate total revenue by season and region
seasonal_revenue <- nike_sales %>%
  group_by(Season, Region) %>%
  summarise(Total_Revenue = sum(Revenue_USD, na.rm = TRUE), .groups = "drop")
# Bar chart of total revenue by season per region
ggplot(seasonal_revenue, aes(x = Season, y = Total_Revenue, fill = Season)) +
  geom_col(position = "dodge") +
  facet_wrap(~ Region) +
  scale_fill_manual(values = season_colors) +
  labs(title = "Total Revenue by Season for Each Region",
       x = "Season", y = "Total Revenue (USD)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Identify the Highest Sales Season for Each Region
highest_sales_season <- seasonal_sales %>%
  group_by(Region) %>%
  filter(Total_Revenue == max(Total_Revenue)) %>%
  ungroup()
# Bar plot of highest-revenue season per region
ggplot(highest_sales_season, aes(x = Region, y = Total_Revenue, fill = Season)) +
  geom_col() +
  labs(title = "Best Performing Season for Each Region",
       x = "Region", y = "Total Revenue (USD)") +
  scale_fill_manual(values = season_colors) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 5. Key Predictors of Nike’s Sales Performance
# Generalized GLM to assess impact of internal factors and external factors
# GLM for internal factors
glm_internal <- glm(Units_Sold ~ Retail_Price + Price_Tier + Product_Line,
                 family = poisson(link = "log"), data = nike_sales)
# Summary of the GLM Internal
summary(glm_internal)

# Set the baseline for Month to January
# Convert Month to an unordered factor first, then relevel
nike_sales$Month <- factor(nike_sales$Month, ordered = FALSE) 
nike_sales$Month <- relevel(nike_sales$Month, ref = "January")
# GLM for external factors
glm_external <- glm(Units_Sold ~ Month + Region + Online_Sales_Percentage, 
                    family = poisson(link = "log"), data = nike_sales)
# Summary of the GLM External
summary(glm_external)

# 6. Multiple Linear Regression Model with Regularization for Sales Prediction
# Multiple linear regression model
# Log-transform Units_Sold to normalize distribution (optional but recommended)
# Avoid log(0)
nike_sales$log_Units_Sold <- log(nike_sales$Units_Sold + 1)  

# Define predictor variables and response variable
x <- nike_sales %>% select(Retail_Price, Online_Sales_Percentage, Region, Main_Category, Price_Tier, Product_Line)
y <- nike_sales$log_Units_Sold 

# Convert categorical variables to dummy variables for regression
x <- model.matrix(~ ., data = x)[, -1] 

# Standardize numerical predictors (for ridge/LASSO)
x_scaled <- scale(x)

# Split data into training and testing sets
set.seed(123)
# Get 70% of random row numbers
dt = sample(nrow(nike_sales), nrow(nike_sales)* 0.7)
x_train <- x_scaled[dt, ]
x_test <- x_scaled[-dt, ]
y_train <- y[dt]
y_test <- y[-dt]

# Build Multiple Linear Regression Model
lm_model <- lm(y_train ~ ., data = as.data.frame(cbind(y_train, x_train)))
summary(lm_model)

# Apply Ridge and LASSO Regression
x_train_matrix <- as.matrix(x_train)
x_test_matrix <- as.matrix(x_test)

# Ridge Regression (alpha = 0)
ridge_model <- cv.glmnet(x_train_matrix, y_train, alpha = 0,nfolds = 10)
best_lambda_ridge <- ridge_model$lambda.min
ridge_pred <- predict(ridge_model, s = best_lambda_ridge, newx = x_test_matrix)
# Display the optimize value of lambda
log(ridge_model$lambda.min)
log(ridge_model$lambda.1se)
# Plot the results from the Ridge model
plot(ridge_model)

# LASSO Regression (alpha = 1)
lasso_model <- cv.glmnet(x_train_matrix, y_train, alpha = 1,nfolds = 10)
best_lambda_lasso <- lasso_model$lambda.min
lasso_pred <- predict(lasso_model, s = best_lambda_lasso, newx = x_test_matrix)
# Display the optimize value of lambda
log(lasso_model$lambda.min)
log(lasso_model$lambda.1se)
# Plot the results from the LASSO model
plot(lasso_model)

# Compare Model Performance
ridge_rmse <- RMSE(ridge_pred, y_test)
lasso_rmse <- RMSE(lasso_pred, y_test)
lm_rmse <- RMSE(predict(lm_model, newdata = as.data.frame(x_test)), y_test)

print(paste("Linear Model RMSE:", round(lm_rmse, 3)))
print(paste("Ridge Regression RMSE:", round(ridge_rmse, 3)))
print(paste("LASSO Regression RMSE:", round(lasso_rmse, 3)))

# Identify Important Features from LASSO
lasso_coefficients <- coef(lasso_model, s = best_lambda_lasso)
print(lasso_coefficients)

# Identify Important Features from Ridge
ridge_coefficients <- coef(ridge_model, s = ridge_model$lambda.min)
print(ridge_coefficients)
