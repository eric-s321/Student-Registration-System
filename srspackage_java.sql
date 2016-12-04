set serveroutput on


create or replace package srs_java as
type ref_cursor is ref cursor;
function delete_student(B#_in in students.B#%type)
        return varchar2;
function drop_class(B# in students.B#%type, classid in classes.classid%type)
        return varchar2;
function enroll_student(B# in students.B#%type, classid in classes.classid%type)
        return varchar2;
function get_class_info(classid_in in classes.classid%type)
        return ref_cursor;
function get_class_info_helper(classid in classes.classid%type)
        return varchar2;
function get_prereqs(dept_code_in in prerequisites.dept_code%type, course#_in in prerequisites.course#%type)
        return ref_cursor;
function get_prereqs_helper(dept_code in prerequisites.dept_code%type, course# in prerequisites.course#%type)
        return varchar2;
function find_student_class_info(B#_in in students.B#%type) --Lists every class a student has taken with grade info
        return ref_cursor;
function find_student_class_helper(B#_in in students.B#%type)
        return varchar2;  
function show_students
        return ref_cursor;
function test_func
        return varchar2;
function show_courses
        return ref_cursor;
function show_course_credit
        return ref_cursor;
function show_prerequisites
        return ref_cursor;
function show_classes
        return ref_cursor;
function show_enrollments
        return ref_cursor;
function show_grades
        return ref_cursor;
function show_logs
        return ref_cursor;
end;
/


create or replace package body srs_java as

function delete_student(B#_in in students.B#%type)
        return varchar2
    is
        error_message varchar2(50);     
    invalidB# boolean;
    begin
                error_message := '';
        invalidB# := true;
        for row in (select B# from students) -- Loop through each student in students table
        loop
            if(row.B# = B#_in) then   -- If the B# passed into delete_student is found, the B# is valid
                invalidB# := false;
            end if;
        end loop;

        if invalidB# then           --If B# was invalid output message about it
            error_message := 'The B# is invalid.';
        else                        --Valid B#, proceed to delete student
            delete from students      --Delete student from the students table
            where B# = B#_in;
        end if;
        return error_message;
    end;

function drop_class(B# in students.B#%type, classid in classes.classid%type)
        return varchar2
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
        error_message varchar2(200);
        begin
                error_message := '';
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
                        end loop;
                end if;
                                
                if (invalidB#) then
                        error_message := error_message || 'The B# is invalid.' || chr(10);
                        allowClassDrop := false;
                end if;
                if (invalidClassid) then
                        error_message := error_message || 'The classid is invalid.' || chr(10);
                        allowClassDrop := false;
                end if;
                if (not studentInClass and not invalidB# and not invalidClassid) then           --Check all 3 conditions because if invalid B# or invalid classid class info  
                        error_message := error_message || 'The student is not enrolled in the class.' || chr(10);      --will not be found in enrollments table
                        allowClassDrop := false;
                end if;
                if (enrolledClasses = 1 and studentInClass) then
                        error_message := error_message || 'This student is no longer enrolled in any classes' || chr(10);
                end if;
                if (classSize = 1 and studentInClass) then
                        error_message := error_message || 'The class now has no students.' || chr(10);
                end if;
                if (not prereqsOK) then
                        error_message := error_message || 'The drop is not permitted because another class uses it as a prerequisite' || chr(10);
                        allowClassDrop := false;
                end if;
                if (allowClassDrop) then
                        delete from enrollments
                        where B# = B#_in and classid = classid_in;                      
                end if;
                return error_message;
        end;

function enroll_student(B# in students.B#%type, classid in classes.classid%type)
        return varchar2
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
        error_message varchar2(200);
        begin
                error_message := '';
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
                                if (row2.dept_code = row1.dept_code and row2.course# = row1.course# and row2.ngrade >= 2) then   -- check for correct class with C or better grade
                                        currentPrereqFound := true;  --class ids match and grade is C or better
                                end if;
                        end loop;
                        if (not currentPrereqFound) then
                                prereqsSatisfied := false;
                        end if;
                end loop;

                if (invalidB#) then
                        error_message := error_message || 'The B# is invalid.' || chr(10); 
                        enrollmentAccepted := false;
                end if;
                if (invalidClassid) then
                        error_message := error_message || 'The classid is invalid.' || chr(10);
                        enrollmentAccepted := false;
                end if;
                if (classFull) then
                        error_message := error_message || 'The class is full.' || chr(10);
                        enrollmentAccepted := false;
                end if;
                if (studentAlreadyInClass) then
                        error_message := error_message || 'The student is already in the class.' || chr(10);
                        enrollmentAccepted := false;
                end if;
                if (numClassesEnrolledIn = 3) then
                        error_message := error_message || 'You are overloaded.' || chr(10);
                end if;
                if (numClassesEnrolledIn = 4) then
                        error_message := error_message || 'Students cannot be enrolled in more than four classes in the same semester.'  || chr(10);
                        enrollmentAccepted := false;
                end if;
                if (not prereqsSatisfied) then
                        error_message := error_message || 'Prerequisite not satisfied.'  || chr(10);
                        enrollmentAccepted := false;
                end if;
                if (enrollmentAccepted) then
                        insert into enrollments values (B#, classid, null);
                end if;
                return error_message;
        end;

function get_class_info_helper(classid in classes.classid%type)
        return varchar2
        is
        error_message varchar2(100);    
        classIDInvalid boolean;
        classEmpty boolean;
        begin
                error_message := '';
                classIDInvalid := true;
                classEmpty := true;
                for row1 in 
                        (select cl.classid, co.title
                        from classes cl join courses co
                        on cl.dept_code = co.dept_code and cl.course# = co.course#)
                loop
                        if (row1.classid = classid) then
                                classIDInvalid := false;
                                for row2 in
                                        (select e.B#, s.firstname, e.classid
                                        from enrollments e join students s
                                        on e.B# = s.B#)
                                loop
                                        if (row1.classid = row2.classid) then
                                                classEmpty := false;
                                        end if;
                                end loop;
                        end if;
                end loop;
                if(not classIDInvalid and classEmpty) then
                        error_message := 'No student has enrolled in the class.';
                elsif(classIDInvalid) then
                        error_message := 'The classid is invalid.';
                end if;
                return error_message;
        end;

function get_class_info(classid_in in classes.classid%type)
        return ref_cursor
        is
        rc ref_cursor;
        begin
                open rc for
                        select cl.classid, co.title, s.B#, s.firstname
                        from    
                        classes cl join courses co
                        on cl.dept_code=co.dept_code and cl.course#=co.course#
                        join enrollments e
                        on e.classid = cl.classid
                        join students s
                        on s.B# = e.B#
                        where cl.classid = classid_in;
--                      select cl.classid, co.title, e.B#, s.firstname. e.classid
--                      from classes cl join courses co join enrollments e join students s
--                      on cl.dept_code = co.dept_code and cl.course# = co.course#
--                      and e.B# = s.B#
--                      where classid = classid_in;
                return rc;
        end;

function get_prereqs_helper(dept_code in prerequisites.dept_code%type, course# in prerequisites.course#%type)  --Check if dept_code and course# combination is valid
        return varchar2
        is
        validCourse boolean;
        error_message varchar2(50);
        begin
                validCourse := false;
                error_message := '';
                for row in (select * from courses)
                loop
                        if (row.dept_code = dept_code and row.course# = course#) then   --User entered a valid course
                                validCourse := true;
                        end if;
                end loop;
                if (not validCourse) then                       --User entered bad data
                        error_message := 'The dept_code and course# combination is not valid';
                end if;
                return error_message;
        end;

function get_prereqs(dept_code_in in prerequisites.dept_code%type, course#_in in prerequisites.course#%type)    --Get all prereqs (indirect and direct) of a given course
        return ref_cursor
        is
        rc ref_cursor;
        begin
                open rc         
                for
                        select pre_dept_code, pre_course#
                        from prerequisites
                        start with dept_code=dept_code_in and course#=course#_in                --Use heirarchy query to find indirect prereqs
                        connect by prior pre_dept_code=dept_code and prior pre_course#=course#;   --look for the prereqs of prereqs
                return rc;
        end;


function find_student_class_helper(B#_in in students.B#%type)   --Checks for problems with input for find_student_class_info
        return varchar2
        is
        error_message varchar2(100);
        classInfoFound boolean;
        isAStudent boolean;
        begin
                error_message := '';
        classInfoFound := false;
        isAStudent := false;
        for row in
            (select e.B#, c.classid, c.dept_code, c.course#, c.sect#, c.year, c.semester, g.lgrade, g.ngrade
            from enrollments e, classes c, grades g
            where e.classid=c.classid and e.lgrade=g.lgrade)
        loop
            if (row.B# = B#_in) then            --Student has taken at least one class
                classInfoFound := true;
                                exit;
            end if;
        end loop;
        for row in (select * from students)
        loop
            if(row.B# = B#_in) then                             -- a valid B# has been entered
                isAStudent := true;
                exit;
            end if;
        end loop;
        if (isAStudent and not classInfoFound) then
                        error_message := 'The student has not taken any course.';
        elsif (not isAStudent) then
                        error_message := 'The B# is invalid';
        end if;
                return error_message;
        end;


function find_student_class_info(B#_in in students.B#%type)  --Lists every class a student has taken with grade info
        return ref_cursor
        is
        rc ref_cursor;
        begin
                open rc for
                        select c.classid, c.dept_code, c.course#, c.sect#, c.year, c.semester, g.lgrade, g.ngrade 
                        from enrollments e, classes c, grades g 
                        where e.classid=c.classid and e.lgrade=g.lgrade and e.B#=B#_in;
                return rc;
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

function test_func
        return varchar2
        is
        output varchar2(500);
        begin
                output := 'Testing, Testing, 1 2 3';
                return output;
        end;

function show_courses
        return ref_cursor
        is
        rc ref_cursor;
        begin
                open rc for
                        select * from courses;
                return rc;
        end;

function show_course_credit
        return ref_cursor
        is
        rc ref_cursor;
        begin
                open rc for
                        select * from course_credit;
                return rc;
        end;

function show_prerequisites
        return ref_cursor
        is
        rc ref_cursor;
        begin
                open rc for
                        select * from prerequisites;
                return rc;
        end;

function show_classes
        return ref_cursor
        is
        rc ref_cursor;
        begin
                open rc for
                        select * from classes;
                return rc;
        end;

function show_enrollments
        return ref_cursor
        is
        rc ref_cursor;
        begin
                open rc for
                        select * from enrollments;
                return rc;
        end;

function show_grades
        return ref_cursor
        is
        rc ref_cursor;
        begin
                open rc for
                        select * from grades;
                return rc;
        end;

function show_logs
        return ref_cursor
        is
        rc ref_cursor;
        begin
                open rc for
                        select * from logs;
                return rc;
        end;

end;
/
