delimiter $$
create trigger check_doctor_nurse_recep_insert before insert on doctor
for each row
begin
    if exists (select new.VAT from nurse where new.VAT = nurse.VAT) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert doctor if is a nurse';
    elseif exists (select new.VAT from receptionist where new.VAT = receptionist.VAT) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert doctor if is a receptionist';
    end if;
end$$
delimiter ;

delimiter $$
create trigger check_doctor_nurse_recep_update before update on doctor
for each row
begin
    if exists (select new.VAT from nurse where new.VAT = nurse.VAT) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update doctor if is a nurse';
    elseif exists (select new.VAT from receptionist where new.VAT = receptionist.VAT) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update doctor if is a receptionist';
    end if;
end$$
delimiter ;

delimiter $$
create trigger check_nurse_doctor_insert before insert on nurse
for each row
begin
    if exists (select new.VAT from doctor where new.VAT = doctor.VAT) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert nurse if is a doctor';
    end if;
end$$
delimiter ;

delimiter $$
create trigger check_nurse_doctor_update before update on nurse
for each row
begin
    if exists (select new.VAT from doctor where new.VAT = doctor.VAT) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update nurse if is a doctor';
    end if;
end$$
delimiter ;

delimiter $$
create trigger check_receptionist_doctor_insert before insert on receptionist
for each row
begin
    if exists (select new.VAT from doctor where new.VAT = doctor.VAT) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert receptionist if is a doctor';
    end if;
end$$
delimiter ;

delimiter $$
create trigger check_receptionist_doctor_update before update on receptionist
for each row
begin
    if exists (select new.VAT from doctor where new.VAT = doctor.VAT) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update receptionist if is a doctor';
    end if;
end$$
delimiter ;

delimiter $$
create trigger check_permanent_doctor_insert before insert on permanent_doctor
for each row
begin
    if exists (select new.VAT from trainee_doctor where new.VAT = trainee_doctor.VAT) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert permamnet doctor if is a trainee doctor';
    end if;
end$$
delimiter ;

delimiter $$
create trigger check_permanent_doctor_update before update on permanent_doctor
for each row
begin
    if exists (select new.VAT from trainee_doctor where new.VAT = trainee_doctor.VAT) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update permamnet doctor if is a trainee doctor';
    end if;
end$$
delimiter ;

delimiter $$
create trigger check_trainee_doctor_insert before insert on trainee_doctor
for each row
begin
    if exists (select new.VAT from permanent_doctor where new.VAT = permanent_doctor.VAT) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert trainee doctor if is a permanent doctor';
    end if;
end$$
delimiter ;

delimiter $$
create trigger check_trainee_doctor_update before update on trainee_doctor
for each row
begin
    if exists (select new.VAT from permanent_doctor where new.VAT = permanent_doctor.VAT) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update trainee doctor if is a permanent doctor';
    end if;
end$$
delimiter ;