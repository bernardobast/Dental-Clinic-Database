DELIMITER $$
create function no_shows(gender varchar(20), year_ int, upper_age int, lower_age int)
returns int

begin

declare no_shows int;

select count(*) into no_shows from (
select a.VAT_doctor, a.date_timestamp, a.VAT_client from appointment as a, client as cl
where not exists (select VAT_doctor, date_timestamp
from consultation as c where c.VAT_doctor = a.VAT_doctor and c.date_timestamp = a.date_timestamp)
and extract(year from a.date_timestamp) = year_ 
and a.VAT_client = cl.VAT
and cl.gender = gender
and cl.age > lower_age and cl.age < upper_age
group by a.VAT_doctor, a.date_timestamp) as x;

return no_shows;

end$$
DELIMITER ;