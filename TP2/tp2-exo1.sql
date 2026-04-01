-- Q1
SELECT dept_name
FROM department
WHERE budget IN (SELECT MAX(budget) FROM department);

-- Q2
SELECT A.name, A.salary
FROM teacher A
WHERE A.salary > (SELECT AVG(B.salary) FROM teacher B);

-- Q3
SELECT teacher.name, student.name, COUNT(*)
FROM teacher, student, takes, teaches
WHERE teacher.ID = teaches.ID
AND student.ID = takes.ID
AND (takes.course_id, takes.sec_id, takes.semester, takes.year)
  = (teaches.course_id, teaches.sec_id, teaches.semester, teaches.year)
GROUP BY teacher.name, student.name
HAVING COUNT(*) >= 2;

-- Q4
SELECT T.teachername, T.studentname, T.totalcount
FROM (
    SELECT teacher.name AS teachername, student.name AS studentname, COUNT(*) AS totalcount
    FROM teacher, student, takes, teaches
    WHERE teacher.ID = teaches.ID
    AND student.ID = takes.ID
    AND (takes.course_id, takes.sec_id, takes.semester, takes.year)
      = (teaches.course_id, teaches.sec_id, teaches.semester, teaches.year)
    GROUP BY teacher.name, student.name
) T
WHERE T.totalcount >= 2
ORDER BY T.teachername;

-- Q5
(SELECT student.ID, student.name FROM student)
EXCEPT
(SELECT student.ID, student.name FROM student, takes
 WHERE takes.ID = student.ID AND takes.year < 2010);

-- Q6
SELECT * FROM teacher WHERE name LIKE 'E%';

-- Q7
SELECT name
FROM teacher T1
WHERE 3 = (
    SELECT COUNT(DISTINCT T2.salary) FROM teacher T2
    WHERE T2.salary > T1.salary
);

-- Q8
SELECT T1.name, T1.salary
FROM teacher T1
WHERE 2 >= (
    SELECT COUNT(DISTINCT T2.salary) FROM teacher T2
    WHERE T2.salary < T1.salary
)
ORDER BY T1.salary ASC;

-- Q9
SELECT S.name
FROM student S
WHERE ('Fall', 2009) IN (
    SELECT semester, year FROM takes WHERE takes.ID = S.ID
);

-- Q10
SELECT S.name
FROM student S
WHERE ('Fall', 2009) = SOME (
    SELECT semester, year FROM takes WHERE takes.ID = S.ID
);

-- Q11
SELECT DISTINCT student.name
FROM takes NATURAL INNER JOIN student
WHERE takes.semester = 'Fall' AND takes.year = 2009;

-- Q12
SELECT name
FROM student
WHERE EXISTS (
    SELECT * FROM takes
    WHERE takes.ID = student.ID
    AND semester = 'Fall' AND year = 2009
);

-- Q13
SELECT A.name, B.name
FROM (student NATURAL INNER JOIN takes) A,
     (student NATURAL INNER JOIN takes) B
WHERE A.course_id = B.course_id
AND A.sec_id = B.sec_id
AND A.semester = B.semester
AND A.year = B.year
AND A.ID <> B.ID
AND A.name < B.name
GROUP BY A.ID, B.ID, A.name, B.name
HAVING COUNT(*) >= 1;

-- Q14
SELECT teacher.name, COUNT(*)
FROM (takes INNER JOIN teaches USING (course_id, sec_id, semester, year))
INNER JOIN teacher ON teaches.ID = teacher.ID
GROUP BY teacher.name, teacher.ID
ORDER BY COUNT(*) DESC;

-- Q15
SELECT teacher.name, COUNT(course_id)
FROM (takes INNER JOIN teaches USING (course_id, sec_id, semester, year))
RIGHT OUTER JOIN teacher ON teaches.ID = teacher.ID
GROUP BY teacher.name, teacher.ID
ORDER BY COUNT(course_id) DESC;

-- Q16
WITH mytakes (ID, course_id, sec_id, semester, year, grade) AS (
    SELECT ID, course_id, sec_id, semester, year, grade
    FROM takes WHERE grade = 'A'
)
SELECT teacher.name, COUNT(course_id)
FROM (mytakes INNER JOIN teaches USING (course_id, sec_id, semester, year))
RIGHT OUTER JOIN teacher ON teaches.ID = teacher.ID
GROUP BY teacher.name, teacher.ID
ORDER BY COUNT(course_id) DESC;

-- Q17
SELECT teacher.name, student.name, COUNT(*)
FROM (teacher NATURAL JOIN teaches)
INNER JOIN (takes NATURAL JOIN student)
USING (course_id, sec_id, semester, year)
GROUP BY teacher.name, student.name;

-- Q18
SELECT mytable.tn, mytable.sn
FROM (
    SELECT teacher.name AS tn, student.name AS sn, COUNT(*) AS tc
    FROM (teacher NATURAL JOIN teaches)
    INNER JOIN (takes NATURAL JOIN student)
    USING (course_id, sec_id, semester, year)
    GROUP BY teacher.name, student.name
) mytable
WHERE tc >= 2;