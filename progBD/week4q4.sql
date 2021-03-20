/*
Modifique o bloco PL/SQL que você criou na questão anterior para inserir um novo departamento na tabela DEPARTMENTS.

·        Em vez de imprimir o número do departamento recuperado da questão anterior, adicione 10 a ele e use-o como o número do departamento do novo departamento.

·        Deixe um valor nulo na localização e no número do gerente. Informe o nome do departamento: EDUCATION.

·        Execute o bloco PL/SQL.

·        Com um comando SELECT, exiba o novo departamento criado.

               DEPTNO DNAME      MAN_ID LOC

               ------ ---------- ----- -------

             50 EDUCATION
Copie e cole o código e os resultados.
*/

DECLARE
    V_MAX_DEPTNO NUMBER(4,0);
    NEW_DEPARTMENT OEHR_DEPARTMENTS%ROWTYPE;
    VIEW_DEP OEHR_DEPARTMENTS%ROWTYPE;
BEGIN
    -- Selecionando Departamento com maior ID

    SELECT d.DEPARTMENT_ID
    INTO V_MAX_DEPTNO
    FROM OEHR_DEPARTMENTS d
    WHERE d.DEPARTMENT_ID >= (SELECT MAX(d1.DEPARTMENT_ID) FROM OEHR_DEPARTMENTS d1);

    -- Inserindo um novo Departamento com Maior ID + 10 e nome 'EDUCATION'
    
    INSERT INTO OEHR_DEPARTMENTS VALUES (V_MAX_DEPTNO + 10, 'EDUCATION', NULL, NULL);

    -- Nova consulta do Departamento com maior ID, agora com o novo Departamento na Tabela

    SELECT *
    INTO VIEW_DEP
    FROM OEHR_DEPARTMENTS dep
    WHERE dep.DEPARTMENT_ID >= (SELECT MAX(d2.DEPARTMENT_ID) FROM OEHR_DEPARTMENTS d2);

    -- Visualizando o resultado da ultima consulta

    dbms_output.put_line('DEPTNO: ' || VIEW_DEP.DEPARTMENT_ID || ' DNAME: ' || VIEW_DEP.DEPARTMENT_NAME || ' MAN_ID: ' || VIEW_DEP.MANAGER_ID || ' LOC: ' || VIEW_DEP.LOCATION_ID);

    DELETE FROM OEHR_DEPARTMENTS dep1 WHERE dep1.DEPARTMENT_ID > 270;
END;
