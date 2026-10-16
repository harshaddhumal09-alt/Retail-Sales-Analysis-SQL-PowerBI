# Retail Sales & Profitability Analysis (SQL + Power BI)

End-to-end analysis of 4 years of retail orders (2015-2018). Data was cleaned and analysed in **MySQL**, then visualised in an interactive **Power BI** dashboard.

## Dashboard
![Dashboard](dashboard.png)

## Tools Used
- MySQL (data cleaning, analysis queries)
- Power BI (DAX, dashboard)
- Excel / CSV (source data)

## Steps
1. Imported the orders data into MySQL
2. Converted text dates to DATE format using `STR_TO_DATE`
3. Checked NULL values and removed 1 exact duplicate row (9,682 rows remained)
4. Wrote SQL queries for KPIs, category, sub-category, discount and monthly trend analysis
5. Exported clean data and built the Power BI dashboard with a region slicer

## Key Numbers
- Total Sales: $2.26M
- Total Profit: $280.6K (about 12.4% margin)
- Total Orders: 4,925
- Total Customers: 793

## Key Insights
- **Furniture has the lowest margin (2.17%)** even though its sales are higher than Office Supplies. Technology (17.37%) and Office Supplies (17.09%) are much healthier.
- **Tables (-$17.7K) and Bookcases (-$4.5K) make a loss** and have the highest average discounts (26% and 21%).
- **Discounts above 20% cause losses.** Orders with 21-40% discount lost $35.8K and 40%+ lost $98.3K, a combined loss of about $134K. Orders with no discount made $314.9K profit.
- **Sales grew about 50%** from 2015 to 2018, with peaks in September, November and December every year.

## Files
- `retail_analysis.sql` - all SQL queries
- `orders_clean.csv` - cleaned data
- `Retail Sales Dashboard.pbix` - Power BI file
- `dashboard.png` - dashboard screenshot
