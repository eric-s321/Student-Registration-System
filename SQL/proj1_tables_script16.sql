drop table enrollments;
drop table grades;
drop table classes;
drop table faculty;
drop table course_credit;
drop table prerequisites;
drop table courses;
drop table students;
drop table logs;
--drop sequence logSeq;
--drop trigger increase_class_size;
--drop trigger reduce_class_size;
--drop trigger delete_enrollments_of_student;
--drop trigger student_log;

create table students (B# char(4) primary key check (B# like 'B%'),
firstname varchar2(15) not null, lastname varchar2(15) not null, status varchar2(10) 
check (status in ('freshman', 'sophomore', 'junior', 'senior', 'MS', 'PhD')), 
gpa number(3,2) check (gpa between 0 and 4.0), email varchar2(20) unique,
bdate date, deptname varchar2(4) not null);

create table courses (dept_code varchar2(4) not null, course# number(3) not null
check (course# between 100 and 799), title varchar2(20) not null,
primary key (dept_code, course#));

create table course_credit (course# number(3) not null primary key
check (course# between 100 and 799), credits number(1) check (credits in (3, 4)),
check ((course# < 500 and credits = 4) or (course# >= 500 and credits = 3)));

create table faculty (B# char(4) primary key check (B# like 'B%'), 
firstname varchar2(15) not null, lastname varchar2(15) not null, 
rank varchar2(20) check (rank in ('lecturer', 'assistant professor', 
'associate professor', 'professor')), office varchar2(10), 
email varchar2(20) unique, phone# char(8) unique, deptname varchar2(5) not null);

create table classes (classid char(5) primary key check (classid like 'c%'), 
dept_code varchar2(4) not null, course# number(3) not null, 
sect# number(2), year number(4), semester varchar2(8) 
check (semester in ('Spring', 'Fall', 'Summer 1', 'Summer 2')), limit number(3), 
class_size number(3),
foreign key (dept_code, course#) references courses on delete cascade, 
unique(dept_code, course#, sect#, year, semester), check (class_size <= limit));

create table grades(lgrade varchar2(2) not null check (lgrade in ('A', 'A-', 'B+', 'B', 
'B-', 'C+', 'C', 'C-','D', 'F', 'I')) primary key,
ngrade number(2,1) check (ngrade in (4, 3.7, 3.3, 3, 2.7, 2.3, 2, 1.7, 1, 0, null)),
check ((lgrade = 'A' and ngrade = 4) or (lgrade = 'A-' and ngrade = 3.7) or 
(lgrade = 'B+' and ngrade = 3.3) or (lgrade = 'B' and ngrade = 3) or  
(lgrade = 'B-' and ngrade = 2.7) or (lgrade = 'C+' and ngrade = 2.3) or 
(lgrade = 'C' and ngrade = 2) or (lgrade = 'C-' and ngrade = 1.7) or 
(lgrade = 'D' and ngrade = 1) or (lgrade = 'F' and ngrade = 0) or  
(lgrade = 'I' and ngrade = null)));

create table enrollments (B# char(4) references students, classid char(5) references classes, 
lgrade varchar2(2) references grades, primary key (B#, classid));

create table prerequisites (dept_code varchar2(4) not null,
course# number(3) not null, pre_dept_code varchar2(4) not null,
pre_course# number(3) not null,
primary key (dept_code, course#, pre_dept_code, pre_course#),
foreign key (dept_code, course#) references courses on delete cascade,
foreign key (pre_dept_code, pre_course#) references courses on delete cascade);

create table logs (logid number(4) primary key, who varchar2(10) not null, time date not null,
table_name varchar2(12) not null, operation varchar2(6) not null, key_value varchar2(10));


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

insert into faculty values ('B101', 'Mike', 'Jackson', 'professor', 'EB P80', 'jackson@bu.edu', '777-1111', 'CS');
insert into faculty values ('B102', 'Susan', 'Liu', 'associate professor', 'EB P81', 'liu@bu.edu', '777-2222', 'CS');
insert into faculty values ('B103', 'Lisa', 'Coleman', 'professor', 'LN C12', 'coleman@bu.edu', '777-3333', 'Math');
insert into faculty values ('B104', 'Peter', 'Lewis', 'lecturer', 'EB P83', 'lewis@bu.edu', '777-4444', 'CS');
insert into faculty values ('B105', 'Joe', 'Jordan', 'assistant professor', 'LN C23', 'jordan@bu.edu', '777-5555', 'Math');

insert into classes values ('c0001', 'CS', 432, 1, 2016, 'Spring', 35, 34);
insert into classes values ('c0002', 'Math', 314, 1, 2015, 'Fall', 25, 24);
insert into classes values ('c0003', 'Math', 314, 2, 2015, 'Fall', 25, 22);
insert into classes values ('c0004', 'CS', 432, 1, 2015, 'Spring', 30, 30);
insert into classes values ('c0005', 'CS', 240, 1, 2016, 'Spring', 40, 39);
insert into classes values ('c0006', 'CS', 532, 1, 2016, 'Spring', 29, 28);
insert into classes values ('c0007', 'Math', 221, 1, 2016, 'Spring', 30, 30);

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

insert into prerequisites values ('CS', 432, 'CS', 240);
insert into prerequisites values ('CS', 432, 'Math', 221);
insert into prerequisites values ('Math', 314, 'Math', 221);
insert into prerequisites values ('CS', 532, 'Math', 221);
insert into prerequisites values ('CS', 532, 'CS', 240);
insert into prerequisites values ('Math', 221, 'Biol', 425);



