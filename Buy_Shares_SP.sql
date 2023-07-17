--------------------------------------------------------
--  DDL for Procedure BUY_SHARES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ADMIN"."BUY_SHARES" (
SECDESC	IN companysecurity.sec_desc%TYPE,
IN_QTY IN TRANSACTION.qty%TYPE
)
AS
p_username VARCHAR2(20);
p_buyingpower NUMBER(10,2);
P_PRICE NUMBER(10);
max_ID NUMBER(10);
p_totalprice NUMBER(10);
P_CUSTOMER_ID NUMBER(10);
P_STOCK_ID NUMBER(20);
e_LOW_BUYINGPOWER EXCEPTION;
e_invalid_qty EXCEPTION;
e_INVALID_TXN EXCEPTION;
p_txntype varchar2(5);
p_stock_avail number(10);
p_holding_id number(10);
p_count number(10);
p_index number(10,3);
p_newMkt number(10,3);
p_newQty number(10);
ERR NUMBER(10);
BEGIN


---------GET STOCK_ID--------------
ERR:=1;
SELECT SECURITY_ID INTO P_STOCK_ID FROM COMPANYSECURITY WHERE UPPER(SEC_DESC)=UPPER(SECDESC);

----------------get customer username------------

SELECT USER into  p_username FROM DUAL;

SELECT CUST_ID INTO P_CUSTOMER_ID from CUSTOMER where UPPER(cust_username)=UPPER(p_username);

------GET STOCK AVAILABILITY------
select QTY_AVAIL into p_stock_avail from COMPANYSECURITY WHERE SECURITY_ID=P_STOCK_ID;

IF(p_stock_avail < IN_QTY)
THEN
RAISE e_invalid_qty;
END IF;

-----GET STOCK PRICE----------------------

SELECT market_val INTO P_PRICE from (
(SELECT stock_id,market_val, rank() over (partition by stock_id order by as_of_date desc) as rank from stockinfo
where  STOCK_ID=P_STOCK_ID) SI)
where SI.rank=1;


SELECT cust_buyingpower INTO p_buyingpower FROM CUSTOMER WHERE CUST_ID=P_CUSTOMER_ID;

--dbms_output.put_line(' STOCK       QUANTITY       PRICE');
------CHECKING BUYING POWER------------
p_totalprice:=IN_QTY*P_PRICE;
IF(p_buyingpower < p_totalprice)
THEN
RAISE e_LOW_BUYINGPOWER;
END IF;

-----GENERATING TRANSACTION ID-------
--SELECT (MAX(TXN_ID)+1) into max_ID from TRANSACTION;

--------INSERT INTO TRANSACTION----------
INSERT INTO TRANSACTION (TXN_ID, TXN_TYPE, CUSTOMER_ID, STOCK_ID, QTY,MARKET_VALUE,TXN_DATE)
    VALUES(seq_transaction.nextval,'BUY',P_CUSTOMER_ID,P_STOCK_ID,IN_QTY,P_PRICE,SYSTIMESTAMP);

    COMMIT;
     dbms_output.put_line('TRANSACTION SUCCESFUL');
 --- UPDATE BUYING POWER------
 UPDATE  CUSTOMER SET CUST_BUYINGPOWER=CUST_BUYINGPOWER-p_totalprice WHERE CUST_ID=P_CUSTOMER_ID;

 COMMIT;

 --UPDATE AVAILABLE STOCKS----
 UPDATE COMPANYSECURITY SET QTY_AVAIL=QTY_AVAIL - IN_QTY WHERE SECURITY_ID=P_STOCK_ID;

 COMMIT;


ERR:=2;

 SELECT HOLDINGID INTO p_holding_id FROM CUSTOMERHOLDING WHERE CUSTOMERID=P_CUSTOMER_ID AND 
 SECURITYID=P_STOCK_ID AND TO_DATE(ASOFDATE, 'DD/MM/YYYY')=TO_DATE(sysdate, 'DD/MM/YYYY');

 dbms_output.put_line('holding id id ' || p_holding_id);

 UPDATE CUSTOMERHOLDING SET QTY = QTY + IN_QTY  WHERE holdingid=p_holding_id;
 COMMIT;

SELECT QTY_AVAIL INTO p_newQty from companysecurity WHERE SECURITY_ID=P_STOCK_ID;

p_index:= P_PRICE / p_newQty;
p_newMkt:= P_PRICE + p_index;
 dbms_output.put_line('p_index is ' || p_index || '   p_new_mkt ' || p_newMkt);

ERR:=3;
select COUNT(1) INTO p_count from stockinfo WHERE STOCK_ID = P_STOCK_ID AND TO_DATE(AS_OF_DATE, 'DD/MM/YYYY')=TO_DATE(sysdate, 'DD/MM/YYYY');
IF(p_count = 0)
THEN
INSERT INTO STOCKINFO VALUES (P_STOCK_ID,TO_DATE(sysdate, 'DD/MM/YYYY'), p_newMkt);
COMMIT;

ELSE 
 dbms_output.put_line(' inside else : p_index is ' || p_index || '   p_new_mkt ' || p_newMkt);
    UPDATE STOCKINFO SET MARKET_VAL = p_newMkt 
    WHERE STOCK_ID = P_STOCK_ID AND 
    TO_DATE(AS_OF_DATE, 'DD/MM/YYYY')=TO_DATE(sysdate, 'DD/MM/YYYY');
    COMMIT;
END IF;






EXCEPTION
WHEN
NO_DATA_FOUND THEN
    IF ERR=1 THEN
    DBMS_OUTPUT.PUT_LINE('INVALID SHARE NAME ENTERED!');
    END IF;
    IF ERR=2 THEN
    INSERT INTO CUSTOMERHOLDING values(seq_holding.nextval,P_STOCK_ID,IN_QTY,P_CUSTOMER_ID,SYSDATE);
    COMMIT;
    END IF;


WHEN 
e_LOW_BUYINGPOWER THEN
dbms_output.put_line('NOT ENOUGH BUYING POWER');
dbms_output.put_line('ADD FUNDS BY EXECUTING: EXECUTE UPDATE_FUNDS(''ADD'',<amount>)');

WHEN
e_INVALID_TXN THEN
dbms_output.put_line('INVALID TRANSACTION TYPE ENTERED, PLEASE TRY AGAIN');

WHEN
e_invalid_qty THEN
dbms_output.put_line('REQUESTED QUANTITY OF SHARES IS NOT AVAILABLE, PLEASE TRY AGAIN');

END;

/

  GRANT EXECUTE ON "ADMIN"."BUY_SHARES" TO "DB_CUSTOMERS";
