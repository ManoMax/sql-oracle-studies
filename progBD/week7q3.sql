/*
    Reescreva o código da questão anterior usando um laço FOR. Execute o bloco PL/SQL.
    Copie e cole o código produzido, bem como o resultado da execução.
*/

DECLARE
    CURSOR j1 IS
    SELECT d.DEPARTMENT_NAME, COUNT(*) AS NUM_EMPREGADOS
    FROM OEHR_DEPARTMENTS d join OEHR_EMPLOYEES e
    ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
    GROUP BY d.DEPARTMENT_NAME
    HAVING COUNT(*) > 5;

    -- relacoes j1%ROWTYPE;
BEGIN
    FOR i IN j1 LOOP
        dbms_output.put_line(j1%ROWCOUNT || ' - O departamento ' || i.DEPARTMENT_NAME || ' possui ' || i.NUM_EMPREGADOS || ' empregados.');    
    END LOOP;
END;
