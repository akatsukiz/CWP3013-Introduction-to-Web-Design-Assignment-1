CREATE OR REPLACE VIEW student_course_average AS
SELECT 
	REPLACE(REPLACE(REPLACE(e.term, 'f', 'Fall-'), 'sp', 'Spring-'), 's', 'Summer-') AS Term, 
	e.lineno AS "Line No", 
	e.sid AS "Student ID", 
	s.lname AS "Last Name", 
	s.fname AS "First Name", 
	ROUND((SUM(sc.points * com.weight)/SUM(com.weight*com.maxpoints))*100) AS "Course Average"
FROM enrolls e
JOIN students s ON e.sid = s.sid
JOIN scores sc ON e.term = sc.term AND e.lineno = sc.lineno AND e.sid = sc.sid
JOIN components com ON e.term = com.term AND e.lineno = com.lineno AND sc.compname = com.compname
WHERE e.term = '&1' AND e.lineno = '&2'
GROUP BY e.term, e.lineno, e.sid, s.lname, s.fname
/	