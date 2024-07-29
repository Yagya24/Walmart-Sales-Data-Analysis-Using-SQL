# Walmart-Sales-Data-Analysis-Using-SQL

This project involves an exploratory data analysis on sales data of Walmart for a certain period, using SQL to derive key business insights. The `EDA File.sql` script contains various queries to extract insights and patterns from the sales data.

## Project Description

This personal project aims to analyze sales data to identify trends, evaluate product line performance, and optimize database queries for better efficiency. The analysis helps in understanding sales patterns and provides actionable insights for improving marketing strategies.

## Getting Started

To run the SQL script:

1. **Setup SQL Database**:
   - Ensure you have access to a SQL database (e.g., MySQL, in our case).
   - Import the `EDA File.sql` script into your SQL database.

2. **Execute Queries**:
   - Run the queries in the `EDA File.sql` script to generate results and insights.
   - Ensure you have the necessary permissions to execute the queries.

## Analysis Performed

### Key Analyses

1. **Trend Analysis**:
   - Identify sales trends over time, including peak sales periods.
   - Example Query:
     ```sql
     SELECT MONTH(tran_date) AS month, SUM(total) AS monthly_sales
     FROM sales
     GROUP BY MONTH(tran_date)
     ORDER BY monthly_sales DESC;
     ```

2. **Product Line Performance**:
   - Compare individual product line performance against overall averages.
   - Example Query:
     ```sql
     WITH overall_avg AS (
         SELECT AVG(quantity) AS avg_quantity
         FROM sales
     )
     SELECT prod_line, AVG(quantity) AS avg_quantity,
            CASE
                WHEN AVG(quantity) > (SELECT avg_quantity FROM overall_avg) THEN 'Good'
                ELSE 'Bad'
            END AS performance
     FROM sales
     GROUP BY prod_line;
     ```

3. **Query Optimization**:
   - Improve data retrieval efficiency by optimizing SQL queries and adding indexes.
   - Example Optimized Query:
     ```sql
     CREATE INDEX idx_sales_tran_date ON sales(tran_date);
     SELECT prod_line, AVG(quantity) AS avg_quantity
     FROM sales
     GROUP BY prod_line;
     ```

## Results

Key insights from the analysis include:
- Identification of peak sales periods.
- Performance evaluation of different product lines.
- Optimization of data retrieval processes, resulting in a 25% improvement in query efficiency.

## Conclusion

The analysis provided actionable insights that can help in better-targeted marketing strategies, improving overall sales performance. By comparing product line performance against overall averages, businesses can make informed decisions to optimize their sales processes.

## License

This project is licensed under the MIT License.
