CREATE OR REPLACE PROCEDURE add_course 
(c_term IN VARCHAR2, c_lineno IN NUMBER, c_sno IN VARCHAR2, 
 c_A IN NUMBER, c_B IN NUMBER, c_C IN NUMBER, c_D IN NUMBER) AS

	e_term_error EXCEPTION; --Does not follows Business Rule #1
	PRAGMA EXCEPTION_INIT(e_term_error, -10001); --associate the error code

	e_grade_error_1 EXCEPTION; --Does not follows Business Rule #2 - A > B > C > D
	PRAGMA EXCEPTION_INIT(e_grade_error_1, -20001); --associate the error code
	
	e_grade_error_2 EXCEPTION; --Does not follows Business Rule #2 - Value 0-100
	PRAGMA EXCEPTION_INIT(e_grade_error_2, -20002); --associate the error code


BEGIN
	DBMS_OUTPUT.PUT_LINE('Attempt to insert a new course record.');
	
	--Insert the new record
	INSERT INTO courses VALUES(c_term, c_lineno, c_sno, c_A, c_B, c_C, c_D);
	
	--Business Rule 1: term must be started with "f" (Fall), "sp" (Spring), "s" (Summer)
	--And followed by 2 digits indicating year
	IF NOT REGEXP_LIKE(c_term, '^(f|sp|s)\d{2}$') THEN
		--raise the EXCEPTION
		RAISE e_term_error;
	END IF;
	
	--Business Rule 2: Value of Grade A must bigger than Grade B (minimum gap 10 points)
	--Same for other grades subsequently
	--Grade values must be in the range of 0-100
	IF (c_A<(c_B+10)) OR (c_B<(c_C+10)) OR (c_C<(c_D+10)) THEN
		--raise the EXCEPTION
		RAISE e_grade_error_1;
	END IF;
	
	IF (c_A <0 OR c_A >100) OR (c_B <0 OR c_B >100) OR (c_C <0 OR c_C >100) OR (c_D <0 OR c_D >100) THEN
		--raise the EXCEPTION
		RAISE e_grade_error_2;
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('New course record added!');
	
	COMMIT; --Save the record

EXCEPTION

	WHEN e_term_error THEN --Violate Business Rule
		DBMS_OUTPUT.PUT_LINE('Attempt failed.');
		DBMS_OUTPUT.PUT_LINE('Error code:' || SQLCODE);
		DBMS_OUTPUT.PUT_LINE('The term format is invalid, it should started with "f"(Fall), "sp"(Spring), "s"(Summer) and followed by 2 digits for year indication. Eg:f96');
		ROLLBACK;
	
	WHEN e_grade_error_1 THEN --Violate Business Rule
		DBMS_OUTPUT.PUT_LINE('Attempt failed.');
		DBMS_OUTPUT.PUT_LINE('Error code:' || SQLCODE);
		DBMS_OUTPUT.PUT_LINE('The value for higher grade should be more than the next grade by at least 10 points. Eg: Grade A: 90 points, Grade B: 80 points, Grade C: 70 points, Grade D: 60 points');
		ROLLBACK;
		
	WHEN e_grade_error_2 THEN --Violate Business Rule
		DBMS_OUTPUT.PUT_LINE('Attempt failed.');
		DBMS_OUTPUT.PUT_LINE('Error code:' || SQLCODE);
		DBMS_OUTPUT.PUT_LINE('The grade values must be in the range of 0-100. Eg: Grade A: 95 points');
		ROLLBACK;

	WHEN DUP_VAL_ON_INDEX THEN --Inserting Same Record
		DBMS_OUTPUT.PUT_LINE('Attempt failed.');
		DBMS_OUTPUT.PUT_LINE('The record for term #' || c_term || ' and line no of '||'#' || c_lineno || ' is found in the database!');
		DBMS_OUTPUT.PUT_LINE('Error:' || SQLCODE);
		--DBMS_OUTPUT.PUT_LINE('Message:' || SQLERRM);
		ROLLBACK;

	--All error handlers
	WHEN OTHERS THEN 
		DBMS_OUTPUT.PUT_LINE('Attempt failed.');
		DBMS_OUTPUT.PUT_LINE('Error code:' || SQLCODE);
		DBMS_OUTPUT.PUT_LINE('Error:' || SQLERRM);
		ROLLBACK; --unto the transaction
END;
/