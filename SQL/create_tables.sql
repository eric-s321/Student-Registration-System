drop table enrollments;
drop table grades;
drop table classes;
drop table faculty;
drop table course_credit;
drop table prerequisites;
drop table courses;
drop table students;
drop table logs;

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
