--- company overall stock holdings at the end of the day---
----- customer transaction history weekly/quaterly---



-- customer holdings--
SELECT C.Cust_Name, com.company_name, CH.qty
FROM Customer C
JOIN CustomerHolding CH
ON C.Cust_Id = CH.CustomerID
JOIN Company Com
ON CH.CompanyId = Com.Company_Id;

---company stock holdings by year--
SELECT COM.COMPANY_NAME, EXTRACT(YEAR FROM INF.AS_OF_DATE) "YEAR", SUM(INF.STOCK_QTY_AVAILABLE) "qUANTITY"
FROM COMPANY COM
JOIN COMPANYSECURITY S
ON COM.COMPANY_ID = S.COMPANY_ID
JOIN STOCKINFO INF
ON S.STOCK_ID = INF.STOCK_ID
GROUP BY EXTRACT(YEAR FROM INF.AS_OF_DATE), COM.COMPANY_NAME;
