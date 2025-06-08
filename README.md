# Amazon-Sales-Data-SQL-Project
The aim of this project is to gain insight into the sales data of Amazon to understand the different factors that affect sales of the different branches.
Dataset Overview: This dataset contains sales transactions from three different branches of Amazon, respectively located in Mandalay, Yangon and Naypyitaw. The data contains 17 columns and 1000 rows.
Tools Used: Excel, SQL
# 📂 Project Structure

- **Database Creation:** Creation of the `AmazonSales` table with appropriate data types.
- **Data Insertion:** Insertion of transactional sales data into the table.
- **Data Transformation:**
  - Derived columns like `timeofday` (morning, afternoon, evening),
  - Extracted `dayname`, `monthname` from timestamps.
- **Business Questions:** A series of SQL queries answering 10+ business questions to analyze sales performance.

## 🧮 Key SQL Concepts Used

- `CASE` statements
- `EXTRACT`, `TO_CHAR` for date/time manipulation
- Aggregation functions: `SUM()`, `COUNT()`, `AVG()`
- Grouping: `GROUP BY`, `ORDER BY`
- Filtering: `WHERE`, `HAVING`
- Window functions (if applicable)
- CTEs and subqueries for layered logic

## 📊 Business Questions Answered

- What is the best month for sales and how much was earned?
- Which city had the highest number of sales?
- What time of day do customers buy more products?
- Which payment method is most commonly used?
- What is the average rating for each product line?
- Which product line had the most total revenue?
- What is the gender-wise spending pattern?
- Which branch is performing the best in terms of revenue?
- ...and more

## 💡 Insights Gained

- **Evening** is the peak time for customer purchases.
- **Electronic Accessories** was the highest-grossing product line.
- **City C** consistently performs better in terms of total sales.
- Majority of customers prefer **Ewallets** over credit cards.
- Male and female customers show similar spending behavior.
