SELECT * FROM COMPANY;
SELECT * FROM SECURITYTYPE;
SELECT * FROM STOCKEXCHANGE;
SELECT * FROM COMPANYSECURITY;
DESC securitytype;
SET SERVEROUTPUT ON;
CREATE OR REPLACE procedure companyregister (COMPANY_IDI IN NUMBER, COMPANY_NAMEI IN VARCHAR2, CONTACTI IN NUMBER)
AS
CONTACTNO number;
COMPANYNAME varchar2(100);
COMAPNYID number(10);
P_SECTYPE VARCHAR2(20);
e_invalid_CONTACT EXCEPTION;
BEGIN
SELECT LENGTH(CONTACTI) INTO CONTACTNO FROM DUAL;
IF
(CONTACTNO<10 AND CONTACTNO>10)
THEN
RAISE
e_invalid_CONTACT;
END IF;

INSERT INTO COMPANY(COMPANY_ID,COMPANY_NAME,COMPANY_CONTACT) VALUES(COMPANY_IDI,COMPANY_NAMEI,CONTACTI);
COMMIT;

dbms_output.put_line('Company Registration Complete');
dbms_output.put_line('Companyname is ' || COMPANY_NAMEI);
dbms_output.put_line('*********************************************************************************');
dbms_output.put_line('Kindly complete your company setup by providing additional details for your company');
dbms_output.put_line('');

dbms_output.put_line('*********************************************************************************');
dbms_output.put_line('Choose from below list ');
FOR SECTYPE IN 
          (
            SELECT SECURITY_TYPE , SECURITYTYPE_DESC  FROM securitytype 
          )
          LOOP
            dbms_output.put_line(SECTYPE.SECURITY_TYPE || '   -----------   '    || SECTYPE.SECURITYTYPE_DESC);
          END LOOP;
          
    dbms_output.put_line('***********************************************');
dbms_output.put_line('Choose THE STOCK EXCHANGE FROM BELOW ');
dbms_output.put_line('---------------------------------------------------------');
FOR EXCHANGE IN 
          (
            SELECT EXCHANGE_ID , EXCHANGE_NAME  FROM stockexchange 
          )
          LOOP
            dbms_output.put_line(EXCHANGE.EXCHANGE_ID || '   -----------   '    || EXCHANGE.EXCHANGE_NAME);
          END LOOP;         

dbms_output.put_line('Please execute the below SP in an anonymous block');
dbms_output.put_line('ADD_SECURITY(''<COMPANYNAME>'',''<SECURITYTYPE>'',''<EXCHANGE>'')');     

EXCEPTION
WHEN 
e_invalid_CONTACT THEN
dbms_output.put_line('Length of contact is more thanor less than 10');
END;
/

INSERT INTO COMPANY(COMPANY_ID,COMPANY_NAME,company_contact) VALUES(18970,'GOOGLE1',8765425678);
select * from company;
insert into company(company_name,company_contact) values ('alpha',0000000000);
EXEC companyregister(9000,'RAYTHEON',00000000000);


