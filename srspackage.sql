set serveroutput on

create or replace package srs as
procedure find_student_class_info(B#_in in students.B#%type);
procedure show_students;
procedure show_courses;
procedure show_course_credit;
procedure show_prerequisites;
procedure show_classes;
procedure show_enrollments;
procedure show_grades;
procedure show_logs;
end;
/


create or replace package body srs as
procedure get_prereqs(dept_code in prerequisites.dept_code%type, course# in prerequisites.course#%type)
        is
        begin
                

        end;

procedure find_student_class_info(B#_in in students.B#%type)
        is
        classInfoFound boolean;
        isAStudent boolean;
        begin
                classInfoFound := false;        
                isAStudent := false;
                for row in 
                        (select e.B#, c.classid, c.dept_code, c.course#, c.sect#, c.year, c.semester, g.lgrade, g.ngrade 
                        from enrollments e, classes c, grades g 
                        where e.classid=c.classid and e.lgrade=g.lgrade)
                loop
                        if (row.B# = B#_in) then
                                dbms_output.put_line(row.classid || ' ' || row.dept_code || ' ' || row.course# || ' ' || 
                                        row.sect# || ' ' || row.year || ' ' || row.semester || ' ' || row.lgrade || ' ' || row.ngrade);
                                classInfoFound := true;
                        end if;
                end loop;
                for row in (select * from students)     
                loop
                        if(row.B# = B#_in) then
                                isAStudent := true;
                                exit;
                        end if; 
                end loop;
                if (isAStudent and not classInfoFound) then
                        dbms_output.put_line('The student has not taken any course.');
                elsif (not isAStudent) then
                        dbms_output.put_line('The B# is invalid');
                end if;
        end;

procedure show_students is
    begin
        for row in (select * from students)
        loop
        dbms_output.put_line(row.B# || ' ' || row.firstname || ' ' || row.lastname ||
                ' ' || row.status || ' ' || row.gpa || ' ' || row.email || ' ' || row.bdate || ' ' ||
                row.deptname);
        end loop;
    end;

procedure show_courses
        is
        begin
                for row in (select * from courses)
                loop
                        dbms_output.put_line(row.dept_code || ' ' || row.course# || ' ' || row.title);  
                end loop;
        end;

procedure show_course_credit
        is
        begin
                for row in (select * from course_credit)
                loop
                        dbms_output.put_line(row.course# || ' ' || row.credits);
                end loop;
        end;

procedure show_prerequisites
        is
        begin
                for row in (select * from prerequisites)
                loop
                        dbms_output.put_line(row.dept_code || ' ' || row.course# || ' ' || row.pre_dept_code ||
                        ' ' || row.pre_course#);
                end loop;
        end;

procedure show_classes
        is
        begin
                for row in (select * from classes)
                loop
                        dbms_output.put_line(row.classid || ' ' || row.dept_code || ' ' || row.course# || ' ' || row.sect# ||
                        ' ' || row.year || ' ' || row.semester || ' ' || row.limit || ' ' || row.class_size);
                end loop;
        end;

procedure show_enrollments
        is
        begin
                for row in (select * from enrollments)
                loop
                        dbms_output.put_line(row.B# || ' ' || row.classid || ' ' || row.lgrade);
                end loop;
        end;

procedure show_grades
        is
        begin
                for row in (select * from grades)
                loop
                        dbms_output.put_line(row.lgrade || ' ' || row.ngrade);
                end loop;
        end;

procedure show_logs
        is
        begin
                for row in (select * from logs)
                loop
                        dbms_output.put_line(row.logid || ' ' || row.who || ' ' || row.time || ' ' || row.table_name || 
                        ' ' || row.operation || ' ' || row.key_value);
                end loop;
        end;

end;
/
