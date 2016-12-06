delete from enrollments;
delete from grades;
delete from classes;
delete from prerequisites;
delete course_credit;
delete from courses;
delete from students;
delete from logs;

insert into students values ('B001', 'Anne', 'Broder', 'junior', 3.17, 'broder@bu.edu', '17-JAN-90', 'CS');
insert into students values ('B002', 'Terry', 'Buttler', 'senior', 3.0, 'buttler@bu.edu', '28-MAY-89', 'Math');
insert into students values ('B003', 'Tracy', 'Wang', 'senior', 4.0, 'wang@bu.edu','06-AUG-93', 'CS');
insert into students values ('B004', 'Barbara', 'Callan', 'junior', 2.5, 'callan@bu.edu', '18-OCT-91', 'Math');
insert into students values ('B005', 'Jack', 'Smith', 'MS', 3.2, 'smith@bu.edu', '18-OCT-91', 'CS');
insert into students values ('B006', 'Terry', 'Zillman', 'PhD', 4.0, 'zillman@bu.edu', '15-JUN-88', 'Biol');
insert into students values ('B007', 'Becky', 'Lee', 'senior', 4.0, 'lee@bu.edu', '12-NOV-92', 'CS');
insert into students values ('B008', 'Tom', 'Baker', 'freshman', null, 'baker@bu.edu', '23-DEC-96', 'CS');

insert into courses values ('CS', 432, 'database systems');
insert into courses values ('Math', 314, 'discrete math');
insert into courses values ('CS', 240, 'data structure');
insert into courses values ('Math', 221, 'calculus I');
insert into courses values ('CS', 532, 'database systems');
insert into courses values ('CS', 552, 'operating systems');
insert into courses values ('Biol', 425, 'molecular biology');

insert into course_credit values (432, 4);
insert into course_credit values (314, 4);
insert into course_credit values (240, 4);
insert into course_credit values (221, 4);
insert into course_credit values (532, 3);
insert into course_credit values (552, 3);
insert into course_credit values (425, 4);

insert into classes values ('c0001', 'CS', 432, 1, 2016, 'Spring', 4, 2);
insert into classes values ('c0002', 'Math', 314, 1, 2015, 'Fall', 2, 2);
insert into classes values ('c0003', 'Math', 314, 2, 2015, 'Fall', 2, 1);
insert into classes values ('c0004', 'CS', 432, 1, 2015, 'Spring', 4, 3);
insert into classes values ('c0005', 'CS', 240, 1, 2016, 'Spring', 3, 3);
insert into classes values ('c0006', 'CS', 532, 1, 2016, 'Spring', 4, 3);
insert into classes values ('c0007', 'Math', 221, 1, 2016, 'Spring', 2, 1);

insert into prerequisites values ('Math', '314', 'Math', '221');
insert into prerequisites values ('CS', '432', 'Math', '314');
insert into prerequisites values ('CS', '432', 'CS', '240');
insert into prerequisites values ('CS', '532', 'CS', '432');
insert into prerequisites values ('CS', '552', 'CS', '240');

insert into grades values ('A', 4);
insert into grades values ('A-', 3.7);
insert into grades values ('B+', 3.3);
insert into grades values ('B', 3);
insert into grades values ('B-', 2.7);
insert into grades values ('C+', 2.3);
insert into grades values ('C', 2);
insert into grades values ('C-', 1.7);
insert into grades values ('D', 1);
insert into grades values ('F', 0);
insert into grades values ('I', null);

insert into enrollments values ('B001', 'c0001', 'A');
insert into enrollments values ('B002', 'c0002', 'B');
insert into enrollments values ('B003', 'c0004', 'A');
insert into enrollments values ('B004', 'c0004', 'C');
insert into enrollments values ('B004', 'c0005', 'B+');
insert into enrollments values ('B005', 'c0006', 'B');
insert into enrollments values ('B006', 'c0006', 'A');
insert into enrollments values ('B001', 'c0002', 'C+');
insert into enrollments values ('B003', 'c0005', null);
insert into enrollments values ('B007', 'c0007', 'A');
insert into enrollments values ('B001', 'c0003', 'B');
insert into enrollments values ('B001', 'c0006', 'B-');
insert into enrollments values ('B001', 'c0004', 'A');
insert into enrollments values ('B001', 'c0005', 'B');
insert into enrollments values ('B003', 'c0001', 'I');
