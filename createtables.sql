drop trigger if exists update_age;
drop trigger if exists check_doctor_nurse_recep_insert;
drop trigger if exists check_doctor_nurse_recep_update;
drop trigger if exists check_nurse_doctor_insert;
drop trigger if exists check_nurse_doctor_update;
drop trigger if exists check_receptionist_doctor_insert;
drop trigger if exists check_receptionist_doctor_update;
drop trigger if exists check_permanent_doctor_insert;
drop trigger if exists check_permanent_doctor_update;
drop trigger if exists check_trainee_doctor_insert;
drop trigger if exists check_trainee_doctor_update;
drop trigger if exists check_phone_employee_insert;
drop trigger if exists check_phone_employee_update;
drop trigger if exists check_phone_client_insert;
drop trigger if exists check_phone_client_update;

drop function if exists no_shows;
drop procedure if exists raise_doctor_salary;

drop view if exists dim_date;
drop view if exists dim_client;
drop view if exists dim_location_client;
drop view if exists facts_consults;

drop table if exists procedure_charting; 
drop table if exists teeth; 
drop table if exists procedure_radiology; 
drop table if exists procedure_in_consultation; 
drop table if exists procedure_; 
drop table if exists prescription; 
drop table if exists medication; 
drop table if exists consultation_diagnostic; 
drop table if exists diagnostic_code_relation; 
drop table if exists diagnostic_code; 
drop table if exists consultation_assistant; 
drop table if exists consultation; 
drop table if exists appointment; 
drop table if exists supervision_report; 
drop table if exists trainee_doctor; 
drop table if exists permanent_doctor; 
drop table if exists phone_number_client; 
drop table if exists client; 
drop table if exists nurse; 
drop table if exists doctor; 
drop table if exists receptionist; 
drop table if exists phone_number_employee; 
drop table if exists employee; 

/************CREATE TABLES***************************************************************************************************************************/

CREATE TABLE employee 
    (VAT INT NOT NULL UNIQUE, 
    name_ VARCHAR(255), 
    birth_date DATE, 
    street VARCHAR(255), 
    city VARCHAR(255), 
    zip VARCHAR(255), 
    IBAN VARCHAR(100) NOT NULL UNIQUE, 
    salary NUMERIC(20,2) NOT NULL CHECK (salary > 0), 
    PRIMARY KEY(VAT)); 
 

CREATE TABLE phone_number_employee 
    (VAT INT NOT NULL, 
    phone VARCHAR(15), 
    PRIMARY KEY(VAT, phone), 
    FOREIGN KEY(VAT) REFERENCES employee(VAT) ON DELETE CASCADE); 


CREATE TABLE receptionist 
    (VAT INT NOT NULL UNIQUE, 
    PRIMARY KEY(VAT), 
    FOREIGN KEY(VAT) REFERENCES employee(VAT) ON DELETE CASCADE); 
 

CREATE TABLE doctor 
    (VAT INT NOT NULL UNIQUE, 
    specialization VARCHAR(255), 
    biography VARCHAR(255), 
    email VARCHAR(255) NOT NULL UNIQUE, 
    PRIMARY KEY(VAT), 
    FOREIGN KEY(VAT) REFERENCES employee(VAT) ON DELETE CASCADE);


CREATE TABLE nurse 
    (VAT INT NOT NULL UNIQUE, 
    PRIMARY KEY(VAT), 
    FOREIGN KEY(VAT) REFERENCES employee(VAT) ON DELETE CASCADE); 
 

CREATE TABLE client 
    (VAT INT NOT NULL UNIQUE, 
    name_ VARCHAR(255), 
    birth_date DATE, 
    street VARCHAR(255), 
    city VARCHAR(255), 
    zip VARCHAR(255), 
    gender VARCHAR(20), 
    age INT NOT NULL CHECK (age > 0), 
    PRIMARY KEY(VAT)); 
 

CREATE TABLE phone_number_client 
    (VAT INT NOT NULL UNIQUE,  
    phone VARCHAR(15), 
    PRIMARY KEY(VAT, phone), 
    FOREIGN KEY(VAT) REFERENCES client(VAT) ON DELETE CASCADE); 
 

CREATE TABLE permanent_doctor 
    (VAT INT NOT NULL UNIQUE, 
    years INT, 
    PRIMARY KEY(VAT), 
    FOREIGN KEY(VAT) REFERENCES doctor(VAT) ON DELETE CASCADE); 


CREATE TABLE trainee_doctor 
    (VAT INT NOT NULL UNIQUE, 
    supervisor INT, 
    PRIMARY KEY(VAT), 
    FOREIGN KEY(VAT) REFERENCES doctor(VAT) ON DELETE CASCADE, 
    FOREIGN KEY(supervisor) REFERENCES permanent_doctor(VAT) ON DELETE CASCADE);                                                         
 

CREATE TABLE appointment 
    (VAT_doctor INT NOT NULL, 
    date_timestamp DATETIME NOT NULL, 
    description_ VARCHAR(255), 
    VAT_client INT NOT NULL, 
    PRIMARY KEY(VAT_doctor, date_timestamp), 
    FOREIGN KEY(VAT_doctor) REFERENCES doctor(VAT) ON DELETE CASCADE, 
    FOREIGN KEY(VAT_client) REFERENCES client(VAT) ON DELETE CASCADE); 
 

CREATE TABLE supervision_report 
    (VAT INT NOT NULL, 
    date_timestamp DATETIME,
    description_ VARCHAR(255), 
    evaluation INT CHECK(evaluation>=1 AND evaluation <= 5), 
    PRIMARY KEY(VAT, date_timestamp), 
    FOREIGN KEY(VAT) REFERENCES trainee_doctor(VAT) ON DELETE CASCADE); 
 

CREATE TABLE consultation 
    (VAT_doctor INT NOT NULL, 
    date_timestamp DATETIME NOT NULL, 
    SOAP_S VARCHAR(255), 
    SOAP_O VARCHAR(255), 
    SOAP_A VARCHAR(255), 
    SOAP_P VARCHAR(255), 
    PRIMARY KEY(VAT_doctor, date_timestamp), 
    FOREIGN KEY(VAT_doctor, date_timestamp) REFERENCES appointment(VAT_doctor, date_timestamp) ON DELETE CASCADE); 


CREATE TABLE consultation_assistant 
    (VAT_doctor INT NOT NULL, 
    date_timestamp DATETIME NOT NULL, 
    VAT_nurse INT NOT NULL, 
    PRIMARY KEY(VAT_doctor, date_timestamp, VAT_nurse), 
    FOREIGN KEY(VAT_doctor, date_timestamp) REFERENCES consultation(VAT_doctor, date_timestamp) ON DELETE CASCADE, 
    FOREIGN KEY(VAT_nurse) REFERENCES nurse(VAT) ON DELETE CASCADE);


CREATE TABLE diagnostic_code 
    (ID INT NOT NULL UNIQUE, 
    description VARCHAR(255), 
    PRIMARY KEY(ID)); 
 

CREATE TABLE diagnostic_code_relation 
    (ID1 INT NOT NULL, 
    ID2 INT NOT NULL, 
    type_ VARCHAR(255), 
    PRIMARY KEY(ID1, ID2), 
    FOREIGN KEY(ID1) REFERENCES diagnostic_code(ID) ON DELETE CASCADE, 
    FOREIGN KEY(ID2) REFERENCES diagnostic_code(ID) ON DELETE CASCADE); 
 

CREATE TABLE consultation_diagnostic 
    (VAT_doctor INT NOT NULL, 
    date_timestamp DATETIME NOT NULL, 
    ID INT NOT NULL, 
    PRIMARY KEY(VAT_doctor, date_timestamp, ID), 
    FOREIGN KEY(VAT_doctor, date_timestamp) REFERENCES consultation(VAT_doctor, date_timestamp) ON DELETE CASCADE, 
    FOREIGN KEY(ID) REFERENCES diagnostic_code(ID) ON DELETE CASCADE ON UPDATE CASCADE); 
 

CREATE TABLE medication 
    (name_ VARCHAR(255) NOT NULL UNIQUE, 
    lab VARCHAR(255) NOT NULL, 
    PRIMARY KEY(name_, lab)); 


CREATE TABLE prescription 
    (name_ VARCHAR(255) NOT NULL, 
    lab VARCHAR(255) NOT NULL, 
    VAT_doctor INT NOT NULL, 
    date_timestamp DATETIME NOT NULL, 
    ID INT NOT NULL, 
    dosage VARCHAR(255), 
    description_ VARCHAR(255), 
    PRIMARY KEY(name_, lab, VAT_doctor, date_timestamp, ID), 
    FOREIGN KEY(VAT_doctor, date_timestamp, ID) REFERENCES consultation_diagnostic(VAT_doctor, date_timestamp, ID) ON DELETE CASCADE, 
    FOREIGN KEY(name_, lab) REFERENCES medication(name_, lab) ON DELETE CASCADE); 
 

CREATE TABLE procedure_ 
    (name_ VARCHAR(255) NOT NULL UNIQUE, 
    type_ VARCHAR(255), 
    PRIMARY KEY(name_)); 
 

CREATE TABLE procedure_in_consultation 
    (name_ VARCHAR(255) NOT NULL, 
    VAT_doctor INT NOT NULL, 
    date_timestamp DATETIME NOT NULL, 
    description_ VARCHAR(255), 
    PRIMARY KEY(name_, VAT_doctor, date_timestamp), 
    FOREIGN KEY(name_) REFERENCES procedure_(name_) ON DELETE CASCADE, 
    FOREIGN KEY(VAT_doctor, date_timestamp) REFERENCES consultation(VAT_doctor, date_timestamp) ON DELETE CASCADE); 
 

CREATE TABLE procedure_radiology 
    (name_ VARCHAR(255) NOT NULL, 
    file_ VARCHAR(255), 
    VAT_doctor INT NOT NULL, 
    date_timestamp DATETIME NOT NULL, 
    PRIMARY KEY(name_, file_, VAT_doctor, date_timestamp), 
    FOREIGN KEY(name_, VAT_doctor, date_timestamp) REFERENCES procedure_in_consultation(name_, VAT_doctor, date_timestamp) ON DELETE CASCADE); 
 

CREATE TABLE teeth 
    (quadrant VARCHAR(255), 
    number_ INT, 
    name_ VARCHAR(255), 
    PRIMARY KEY(quadrant, number_)); 


CREATE TABLE procedure_charting 
    (name_ VARCHAR(255) NOT NULL, 
    VAT INT NOT NULL, 
    date_timestamp DATETIME NOT NULL, 
    quadrant VARCHAR(255), 
    number_ INT, 
    desc_ VARCHAR(255), 
    measure INT, 
    PRIMARY KEY(name_, VAT, date_timestamp, quadrant, number_), 
    FOREIGN KEY(name_, VAT, date_timestamp) REFERENCES procedure_in_consultation(name_, VAT_doctor, date_timestamp) ON DELETE CASCADE, 
    FOREIGN KEY(quadrant, number_) REFERENCES teeth(quadrant, number_) ON DELETE CASCADE); 

/************************************************************************************************************************************/

/***************************CREATE VIEWS*********************************************************************************************/

create view dim_date
as 
(select c.date_timestamp,
extract(year from c.date_timestamp) as year, 
extract(month from c.date_timestamp) as month, 
extract(day from c.date_timestamp) as day
from consultation as c);


create view dim_client
as
(select VAT, gender, age from client);


create view dim_location_client
as (select zip, city from client);


create view facts_consults as
SELECT dim_client.VAT, dim_location_client.zip, dim_date.date_timestamp as date, Count(DISTINCT procedure_in_consultation.name_) 
as Number_Procedures, Count(DISTINCT consultation_diagnostic.ID) as Number_Diagnostics, Count(DISTINCT prescription.name_) as Number_Medications
FROM dim_client, dim_location_client, dim_date
LEFT OUTER JOIN procedure_in_consultation ON dim_date.date_timestamp = procedure_in_consultation.date_timestamp
LEFT OUTER JOIN consultation_diagnostic ON consultation_diagnostic.date_timestamp=dim_date.date_timestamp 
LEFT OUTER JOIN prescription ON prescription.date_timestamp = dim_date.date_timestamp
JOIN client AS c
JOIN appointment AS a
WHERE dim_client.VAT=c.VAT
AND dim_location_client.zip = c.zip
AND dim_client.VAT=a.VAT_client
AND dim_date.date_timestamp=a.date_timestamp
GROUP BY dim_client.VAT,dim_date.date_timestamp;

/****************************************************************************************************************************************/

/**********************CREATE FUNCTION****************************************************************************************************/

DELIMITER $$
create function no_shows(gender varchar(20), year_ int, upper_age int, lower_age int)
returns int

begin

declare no_shows int;

select count(*) into no_shows from (
select a.VAT_doctor, a.date_timestamp, a.VAT_client from appointment as a, client as cl
where not exists (select VAT_doctor, date_timestamp
                    from consultation as c where c.VAT_doctor = a.VAT_doctor
                    and c.date_timestamp = a.date_timestamp) 
and extract(year from a.date_timestamp) = year_ 
and a.VAT_client = cl.VAT
and cl.gender = gender
and cl.age > lower_age and cl.age < upper_age
group by a.VAT_doctor, a.date_timestamp) as x;

return no_shows;

end$$
DELIMITER ;

/******************************************************************************************************************************************/

/**************************CREATE STORED PROCEDURE*****************************************************************************************/

DELIMITER $$
CREATE PROCEDURE raise_doctor_salary(in years int)

begin
    declare num_cons int;
    declare done int default 0;
    declare r int;
    declare c_salary numeric(20,2);

    declare c cursor FOR 
        select e.VAT from employee as e, doctor as d, permanent_doctor as pd where pd.VAT = d.VAT and d.VAT = e.VAT and pd.years > years;

    declare continue handler 
        for not found set done = 1;

    open c;
    repeat
        fetch c into r;
        if not done then
            select count(*) into num_cons from 
            (select VAT_doctor, date_timestamp from consultation where VAT_doctor = r 
            and extract(year from date_timestamp) = extract(year from current_timestamp)) as count_cons;

            select salary into c_salary from employee where VAT = r;

            if num_cons >= 100 then
                set c_salary = c_salary*1.1;
            else
                set c_salary = c_salary*1.05;
            end if;

            update employee
            set employee.salary = c_salary
            where employee.VAT = r;

        end if;
        until done
        end repeat;
        close c;
end$$
DELIMITER ;

/******************************************************************************************************************************************/

/**************************CREATE TRIGGERS*************************************************************************************************/

/*Point 1*/

delimiter $$
create trigger update_age after insert on appointment
for each row
begin
    update client
    set client.age = extract(year from (from_days(DATEDIFF(current_timestamp,client.birth_date))))
    where client.VAT = new.VAT_client;
end$$
delimiter ;

/*Point 2*/

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

/*Point 3*/

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

/******************************************************************************************************************************************/

/*************************INSERT RECORDS***************************************************************************************************/

Insert into client values (12345678, 'Joao', '1996-08-08', 'Praceta da Luz', 'Lisboa', '2610-062', 'Male', 23); 
Insert into client values (23456789, 'Rui', '1946-08-08', 'Avenida da Liberdade ', 'Lisboa', '2610-062', 'Male', 40);
Insert into client values (89123456, 'Ze', '1967-03-01', 'Rossio', 'Lisboa', '2610-062', 'Male', 89); 
Insert into client values (87654321, 'Maria', '2003-01-14', 'Rua do Campo', 'Rio de Janeiro', '2610-062', 'Female', 40);
Insert into client values (45678123, 'Tiago', '1965-01-01', 'Estrada da Luz', 'Lisboa', '2690-052', 'Male', 30); 
Insert into client values (43215678, 'Rita', '1916-03-03', 'Praça da Alegria', 'Lisboa', '1610-035', 'Female', 103); 
Insert into client values (18273645, 'Luis Carlos', '1997-03-28', 'Rua do Marquês', 'Lisboa', '2610-350', 'Male', 22); 
Insert into client values (87333321, 'Inês', '2005-08-17', 'Praceta do Comércio', 'Gaia', '2610-062', 'Female', 14); 


Insert into phone_number_client values(12345678,  351917654321); 
Insert into phone_number_client values(23456789,  351917754321); 
Insert into phone_number_client values(89123456,  351937754321); 
Insert into phone_number_client values(87654321,  351937754421); 
Insert into phone_number_client values(45678123,  351966654321); 
Insert into phone_number_client values(43215678,  351922254321); 
Insert into phone_number_client values(18273645,  351922224321); 
Insert into phone_number_client values(87333321,  351937666421); 


Insert into employee values(12345876, 'Joao', '1996-12-08', 'Principe Real', 'Lisboa', '2610-062', '339237212', 1300);
Insert into employee values(12456876, 'Rui', '1960-12-30', 'Praça de Londres',  'Lisboa', '2610-062', '44423721', 1300); 
Insert into employee values(88888888, 'Jane Sweettooth', '1963-11-30', 'Rua das Conchas', 'Lisboa', '2612-063', '55577788', 2500); 
Insert into employee values(11111222, 'Jack Sweettath', '1964-11-15', 'Rua da Falagueira', 'Lisboa', '2612-373', '44577788', 3000); 
Insert into employee values(44440000, 'Joseph', '1965-03-26', 'Norwich', 'London', '2610-062', '66677788', 1300);
Insert into employee values(14444876, 'Richard', '1995-01-26', 'Gatewick', 'London', '2610-355', '11677788', 1300);
Insert into employee values(55555555, 'Mara', '1965-03-26', 'Central Park L', 'London', '2610-072', '65657788', 1300); 
Insert into employee values(222000333, 'Johnson', '1965-03-26', 'Route 69', 'London', '2610-062', '96677788', 1300); 
Insert into employee values(14445876, 'Luis', '1978-01-08', 'AmadoraCity', 'Lisboa', '2610-062', '66637212', 1300);
Insert into employee values(14345876, 'Ana', '1978-02-18', 'Praça das Flores', 'Lisboa', '2615-252', '66677212', 1000);
Insert into employee values(54445875, 'Lucas', '1979-01-18', 'Cova da Mora', 'Lisboa', '2610-333', '88823212', 1200); 
Insert into employee values(54445867, 'Hugo', '1945-01-18', 'Rua Castelo Branco', 'Castelo Branco', '2610-332', '88822212', 1200);
Insert into employee values(54445869, 'Ana', '2000-01-18', 'Avenida dos d', 'Faro', '8610-332', '88823292', 1200);
Insert into employee values(54445870, 'Joana', '2002-01-18', 'Avenida', 'Tavira', '5231-344', '888232232', 1200);


Insert into phone_number_employee values(12345876,  351911111111); 
Insert into phone_number_employee values(12456876,  351911111333);
Insert into phone_number_employee values(88888888,  351911122333);
Insert into phone_number_employee values(11111222,  351922232333); 
Insert into phone_number_employee values(44440000,  351914441333);
Insert into phone_number_employee values(14444876,  351914441393);
Insert into phone_number_employee values(55555555,  351914441353);
Insert into phone_number_employee values(222000333, 351916641333);
Insert into phone_number_employee values(14445876,  351914455533);
Insert into phone_number_employee values(14345876,  351914455443);
Insert into phone_number_employee values(54445875,  351964455533);
Insert into phone_number_employee values(54445867,  351964455588);
Insert into phone_number_employee values(54445869,  351964455576);
Insert into phone_number_employee values(54445870,  351964455571);


Insert into doctor values(12345876, 'Feet', 'Ótimo doutor estudou no IST',  'doctor1@gmail.com'); 
Insert into doctor values(12456876, 'Hands', 'Péssimo doutor estudou no ISEL',  'doctor2@gmail.com'); 
Insert into doctor values(88888888, 'Teeth', 'Excelente doutor estudou no IST',  'doctor3@gmail.com'); 
Insert into doctor values(11111222, 'Ears', 'Razoável e experiente doutor estudou na nova',  'doctor4@gmail.com');
Insert into doctor values(44440000, 'Fingers', 'Studied in Harvard',  'doctor200@gmail.com');
Insert into doctor values(14444876, 'Stomach', 'Good trainee',  'doctor208@gmail.com');
Insert into doctor values(55555555, 'Nails', 'Studied in Portugal FCT',  'doctor209@gmail.com');
Insert into doctor values(222000333, 'Dead People', 'The worst I have ever seen',  'doctor210@gmail.com'); 


Insert into permanent_doctor values(12345876, 10); 
Insert into permanent_doctor values(12456876, 6); 
Insert into permanent_doctor values(88888888, 8);
Insert into permanent_doctor values(11111222, 15);


Insert into trainee_doctor values(44440000, 12456876); 
Insert into trainee_doctor values(14444876, 12456876);  
Insert into trainee_doctor values(55555555, 11111222);
Insert into trainee_doctor values(222000333, 12456876);
 

Insert into receptionist values(14445876); 
Insert into receptionist values(14345876);
 

Insert into nurse values(54445875); 
Insert into nurse values(54445867);
Insert into nurse values(54445869);
Insert into nurse values(54445870);


Insert into supervision_report values(44440000, '2010-10-10 10:00:00', 'O trainee anda a brincar com isto', 4); 
Insert into supervision_report values(14444876, '2018-10-12 11:00:00', 'Very good doctor', 5); 
Insert into supervision_report values(55555555, '2019-10-10 19:00:00', 'Mara is terrible', 1); 
Insert into supervision_report values(222000333, '2019-10-15 16:00:00', 'Johnson is not terrible', 1); 
Insert into supervision_report values(55555555, '2016-10-15 16:00:00', 'Mara is really bad', 2); 
Insert into supervision_report values(14444876, '2017-10-12 9:00:00', 'It was good overall, however in feet part it was insufficient', 4); 


insert into appointment values(12456876, '2008-12-3 12:00:00', 'O cliente esteve presente no consultório', 12345678); 
insert into appointment values(12345876, '2008-12-4 10:30:00', 'O cliente esteve impaciente', 23456789); 
insert into appointment values(88888888, '2008-12-6 16:35:00', 'Confirmado para as 18', 18273645); 
insert into appointment values(11111222, '2008-12-5 17:00:00', 'O cliente era chato que doia', 18273645); 
insert into appointment values(88888888, '2008-12-8 8:00:00', 'O cliente era impossivel', 23456789); 
insert into appointment values(88888888, '2008-12-6 17:00:00', 'A Ines era impossivel', 87333321); 
insert into appointment values(88888888, '2010-12-6 17:00:00', 'She is very sick', 87333321); 
insert into appointment values(88888888, '2012-12-6 17:00:00', 'She is very sick', 87654321); 
insert into appointment values(12345876, '2019-07-6 17:00:00', 'The client was angry', 87333321); 
insert into appointment values(88888888, '2019-08-6 17:00:00', 'Confirmed', 43215678); 
insert into appointment values(12345876, '2019-09-6 17:00:00', 'The client attended the appointment', 18273645); 
insert into appointment values(88888888, '2019-12-6 17:00:00', 'The appointment changed date', 87333321); 
insert into appointment values(12456876, '2019-10-6 17:00:00', 'The client was older than expected', 12345678); 
insert into appointment values(12456876, '2017-10-6 17:00:00', 'The was extremely tall', 12345678);
insert into appointment values(12456876, '2019-12-25 17:00:00', 'He was close to dying', 18273645);
insert into appointment values(88888888, '2019-01-31 17:00:00', 'Não veio', 87333321); 
insert into appointment values(11111222, '2019-01-21 17:00:00', 'Nao veio outra vez', 87333321);
insert into appointment values(88888888, '2019-02-01 17:00:00', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-02-02 17:00:00', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-02-03 17:00:00', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-02-04 17:00:00', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-02-05 17:00:00', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-02-06 17:00:00', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-02-07 17:00:00', 'Não veio', 87333321);
insert into appointment values(11111222, '2007-12-6 17:00:00', 'The patient is not nice', 87333321);


insert into appointment values(88888888, '2019-03-01 17:00:00', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:01', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:02', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:03', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:04', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:05', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:06', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:07', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:08', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:09', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:10', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:11', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:12', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:13', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:14', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:15', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:16', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:17', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:18', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:19', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:20', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:21', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:22', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:23', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:24', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:25', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:26', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:27', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:28', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:29', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:30', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:31', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:32', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:33', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:34', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:35', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:36', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:37', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:38', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:39', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:40', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:41', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:42', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:43', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:44', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:45', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:46', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:47', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:48', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:49', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:50', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:51', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:52', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:53', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:54', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:55', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:56', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:57', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:58', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:00:59', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:00', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:01', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:02', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:03', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:04', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:05', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:06', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:07', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:08', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:09', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:10', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:11', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:12', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:13', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:14', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:15', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:16', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:17', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:18', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:19', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:20', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:21', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:22', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:23', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:24', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:25', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:26', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:27', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:28', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:29', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:30', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:31', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:32', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:33', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:34', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:35', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:36', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:37', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:38', 'Não veio', 87333321);
insert into appointment values(88888888, '2019-03-01 17:01:39', 'Não veio', 87333321);


insert into consultation values(12456876, '2008-12-3 12:00:00', 'a', 'b', 'c', 'd'); 
insert into consultation values(12345876, '2008-12-4 10:30:00', 'S', 'O', 'A', 'P'); 
insert into consultation values(88888888, '2008-12-6 16:35:00', 'e', ' gingivitis', 'g', 'h'); 
insert into consultation values(11111222, '2008-12-5 17:00:00', 'l', ' periodontitis ', 'j', 'i'); 
insert into consultation values(88888888, '2008-12-8 8:00:00', 'm', 'k', 'ç', 'p'); 
insert into consultation values(88888888, '2008-12-6 17:00:00', 'z', 'w', 'x', 'y');
insert into consultation values(12345876, '2019-07-6 17:00:00', 'z', 'w', 'x', 'y'); 
insert into consultation values(88888888, '2019-08-6 17:00:00', 'z', 'w', 'x', 'y'); 
insert into consultation values(12345876, '2019-09-6 17:00:00', 'z', 'w', 'x', 'y'); 
insert into consultation values(88888888, '2019-12-6 17:00:00', 'z', 'He has gingivitis', 'x', 'y'); 
insert into consultation values(12456876, '2019-10-6 17:00:00', 'z', 'w', 'x', 'y'); 
insert into consultation values(12456876, '2017-10-6 17:00:00', 'z', 'w', 'x', 'y');
insert into consultation values(12456876, '2019-12-25 17:00:00', 'g', 'periodontitis', 'x', 'i');
insert into consultation values(11111222, '2007-12-6 17:00:00', 'z', 'w', 'x', 'y');


insert into consultation values(88888888, '2019-03-01 17:00:00', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:01', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:02', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:03', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:04', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:05', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:06', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:07', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:08', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:09', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:10', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:11', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:12', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:13', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:14', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:15', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:16', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:17', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:18', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:19', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:20', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:21', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:22', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:23', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:24', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:25', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:26', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:27', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:28', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:29', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:30', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:31', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:32', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:33', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:34', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:35', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:36', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:37', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:38', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:39', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:40', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:41', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:42', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:43', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:44', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:45', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:46', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:47', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:48', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:49', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:50', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:51', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:52', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:53', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:54', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:55', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:56', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:57', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:58', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:00:59', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:00', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:01', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:02', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:03', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:04', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:05', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:06', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:07', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:08', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:09', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:10', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:11', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:12', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:13', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:14', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:15', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:16', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:17', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:18', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:19', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:20', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:21', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:22', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:23', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:24', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:25', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:26', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:27', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:28', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:29', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:30', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:31', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:32', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:33', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:34', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:35', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:36', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:37', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:38', 'S', 'O', 'A', 'P');
insert into consultation values(88888888, '2019-03-01 17:01:39', 'S', 'O', 'A', 'P');



insert into consultation_assistant values(12456876, '2008-12-3 12:00:00', 54445875);
insert into consultation_assistant values(12456876, '2008-12-3 12:00:00', 54445867);
insert into consultation_assistant values(12345876, '2008-12-4 10:30:00', 54445867);
insert into consultation_assistant values(12345876, '2008-12-4 10:30:00', 54445870);
insert into consultation_assistant values(12345876, '2008-12-4 10:30:00', 54445869);
insert into consultation_assistant values(88888888, '2008-12-6 16:35:00', 54445867);
insert into consultation_assistant values(88888888, '2008-12-6 16:35:00', 54445869);
insert into consultation_assistant values(11111222, '2008-12-5 17:00:00', 54445867);
insert into consultation_assistant values(11111222, '2008-12-5 17:00:00', 54445869);
insert into consultation_assistant values(88888888, '2008-12-8 8:00:00' , 54445867);
insert into consultation_assistant values(88888888, '2008-12-8 8:00:00' , 54445870);
insert into consultation_assistant values(12345876, '2019-07-6 17:00:00', 54445867);
insert into consultation_assistant values(12345876, '2019-07-6 17:00:00', 54445869);
insert into consultation_assistant values(88888888, '2019-08-6 17:00:00', 54445867);
insert into consultation_assistant values(88888888, '2019-08-6 17:00:00', 54445875);
insert into consultation_assistant values(12345876, '2019-09-6 17:00:00', 54445867);
insert into consultation_assistant values(88888888, '2019-12-6 17:00:00', 54445867);
insert into consultation_assistant values(12456876, '2019-10-6 17:00:00', 54445867);
insert into consultation_assistant values(88888888, '2008-12-6 17:00:00', 54445867);
insert into consultation_assistant values(12456876, '2017-10-6 17:00:00', 54445867);
insert into consultation_assistant values(11111222, '2007-12-6 17:00:00', 54445867);

insert into consultation_assistant values(88888888, '2019-03-01 17:00:24', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:25', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:26', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:27', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:28', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:29', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:30', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:31', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:32', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:33', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:34', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:35', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:36', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:37', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:38', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:39', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:40', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:41', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:42', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:43', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:44', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:45', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:46', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:47', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:48', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:49', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:50', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:51', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:52', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:53', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:54', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:55', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:56', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:57', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:58', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:00:59', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:00', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:01', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:02', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:03', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:04', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:05', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:06', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:07', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:08', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:09', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:10', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:11', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:12', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:13', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:14', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:15', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:16', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:17', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:18', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:19', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:20', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:21', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:22', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:23', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:24', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:25', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:26', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:27', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:28', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:29', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:30', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:31', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:32', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:33', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:34', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:35', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:36', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:37', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:38', 54445875);
insert into consultation_assistant values(88888888, '2019-03-01 17:01:39', 54445875);


insert into diagnostic_code values(123456000, 'bleeding or swollen gums after brushing or flossing'); 
insert into diagnostic_code values(987654321, 'chronic bad breath'); 
insert into diagnostic_code values(123789456, 'sudden sensitivity to hot and cold temperatures or beverages'); 
insert into diagnostic_code values(987321654, 'pain or toothache'); 
insert into diagnostic_code values(980000000, 'loose teeth'); 
insert into diagnostic_code values(980000001, 'receding gums'); 
insert into diagnostic_code values(980000002, 'pain with chewing or biting'); 
insert into diagnostic_code values(980000003, 'swelling of the face and cheek'); 
insert into diagnostic_code values(980000004, 'cracked or broken teeth'); 
insert into diagnostic_code values(980000005, 'frequent dry mouth');
insert into diagnostic_code values(980000006, 'dental cavities, swelling of the face and cheek'); 
insert into diagnostic_code values(980000007, 'dental cavities, cracked or broken teeth'); 
insert into diagnostic_code values(980000008, 'infectious disease, frequent dry mouth');
insert into diagnostic_code values(980000009, 'gingivitis'); 

 
insert into consultation_diagnostic values(12456876, '2008-12-3 12:00:00', 123456000);
insert into consultation_diagnostic values(12456876, '2008-12-3 12:00:00', 980000009);
insert into consultation_diagnostic values(12345876, '2008-12-4 10:30:00', 123456000); 
insert into consultation_diagnostic values(88888888, '2008-12-6 16:35:00', 123789456); 
insert into consultation_diagnostic values(11111222, '2008-12-5 17:00:00', 987321654); 
insert into consultation_diagnostic values(88888888, '2008-12-6 17:00:00', 123456000); 
insert into consultation_diagnostic values(12345876, '2019-07-6 17:00:00', 980000006); 
insert into consultation_diagnostic values(88888888, '2019-08-6 17:00:00', 980000007); 
insert into consultation_diagnostic values(12345876, '2019-09-6 17:00:00', 980000008); 
insert into consultation_diagnostic values(88888888, '2019-12-6 17:00:00', 980000006); 
insert into consultation_diagnostic values(12456876, '2019-10-6 17:00:00', 123456000); 
insert into consultation_diagnostic values(12456876, '2017-10-6 17:00:00', 980000007);
insert into consultation_diagnostic values(11111222, '2007-12-6 17:00:00', 980000009);


insert into medication values('Advil', 'Bayer Schering Pharma AG'); 
insert into medication values('Benzamycin', 'Biogen'); 
insert into medication values('Peridex', 'Axcan Pharma'); 
insert into medication values('Atridox', 'Aspen Pharmacare'); 
insert into medication values('Mycostatin', 'Mitsubishi Pharma'); 
insert into medication values('Acidul', 'Novartis'); 
insert into medication values('Valium', 'Servier Laboratories');


insert into prescription values('Benzamycin','Biogen', 12456876, '2008-12-3 12:00:00', 123456000, 'Two doses', 'Every twelve hours, for 1 week');      
insert into prescription values('Peridex','Axcan Pharma', 12345876, '2008-12-4 10:30:00', 123456000, 'Three doses', 'Every five hours, for 7 week');  
insert into prescription values('Mycostatin','Mitsubishi Pharma', 88888888, '2008-12-6 16:35:00', 123789456, 'Two doses', 'Every eight hours, for 1 week' ); 
insert into prescription values('Mycostatin','Mitsubishi Pharma', 11111222, '2008-12-5 17:00:00', 987321654,'Three doses/Day', 'Every five hours, for 7 week') ;  
insert into prescription values('Benzamycin','Biogen', 88888888,  '2008-12-6 17:00:00', 123456000,'Three doses', 'Every five hours, for 7 week'); 
insert into prescription values('Acidul','Novartis',12345876, '2019-07-6 17:00:00', 980000006,'Three doses', 'Every eight hours, for 1 week'); 
insert into prescription values('Atridox','Aspen Pharmacare', 88888888, '2019-08-6 17:00:00', 980000007,'Three doses', 'Every five hours, for 7 week'); 
insert into prescription values('Benzamycin','Biogen', 12345876, '2019-09-6 17:00:00', 980000008,'Four doses/Day', 'Every five hours, for 7 week'); 
insert into prescription values('Valium','Servier Laboratories', 88888888, '2019-12-6 17:00:00', 980000006,'Three doses', 'Every five hours, for 7 week'); 
insert into prescription values('Peridex','Axcan Pharma', 12456876, '2019-10-6 17:00:00', 123456000,'Five doses', 'Every twelve hours, for 1 week'); 
insert into prescription values('Peridex','Axcan Pharma', 12456876, '2017-10-6 17:00:00', 980000007, 'Four doses', 'Every twelve hours, for 1 week'); 


insert into procedure_ values('maxillary molar periapical radiograph', 'radiography exam'); 
insert into procedure_ values('maxillary incisivus radiograph', 'radiography exam'); 
insert into procedure_ values('maxillary caninus radiograph', 'radiography exam'); 
insert into procedure_ values('caninus extraction', 'tooth extractions'); 
insert into procedure_ values('molar extraction', 'tooth extractions'); 
insert into procedure_ values('upper side map chart', 'dental charting'); 
insert into procedure_ values('down side map chart', 'dental charting'); 


insert into procedure_in_consultation values('maxillary molar periapical radiograph', 88888888, '2008-12-6 17:00:00', 'Went well'); 
insert into procedure_in_consultation values('molar extraction', 88888888, '2008-12-6 17:00:00', 'Went more less'); 
insert into procedure_in_consultation values('down side map chart', 11111222, '2008-12-5 17:00:00', 'Went very badly'); 
insert into procedure_in_consultation values('molar extraction', 12345876, '2019-07-6 17:00:00', 'Went very badly');
insert into procedure_in_consultation values('down side map chart', 88888888, '2019-08-6 17:00:00', 'Went very badly');
insert into procedure_in_consultation values('down side map chart ', 12456876, '2008-12-03 12:00:00', 'All the teeth must be removed');
insert into procedure_in_consultation values('down side map chart ', 11111222, '2007-12-6 17:00:00', 'Front teeth must be removed');

insert into teeth values('Upper Right', 1, 'Wisdom Tooth (3rd Molar)');
insert into teeth values('Upper Right', 2, 'Molar (2nd Molar)');
insert into teeth values('Upper Right', 3, 'Molar (1st Molar)');
insert into teeth values('Upper Right', 4, 'Bicuspid (2nd)');
insert into teeth values('Upper Right', 5, 'Bicuspid (1st)');
insert into teeth values('Upper Right', 6, 'Canine (Eye tooth / Cuspid)');
insert into teeth values('Upper Right', 7, 'Incisor (Lateral)');
insert into teeth values('Upper Right', 8, 'Incisor (Central)');
insert into teeth values('Upper Left',  9, 'Incisor (Central)');
insert into teeth values('Upper Left', 10, 'Incisor (Lateral)');
insert into teeth values('Upper Left', 11, 'Canine (Eye tooth / Cuspid)');
insert into teeth values('Upper Left', 12, 'Bicuspid (1st)');
insert into teeth values('Upper Left', 13, 'Bicuspid (2nd)');
insert into teeth values('Upper Left', 14, 'Molar (1st)');
insert into teeth values('Upper Left', 15, 'Molar (2nd)');
insert into teeth values('Upper Left', 16, 'Wisdom Tooth (3rd Molar)');
insert into teeth values('Lower Left', 17, 'Wisdom Tooth (3rd Molar)');
insert into teeth values('Lower Left', 18, 'Molar (2nd Molar)');
insert into teeth values('Lower Left', 19, 'Molar (1st Molar)');
insert into teeth values('Lower Left', 20, 'Bicuspid (2nd)');
insert into teeth values('Lower Left', 21, 'Bicuspid (1st)');
insert into teeth values('Lower Left', 22, 'Canine (Eye tooth / Cuspid)');
insert into teeth values('Lower Left', 23, 'Incisor (Lateral)');
insert into teeth values('Lower Left', 24, 'Incisor (Central)');
insert into teeth values('Lower Right', 25, 'Incisor (Central)');
insert into teeth values('Lower Right', 26, 'Incisor (Lateral)');
insert into teeth values('Lower Right', 27, 'Canine (Eye tooth / Cuspid)');
insert into teeth values('Lower Right', 28, 'Bicuspid (1st)');
insert into teeth values('Lower Right', 29, 'Bicuspid (2nd)');
insert into teeth values('Lower Right', 30, 'Molar (1st Molar)');
insert into teeth values('Lower Right', 31, 'Molar (2nd Molar)');
insert into teeth values('Lower Right', 32, 'Wisdom Tooth (3rd Molar)');


insert into procedure_charting values('down side map chart ', 12456876, '2008-12-03 12:00:00', 'Upper Right', 4, 'The teeth is ok', 5);
insert into procedure_charting values('down side map chart ', 12456876, '2008-12-03 12:00:00', 'Upper Right', 2, 'The teeth is ok', 6);
insert into procedure_charting values('down side map chart ',12456876, '2008-12-03 12:00:00', 'Upper Right', 3, 'The teeth is ok', 4);
insert into procedure_charting values('down side map chart ',12456876, '2008-12-03 12:00:00', 'Upper Right', 1, 'The teeth is ok', 7);
insert into procedure_charting values('down side map chart ', 12456876, '2008-12-03 12:00:00', 'Lower Right', 29, 'The teeth is ok', 8);
insert into procedure_charting values('down side map chart ', 11111222, '2007-12-6 17:00:00', 'Lower Left', 24, 'The teeth is ok', 2);
insert into procedure_charting values('down side map chart ', 11111222, '2007-12-6 17:00:00', 'Upper Left', 12, 'The teeth is ok', 3);
insert into procedure_charting values('down side map chart ', 11111222, '2007-12-6 17:00:00', 'Lower Right', 32, 'The teeth is ok', 4);
insert into procedure_charting values('down side map chart ', 11111222, '2007-12-6 17:00:00', 'Upper Right', 3, 'The teeth is ok', 1);
insert into procedure_charting values('down side map chart ', 11111222, '2007-12-6 17:00:00', 'Upper Right', 5, 'The teeth is ok', 2);


/***********************************************************************************************************************************************/