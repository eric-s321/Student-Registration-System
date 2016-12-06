


create or replace trigger delete_enrollments_of_student
before delete on students
for each row
begin
    dbms_output.put_line('In delete enrollments trigger');
end;
