delimiter $$
create trigger update_age after insert on appointment
for each row
begin
    update client
    set client.age = extract(year from (from_days(DATEDIFF(current_timestamp,client.birth_date))))
    where client.VAT = new.VAT_client;
end$$
delimiter ;