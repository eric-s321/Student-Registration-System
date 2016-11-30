create or replace trigger increase_class_size
after insert on enrollments
for each row
begin
        update classes                          --when an enrollment is added, update the size of that class
        set class_size = class_size + 1
        where classid = :new.classid;
end;
/

create or replace trigger reduce_class_size
after delete on enrollments
for each row
begin
        dbms_output.put_line('In reduce trigger');
        update classes                          --when an enrollment is delete, decrease the size of that class
        set class_size = class_size - 1
        where classid = :old.classid;
end;
/
