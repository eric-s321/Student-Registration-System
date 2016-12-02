set serveroutput on


create or replace package srs as
type ref_cursor is ref cursor;
procedure drop_class(B# in students.B#%type, classid in classes.classid%type);
procedure enroll_student(B# in students.B#%type, classid in classes.classid%type);
procedure get_class_info(classid in classes.classid%type);
procedure get_prereqs(dept_code in prerequisites.dept_code%type, course# in prerequisites.course#%type);
procedure find_student_class_info(B#_in in students.B#%type);
function show_students
        return ref_cursor;
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
procedure drop_class(B# in students.B#%type, classid in classes.classid%type)
        is
        allowClassDrop boolean;
        invalidB# boolean;
        invalidClassid boolean;
        studentInClass boolean;
        enrolledClasses int;
        classSize int;
        B#_in students.B#%type;
        classid_in classes.classid%type;
        classDeptCode classes.dept_code%type;
        classCourse# classes.course#%type;
        prereqsOK boolean;
        begin
                invalidB# := true;
                invalidClassid := true;
                studentInClass := false;
                allowClassDrop := true;
                enrolledClasses := 0;
                classSize := 0;
                B#_in := B#;
                classid_in := classid;
                prereqsOK := true;

                for row in (select B# from students) -- Loop through each student in students table
                loop
                        if(row.B# = B#) then   -- If the B# passed into drop_class is found, the B# is valid 
                                invalidB# := false;
                        end if;
                end loop;

                for row in (select * from classes) -- Loop through each class in classes table
                loop
                        if(row.classid = classid) then   -- If the classid passed into drop_class is found, the classid is valid
                                invalidClassid := false;
                        end if;
                end loop;
        
                for row in (select * from enrollments)          -- Loop through all current enrollments
                loop
                        if(row.B# = B# and row.classid = classid) then          --If B# and classid are found in enrollments table, student is taking the class they want to drop
                                studentInClass := true; 
                        end if;
                end loop;

                if (not invalidB#) then
                        select count(*) into enrolledClasses                    -- count the number of classes the student is currently enrolled in
                        from enrollments                                        -- if this value is 1, then dropping it will cause the student to not be enrolled in any classes
                        where B#=B#_in; 
                end if;
                if (not invalidClassid) then
                        select class_size into classSize                        --Check current size of class, if it is 1, the student is last enrolled in the 
                        from classes                                            --class and it will become empty
                        where classid=classid_in;
                end if;
                if (studentInClass) then
                        select dept_code, course# into classDeptCode, classCourse#   --store dept_code and course#
                        from classes                                                 --of class they wish to drop
                        where classid = classid_in;
        
                        for row in 
                                (select  p.pre_dept_code, p.pre_course#  --Get all prereqs for currently enrolled classes
                                from enrollments e 
                                join classes c
                                        on e.classid = c.classid
                                join prerequisites p
                                        on c.dept_code = p.dept_code and c.course# = p.course#
                                where e.B#=B#_in
                                group by p.pre_dept_code, p.pre_course#)
                        loop
                                if(row.pre_dept_code = classDeptCode and row.pre_course# = classCourse#) then  --if they are trying to drop a prereq for another class do not allow.
                                        prereqsOK := false;     
                                end if;
                --              dbms_output.put_line('dept code is ' || ' '  || classDeptCode
                --                      || ' ' || 'course num is ' || classCourse#);
                        end loop;
                end if;
                                
                if (invalidB#) then
                        dbms_output.put_line('The B# is invalid.');
                        allowClassDrop := false;
                end if;
                if (invalidClassid) then
                        dbms_output.put_line('The classid is invalid.');
                        allowClassDrop := false;
                end if;
                if (not studentInClass and not invalidB# and not invalidClassid) then           --Check all 3 conditions because if invalid B# or invalid classid class info  
                        dbms_output.put_line('The student is not enrolled in the class.');      --will not be found in enrollments table
                        allowClassDrop := false;
                end if;
                if (enrolledClasses = 1 and studentInClass) then
                        dbms_output.put_line('This student is no longer enrolled in any classes');
                end if;
                if (classSize = 1 and studentInClass) then
                        dbms_output.put_line('The class now has no students.');
                end if;
                if (not prereqsOK) then
                        dbms_output.put_line('The drop is not permitted because another class uses it as a prerequisite');
                        allowClassDrop := false;
                end if;
                if (allowClassDrop) then
                        dbms_output.put_line('Dropping class...');
                        delete from enrollments
                        where B# = B#_in and classid = classid_in;                      
                end if;
--              dbms_output.put_line('Student is enrolled in: ' || enrolledClasses || ' ' || ' classes');
--              dbms_output.put_line('Size of class is: ' || classSize);
        end;
procedure enroll_student(B# in students.B#%type, classid in classes.classid%type)
        is
        enrollmentAccepted boolean;
        invalidB# boolean;
        invalidClassid boolean;
        classFull boolean;
        studentAlreadyInClass boolean;
        numClassesEnrolledIn int;
        classSemester classes.semester%type;
        classYear classes.year%type;
        B#_in students.B#%type;
        classid_in classes.classid%type;
        currentPrereqFound boolean;
        prereqsSatisfied boolean;
        begin
                enrollmentAccepted := true;
                invalidB# := true;
                invalidClassid := true;
                classFull := false;
                studentAlreadyInClass := false;
                numClassesEnrolledIn := 0;
                B#_in := B#;
                classid_in := classid;

                for row in (select B# from students) -- Loop through each student in students table
                loop
                        if(row.B# = B#) then   -- If the B# passed into enroll_student is found, the B# is valid 
                                invalidB# := false;
                        end if;
                end loop;

                for row in (select * from classes) -- Loop through each class in classes table
                loop
                        if(row.classid = classid) then   -- If the classid passed into enroll_student is found, the classid is valid
                                invalidClassid := false;
                                classSemester := row.semester;
                                classYear := row.year;
                                if(row.class_size + 1 > row.limit) then  -- If adding student to the class would cause the class_size > limit, the class is full
                                        classFull := true;
                                end if;
                        end if;
                end loop;

                for row in (select * from enrollments)  -- Loop through each enrollment
                loop
                        if(row.B# = B# and row.classid = classid) then  -- If B# and classid are found in enrollments table, student is already taking that class
                                studentAlreadyInClass := true;
                        end if;
                end loop;

                if (not invalidClassid and not invalidB#) then
                        select count(*) into numClassesEnrolledIn                 --Count the number of classes that the student is taking in the same year and semester
                        from enrollments e join classes c on e.classid=c.classid  --Use this value to check if the student is overloaded.
                        where B#=B#_in and year=classYear and semester=classSemester;
                end if;
        

                prereqsSatisfied := true; 
                for row1 in 
                        (select c.classid, c.dept_code, c.course#                               --All prereqs needed to be able to enroll in the class
                        from classes c join
                                (select *
                                from classes c join prerequisites p
                                on c.dept_code=p.dept_code and c.course#=p.course#
                                where c.classid=classid_in) temp
                        on c.dept_code=temp.pre_dept_code and c.course#=temp.pre_course#)
                loop
                        currentPrereqFound := false;
                        for row2 in
                                (select c.classid, c.dept_code, c.course#,enrolledGrades.ngrade         
                                from classes c join
                                (select *                               -- find all classes and grade info the student has taken
                                from grades g join enrollments e
                                on g.lgrade=e.lgrade
                                where e.B#=B#_in) enrolledGrades
                                on c.classid = enrolledGrades.classid)
                        loop
--                              dbms_output.put_line('row2 class id is: ' || ' ' || row2.classid
--                                      || ' ' || 'row1 class id is: ' || ' ' || row1.classid
--                                      || ' ' || 'row2 ngrade is: ' || row2.ngrade);
                                if (row2.dept_code = row1.dept_code and row2.course# = row1.course# and row2.ngrade >= 2) then   -- check for correct class with C or better grade
--                                      dbms_output.put_line('Class ids match and grade is C or better');
                                        currentPrereqFound := true;
                        --              exit;
                                end if;
                        end loop;
                        if (not currentPrereqFound) then
                                prereqsSatisfied := false;
                        --      exit;
                        end if;
                end loop;

                if (invalidB#) then
                        dbms_output.put_line('The B# is invalid.');
                        enrollmentAccepted := false;
                end if;
                if (invalidClassid) then
                        dbms_output.put_line('The classid is invalid.');
                        enrollmentAccepted := false;
                end if;
                if (classFull) then
                        dbms_output.put_line('The class is full.');
                        enrollmentAccepted := false;
                end if;
                if (studentAlreadyInClass) then
                        dbms_output.put_line('The student is already in the class.');
                        enrollmentAccepted := false;
                end if;
                if (numClassesEnrolledIn = 3) then
                        dbms_output.put_line('You are overloaded.');
                end if;
                if (numClassesEnrolledIn = 4) then
                        dbms_output.put_line('Students cannot be enrolled in more than four classes in the same semester.');
                        enrollmentAccepted := false;
                end if;
                if (not prereqsSatisfied) then
                        dbms_output.put_line('Prerequisite not satisfied.');
                        enrollmentAccepted := false;
                end if;
                if (enrollmentAccepted) then
                        dbms_output.put_line('Enrolling...');
                        insert into enrollments values (B#,classid,null);
                end if;
--              dbms_output.put_line('Student is enrolled in this many classes: ');
--              dbms_output.put_line(numClassesEnrolledIn);
--              dbms_output.put_line(classSemester);
--              dbms_output.put_line(classYear);
        end;

procedure get_class_info(classid in classes.classid%type)
        is
        classIDInvalid boolean;
        classEmpty boolean;
        begin
                classIDInvalid := true;
                classEmpty := true;
                for row1 in 
                        (select cl.classid, co.title
                        from classes cl join courses co
                        on cl.dept_code = co.dept_code and cl.course# = co.course#)
                loop
                        if (row1.classid = classid) then
                                classIDInvalid := false;
                                dbms_output.put_line(row1.classid || ' ' || row1.title);
                                for row2 in
                                        (select e.B#, s.firstname, e.classid
                                        from enrollments e join students s
                                        on e.B# = s.B#)
                                loop
                                        if (row1.classid = row2.classid) then
                                                classEmpty := false;
                                                dbms_output.put_line(row2.B# || ' ' || row2.firstname);
                                        end if;
                                end loop;
                        end if;
                end loop;
                if(not classIDInvalid and classEmpty) then
                        dbms_output.put_line('No student has enrolled in the class.');
                elsif(classIDInvalid) then
                        dbms_output.put_line('The classid is invalid.');
                end if;
        end;

procedure get_prereqs(dept_code in prerequisites.dept_code%type, course# in prerequisites.course#%type)
        is
        begin
                for row in (select * from prerequisites)
                loop
                        if (row.dept_code = dept_code and row.course# = course#) then
                                dbms_output.put_line(row.pre_dept_code || ' ' || row.pre_course#);
                        get_prereqs(row.pre_dept_code, row.pre_course#);
                        end if;
                end loop;               
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

function show_students 
    return ref_cursor
    is
    rc ref_cursor;
    begin
        open rc for
        select * from students;
        return rc;
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
