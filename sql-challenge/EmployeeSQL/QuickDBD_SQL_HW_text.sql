Titles
rel >- employees
-
create_title_id varchar(50) PK
title varchar(50)




employees
-
emp_no int PK
emp_title_id varchar(50) FK - Titles.create_title_id
birth_date date,
first_name varchar(255)
last_name varchar(255)
sex varchar(20)
hire_date date




departments
-
dept_no varchar(50) PK
dept_name varchar(50)





Department_Employees
-
emp_no int
dept_no varchar(50) FK - departments.dept_no





Salaries
rel >- employees
-
emp_no int PK
salary int





Department_Managers
-
dept_no varcvhar(50) FK - departments.dept_no
emp_no int


