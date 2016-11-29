create or replace trigger update_class_size
after insert on enrollments
for each row
begin
        update classes                          --when an enrollment is added, update the size of that class
        set class_size = class_size + 1
        where classid = :new.classid;
end;
/
