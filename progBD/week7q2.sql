/*
    Crie um bloco PL/SQL anônimo contendo um cursor que recupere o nome dos departamentos e a quantidade de empregados dos departamentos,
    mas apenas dos departamentos com mais de 5 funcionários.
    A cada iteração do laço, imprima o valor do atributo de cursor explícito %ROWCOUNT,
    bem como o nome do departamento e a quantidade de empregados. Use um laço LOOP e a opção %ROWTYPE. Execute o bloco PL/SQL.
    Copie e cole o código produzido, bem como o resultado da execução.
*/

DECLARE
    CURSOR j1 IS
    SELECT d.DEPARTMENT_NAME, COUNT(*) AS NUM_EMPREGADOS
    FROM OEHR_DEPARTMENTS d join OEHR_EMPLOYEES e
    ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
    GROUP BY d.DEPARTMENT_NAME
    HAVING COUNT(*) > 5;

    relacoes j1%ROWTYPE;
BEGIN
    OPEN j1;
    LOOP
        FETCH j1 INTO relacoes;
        EXIT WHEN j1%NOTFOUND;
        dbms_output.put_line(j1%ROWCOUNT || ' - O departamento: ' || relacoes.DEPARTMENT_NAME || ' possui ' || relacoes.NUM_EMPREGADOS || ' empregados.');
    END LOOP;
    CLOSE j1;
END;
