delimiter $$
create trigger check_phone_employee_insert before insert on phone_number_employee
for each row
begin
    if exists (select phone from phone_number_employee where phone = new.phone) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'An employee already has that phone number';
    elseif exists(select phone from phone_number_client where phone = new.phone) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A client already has that phone number';
    end if;
end$$
delimiter ;

delimiter $$
create trigger check_phone_employee_update before update on phone_number_employee
for each row
begin
    if exists (select phone from phone_number_employee where phone = new.phone) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'An employee already has that phone number';
    elseif exists(select phone from phone_number_client where phone = new.phone) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A client already has that phone number';
    end if;
end$$
delimiter ;

delimiter $$
create trigger check_phone_client_insert before insert on phone_number_client
for each row
begin
    if exists (select phone from phone_number_client where phone = new.phone) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A client already has that phone number';
    elseif exists(select phone from phone_number_employee where phone = new.phone) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'An employee already has that phone number';
    end if;
end$$
delimiter ;

delimiter $$
create trigger check_phone_client_update before update on phone_number_client
for each row
begin
    if exists (select phone from phone_number_client where phone = new.phone) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A client already has that phone number';
    elseif exists(select phone from phone_number_employee where phone = new.phone) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'An employee already has that phone number';
    end if;
end$$
delimiter ;
