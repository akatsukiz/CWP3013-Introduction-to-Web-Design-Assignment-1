ACCEPT c_term CHAR prompt 'Please enter Term (Eg:sp97): ';
ACCEPT c_lineno NUMBER prompt 'Please enter Line No (Eg:1031): ';
ACCEPT c_sno CHAR prompt'Please enter Subject No (Eg:csc227): ';
ACCEPT c_A NUMBER prompt'Please enter Grade A Values (Between 0-100): ';
ACCEPT c_B NUMBER prompt'Please enter Grade B Values (Between 0-100): ';
ACCEPT c_C NUMBER prompt'Please enter Grade C Values (Between 0-100): ';
ACCEPT c_D NUMBER prompt'Please enter Grade D Values (Between 0-100): ';

BEGIN
	add_course('&c_term', '&c_lineno', '&c_sno', '&c_A', '&c_B', '&c_C', '&c_D');
END;
/