--Liquor Sales:Measure
--1
SELECT SUM(Sale_Dollars) FROM [dbo].[fct_iowa_liquor_sales_invoice_lineitem] --3720271003.7700
--2
SELECT SUM(Volume_Sold_Gallons) FROM [dbo].[fct_iowa_liquor_sales_invoice_lineitem] --63275923.7300
--3
select SUM(CAST(Bottle_Volume_ml AS BIGINT)) from [dbo].[fct_iowa_liquor_sales_invoice_lineitem] --23210107417
--4
select SUM(State_Bottle_Retail-State_Bottle_Cost) as Gross_profit from [dbo].[fct_iowa_liquor_sales_invoice_lineitem]; 
--136113317.1500 
--5
SELECT Invoice_Number, SUM(Sale_Dollars) FROM [dbo].[fct_iowa_liquor_sales_invoice_lineitem] 
GRoup By Invoice_Number, Sale_Dollars -- 26160915 

--liquor sales by store
--1
SELECT S.Store_Name, SUM(L.Sale_Dollars) AS Total_Sales  FROM [dbo].[fct_iowa_liquor_sales_invoice_header] H
JOIN [dbo].[Dim_Iowa_Liquor_Stores] S ON S.Store_SK = H.Store_SK
JOIN [dbo].[fct_iowa_liquor_sales_invoice_lineitem] L ON L.Invoice_Item_Number= H.Invoice_Number
GROUP BY S.Store_Name --2265

--2
SELECT C.County, SUM(H.Invoice_Sale_Dollars) AS Total_Sales FROM [dbo].[Dim_Iowa_Liquor_Stores] S
JOIN [dbo].[Dim_iowa_county] C ON C.County_SK = S.County_SK
JOIN [dbo].[fct_iowa_liquor_sales_invoice_header] H ON H.Store_SK = S.Store_SK
GROUP BY C.County
order by Total_Sales desc--XXXXXXX

--3
SELECT C.City, SUM(H.Invoice_Sale_Dollars) AS Total_Sales FROM [dbo].[Dim_Iowa_Liquor_Stores] S
JOIN [dbo].[Dim_iowa_city] C ON C.City_SK= S.City_SK
JOIN [dbo].[fct_iowa_liquor_sales_invoice_header] H ON H.Store_SK = S.Store_SK
GROUP BY C.City 
order by Total_Sales desc

--4
SELECT C.Category_Name, sum(L.Sale_Dollars) as total_sales FROM [dbo].[Dim_iowa_liquor_Products] P 
JOIN [dbo].[fct_iowa_liquor_sales_invoice_lineitem] L ON L.Item_Number = cast(P.Item_Number as varchar(50))
JOIN [dbo].[Dim_iowa_liquor_Product_Categories] C ON C.Category_SK = P.Category_SK
GROUP BY C.Category_Name, L.Sale_Dollars
order by total_sales desc ---XXXXXXX

--5
SELECT SUM(Sale_Dollars) as total_sales, Invoice_Item_Number  FROM [dbo].[fct_iowa_liquor_sales_invoice_lineitem]
GROUP BY Invoice_Item_Number
order by total_sales desc

--6
SELECT V.Vendor_Name, sum(L.Sale_Dollars) as total_sales FROM [dbo].[Dim_iowa_liquor_Products] P
JOIN [dbo].[fct_iowa_liquor_sales_invoice_lineitem] L ON L.Item_Number = cast(P.Item_Number as varchar(50))
JOIN [dbo].[Dim_iowa_liquor_Vendors] V  ON P.Vendor_SK = V.Vendor_SK 
group by v.Vendor_Name
order by total_sales desc--XXXXXXX----

--Liquor sales by Time
--1
SELECT Invoice_Date, SUM(Invoice_Sale_Dollars) AS Total_Sales FROM [dbo].[fct_iowa_liquor_sales_invoice_header] 
GROUP BY Invoice_Date
--2
SELECT Year(Invoice_Date) AS Invoice_Year, SUM(Invoice_Sale_Dollars) AS Total_Sales 
FROM [dbo].[fct_iowa_liquor_sales_invoice_header]
GROUP  BY Year(Invoice_Date)

--select * from dbo.fct_iowa_liquor_sales_invoice_lineitem a, dbo.
--SELECT Year(Invoice_Date) FROM [dbo].[fct_iowa_liquor_sales_invoice_header]
--3
SELECT Year(Invoice_Date) AS Invoice_Year,Month(Invoice_Date) AS Invoice_Month, SUM(Invoice_Sale_Dollars) AS Total_Sales
FROM [dbo].[fct_iowa_liquor_sales_invoice_header] 
GROUP  BY Year(Invoice_Date), Month(Invoice_Date)
order by Total_Sales desc

--4
SELECT Year(Invoice_Date) AS Invoice_Year, SUM(Invoice_Sale_Dollars) AS Total_Sales, LAG(SUM(Invoice_Sale_Dollars)) 
OVER (ORDER BY Year(Invoice_Date)) AS Previous_Sales,  SUM(Invoice_Sale_Dollars) - (LAG(SUM(Invoice_Sale_Dollars)) 
OVER (ORDER BY Year(Invoice_Date))) AS YOY
FROM [dbo].[fct_iowa_liquor_sales_invoice_header]
GROUP  BY Year(Invoice_Date)





