create or replace trigger workingtime
 before insert or update or delete on COMPANY
declare
 -- local variables here
begin
  --dbms_output.put_line('week: ' || to_char(sysdate, 'day'));
  dbms_output.put_line('time: ' || to_number(to_char(sysdate, 'hh24')));

 --if to_char(sysdate, 'day') in ('Saturday', 'Sunday') or
 --to_number(to_char(sysdate, 'hh24')) not between 9 and 17 then
 --forbidden insert
 if to_number(to_char(sysdate, 'hh24')) not between 7 and 24 then
    raise_application_error(-20001,'It is forbidden to change data during non working hours');
 end if;
end workingtime;

