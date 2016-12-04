drop sequence logSeq;


create sequence logSeq
increment by 1
start with 1000;


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


create or replace trigger delete_enrollments_of_student
before delete on students
for each row
begin
        dbms_output.put_line('In delete enrollments trigger');
        delete from enrollments         -- Delete enrollments of the student we are trying to delete from students table
        where B# = :old.B#;
end;
/


create or replace trigger student_log
after delete or insert on students
for each row
declare
        current_user varchar2(20);
begin
        select user into current_user  -- Get user who is performing operation 
        from dual; 
        if deleting then   -- deleting student from students table
                insert into logs       --add deletion log
                values (logSeq.nextval,current_user,current_timestamp,'students','delete',:old.B#);             
        else    --We are adding student to students table
                insert into logs                --add insertion log
                values (logSeq.nextval, current_user, current_timestamp, 'students', 'insert', :new.B#);
        end if;
end;
/


create or replace trigger enrollment_log
after delete or insert on enrollments
for each row
declare
        current_user varchar2(20);
begin
        select user into current_user   -- Get user who is performing the operation
        from dual;
        if deleting then        --dropping a class
                insert into logs                --add deletion log
                values (logSeq.nextval, current_user, current_timestamp, 'enrollments', 'delete', :old.B# || ',' || :old.classid);
        else
                insert into logs                --add insertion log
                values (logSeq.nextval, current_user, current_timestamp, 'enrollments', 'insert', :new.B# || ',' || :new.classid);
        end if;
end;
/
