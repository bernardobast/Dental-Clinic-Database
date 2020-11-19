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