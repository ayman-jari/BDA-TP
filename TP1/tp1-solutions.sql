
set colsep '| '
set linesize 200
set pagesize 20

-- == FONCTIONS SQL ==

-- TO_CHAR : convertit une date ou un nombre en chaine de caracteres
SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY') FROM DUAL;

-- RPAD : complete une chaine a droite jusqu'a une longueur donnee
SELECT RPAD('Hello', 10, '-') FROM DUAL;

-- LPAD : complete une chaine a gauche jusqu'a une longueur donnee
SELECT LPAD('42', 6, '0') FROM DUAL;

-- SUBSTR : extrait une sous-chaine a partir d'une position
SELECT SUBSTR('Hello', 2, 3) FROM DUAL;

-- LENGTH : retourne la longueur d'une chaine
SELECT LENGTH('Hello') FROM DUAL;

-- ROUND : arrondit un nombre a n decimales
SELECT ROUND(3.14159, 2) FROM DUAL;

-- TRUNC : tronque un nombre a n decimales sans arrondir
SELECT TRUNC(3.99, 0) FROM DUAL;

-- TO_DATE : convertit une chaine en date
SELECT TO_DATE('01/01/2024', 'DD/MM/YYYY') FROM DUAL;

-- EXTRACT : extrait une partie d'une date (annee, mois, jour)
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;


-- == EXERCICE 1 ==

-- Q4 : Insertion du cours BIO-101
INSERT INTO course VALUES ('BIO-101', 'Intro. to Biology', 'Biology', 4);
COMMIT;


-- == EXERCICE 2 ==

-- Q1
DESC section;
SELECT * FROM section;

-- Q2
SELECT * FROM course;

-- Q3
SELECT title, dept_name FROM course;

-- Q4
SELECT dept_name, budget FROM department;

-- Q5
SELECT name, dept_name FROM teacher;

-- Q6
SELECT name FROM teacher WHERE salary > 65000;

-- Q7
SELECT name FROM teacher WHERE salary BETWEEN 55000 AND 85000;

-- Q8
SELECT DISTINCT dept_name FROM teacher;

-- Q9
SELECT name FROM teacher
WHERE salary > 65000 AND dept_name = 'Comp. Sci.';

-- Q10
SELECT * FROM section WHERE semester = 'Spring' AND year = 2010;

-- Q11
SELECT title FROM course
WHERE dept_name = 'Comp. Sci.' AND credits > 3;

-- Q12
SELECT teacher.name, teacher.dept_name, department.building
FROM teacher, department
WHERE teacher.dept_name = department.dept_name;

-- Q13
SELECT DISTINCT student.name
FROM student, takes, course
WHERE student.ID = takes.ID
AND takes.course_id = course.course_id
AND course.dept_name = 'Comp. Sci.';

-- Q14
SELECT DISTINCT student.name
FROM student, teacher, takes, teaches
WHERE student.ID = takes.ID
AND takes.course_id = teaches.course_id
AND takes.sec_id = teaches.sec_id
AND takes.semester = teaches.semester
AND takes.year = teaches.year
AND teaches.ID = teacher.ID
AND teacher.name = 'Einstein';

-- Q15
SELECT teacher.name, teaches.course_id
FROM teacher, teaches
WHERE teacher.ID = teaches.ID;

-- Q16
SELECT takes.course_id, takes.sec_id, takes.semester, takes.year, COUNT(*)
FROM takes
WHERE takes.semester = 'Spring' AND takes.year = 2010
GROUP BY takes.course_id, takes.sec_id, takes.semester, takes.year;

-- Q17
SELECT dept_name, MAX(salary) FROM teacher GROUP BY dept_name;

-- Q18
SELECT takes.course_id, takes.sec_id, takes.semester, takes.year, COUNT(*)
FROM takes
GROUP BY takes.course_id, takes.sec_id, takes.semester, takes.year;

-- Q19
SELECT building, COUNT(*) FROM section
WHERE (semester = 'Fall' AND year = 2009) OR (semester = 'Spring' AND year = 2010)
GROUP BY building;

-- Q20
SELECT department.dept_name, COUNT(*)
FROM section, department, teacher, teaches
WHERE section.course_id = teaches.course_id
AND section.sec_id = teaches.sec_id
AND section.semester = teaches.semester
AND section.year = teaches.year
AND teaches.ID = teacher.ID
AND teacher.dept_name = department.dept_name
AND department.building = section.building
GROUP BY department.dept_name;

-- Q21
SELECT course.title, teacher.name
FROM section, teacher, teaches, course
WHERE section.course_id = teaches.course_id
AND section.sec_id = teaches.sec_id
AND section.semester = teaches.semester
AND section.year = teaches.year
AND teaches.ID = teacher.ID
AND section.course_id = course.course_id
ORDER BY course.title;

-- Q22
SELECT semester, COUNT(*) FROM section GROUP BY semester;

-- Q23
SELECT student.name, SUM(course.credits)
FROM student, course, takes
WHERE student.ID = takes.ID
AND takes.course_id = course.course_id
AND student.dept_name != course.dept_name
GROUP BY student.name;

-- Q24
SELECT department.dept_name, SUM(course.credits)
FROM section, course, department
WHERE section.course_id = course.course_id
AND course.dept_name = department.dept_name
GROUP BY department.dept_name;