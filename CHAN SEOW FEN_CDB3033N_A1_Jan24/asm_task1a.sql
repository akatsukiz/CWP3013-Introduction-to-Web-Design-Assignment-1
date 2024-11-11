SELECT 
	s.sno AS "Subject No", 
	UPPER(s.stitle) AS "Subject Title", 
	REPLACE(REPLACE(REPLACE(c.term, 'f', 'Fall-'), 'sp', 'Spring-'), 's', 'Summer-') AS Term, 
	INITCAP(com.compname) AS "Component Name", 
	com.maxpoints AS Maxpoints, 
	com.weight AS Weight
FROM courses c
JOIN subject s ON s.sno = c.sno
JOIN components com ON com.term = c.term AND com.lineno = c.lineno
WHERE c.term = '&term' AND com.weight >= '&min_weight'
/