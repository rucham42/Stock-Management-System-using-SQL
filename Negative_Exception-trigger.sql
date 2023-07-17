create or replace trigger Negative_Exception
after update 
on STOCKINFO 
for each row 
begin
if(:new.MARKET_VAL<0 or :new.STOCK_QTY_AVAILABLE<0 ) then 
dbms_output.put_line('cannot be negative！');
raise_application_error(-20010,'Abnormal amount！！！');
rollback;
else
dbms_output.put_line('Modify  record');
end if;
end;