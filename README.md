# Retail Business Performance Analysis Using SQL

A beginner-friendly SQL project that analyzes retail sales, customer behavior, product performance, and employee productivity using core SQL concepts.

## Project Overview
This project uses a relational retail database to answer business questions about customers, orders, products, and sales staff. It covers queries from basic joins to advanced window functions.

## Objectives
- Combine data from multiple tables using joins
- Answer layered business questions using subqueries and CTEs
- Rank, compare, and track trends using window functions

## Database Schema
| Table | Description | Rows |
|---|---|---|
| `customers` | Customer name, city, join date | 8 |
| `products` | Product name, category, price | 8 |
| `orders` | Order date, customer, employee | 8 |
| `orderdetails` | Products and quantities in each order | 9 |
| `employee` | Employee name, department, hire date | 4 |

**Relationships:** `orders` links to `customers` and `employee`; `orderdetails` links `orders` to `products`.

## SQL Concepts Covered
| Section | Topics |
|---|---|
| Joins | INNER JOIN, LEFT JOIN, multi-table joins, GROUP BY |
| Subqueries | IN, scalar subqueries, comparison with averages |
| CTEs | Total sales per order, customer spending, category revenue, top customers |
| Window Functions | RANK, DENSE_RANK, ROW_NUMBER, cumulative SUM, PARTITION BY |

## Sample Business Questions Answered
- Which customers spent more than ₹20,000?
- What is the total revenue by product category?
- Who are the top 3 customers by spending?
- Which employee handled the most orders?
- What is the highest-priced product in each category?
- What is the cumulative sales amount by order date?

## Key Findings
- Total sales revenue in the dataset is **₹1,98,500**
- **Electronics** generates about 94% of revenue
- Top customers are **Amit Sharma (₹59,000)** and **Pooja Gupta (₹55,000)**
- **Rajesh Kumar** handled the most orders (3)
- Each customer placed exactly one order in this sample dataset

## Tools Used
- MySQL (MySQL Workbench)
- Excel (source data)

## Repository Structure

├── sql/    # SQL script with all queries
├── data/   # Dataset (Excel)
├── docs/   # Project brief
└── README.md


## How to Run
1. Open MySQL Workbench
2. Run the `CREATE TABLE` statements at the top of `sql/retail_business_performance_analysis.sql`
3. Import the data from `data/retail_business_dataset.xlsx` into each table
4. Run the queries section by section

## Author
**Prashanth Udidi**
Data Analytics | SQL | Power BI | Excel | Python
[LinkedIn](https://www.linkedin.com/in/your-profile) • [GitHub](https://github.com/udidiprashanth-alt)
