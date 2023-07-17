--------------------------------------------------------
--  DDL for Procedure USER_GUIDE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ADMIN"."USER_GUIDE" 
AS
    BEGIN
        dbms_output.put_line('****WELCOME TO Stock Management System****');
        dbms_output.put_line('PLEASE REGISTER TO CONTINUE');
        dbms_output.put_line('EXECUTE THE BELOW PROCEDURE WITH THE SPECIFIED PARAMETERS IN AN ANONYMOUS PL/SQL BLOCK AS FOLLOWS');

        dbms_output.put_line('REGISTER(NAME,EMAIL,PASSWORD,LOCATION)');
        dbms_output.put_line('-------------------------------------------------------------------');
        dbms_output.put_line('AVAILABLE LOCATIONS ARE: ');
        dbms_output.put_line('CITY                 STATE');
           FOR LOC IN 
          (
            SELECT ADDR_COUNTRYNAME,ADDR_PROVINCE FROM ADDRESS
          )
          LOOP
            dbms_output.put_line(LOC.ADDR_COUNTRYNAME || '   -----------   '    || LOC.ADDR_PROVINCE);
          END LOOP;

        dbms_output.put_line('USERNAME WILL BE DISPLAYED ON THE SCREEN AFTER REGISTRATION.');

END USER_GUIDE;

/
