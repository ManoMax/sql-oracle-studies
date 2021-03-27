*/
Conecte-se ao Oracle Apex (https://apex.oracle.com/i/index.html). Crie um bloco anônimo que recupere o sobrenome (last_name) e o email do empregado 101, bem como o nome do seu departamento. Os valores recuperados devem ser atribuídos a um registro. Imprima os valores na tela no seguinte formato:

Last_name: Kochhar

Email: NKOCHHAR@store.com

Department_name: Executive

Copie e cole o código-fonte e o resultado da execução do bloco.
*/

DECLARE
    ultimo_nome	VARCHAR2(25);
    email_emp VARCHAR2(25);
    id_dep NUMBER(4,0);
    nome_dep VARCHAR2(30);
BEGIN
    SELECT LAST_NAME
    INTO ultimo_nome
    FROM OEHR_EMPLOYEES e
    WHERE e.EMPLOYEE_ID = 101;

    SELECT EMAIL
    INTO email_emp
    FROM OEHR_EMPLOYEES e
    WHERE e.EMPLOYEE_ID = 101;

    SELECT DEPARTMENT_ID
    INTO id_dep
    FROM OEHR_EMPLOYEES e
    WHERE e.EMPLOYEE_ID = 101;

    SELECT DEPARTMENT_NAME
    INTO nome_dep
    FROM OEHR_DEPARTMENTS d
    WHERE d.DEPARTMENT_ID = id_dep;

    dbms_output.put_line('Last_name: ' || ultimo_nome);
    dbms_output.put_line('Email: ' || email_emp);
    dbms_output.put_line('Department_name: ' || nome_dep);
END;
