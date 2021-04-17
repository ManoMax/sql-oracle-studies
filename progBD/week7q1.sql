/*
  Crie um bloco PL/SQL anônimo para recuperar o salário do empregado 101, atribuindo o resultado a uma variável.
  Em seguida, no mesmo bloco, imprima o valor do atributo de cursor implícito %ROWCOUNT.
  Ainda, imprima "aberto" caso o valor de %ISOPEN seja TRUE; "fechado", caso contrário.
  De modo análogo, imprima "encontrou" caso o valor de %ISFOUND seja TRUE; "não encontrou", caso contrário.
  Execute o bloco PL/SQL. Copie e cole o código produzido, bem como o resultado da execução.
*/

DECLARE
    CURSOR e1 IS
    SELECT SALARY FROM OEHR_EMPLOYEES
    WHERE EMPLOYEE_ID = 101;
    salario_emp OEHR_EMPLOYEES.SALARY%TYPE;
BEGIN
    OPEN e1;
    LOOP
        FETCH e1 INTO salario_emp;
        EXIT WHEN e1%NOTFOUND;
        dbms_output.put_line(salario_emp);

        dbms_output.put_line(e1%ROWCOUNT);

        IF (e1%ISOPEN) THEN
        dbms_output.put_line('aberto');
        ELSE
            dbms_output.put_line('fechado');
        END IF;

        IF (e1%FOUND) THEN
            dbms_output.put_line('encontrou');
        ELSE
            dbms_output.put_line('não encontrou');
        END IF;
    END LOOP;
    CLOSE e1;
END;
