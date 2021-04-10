/*
    Conecte-se ao Oracle Apex (https://apex.oracle.com/i/index.html).
  Execute um comando SELECT para exibir os valores da coluna department_id da tabela DEPARTMENTS.
  Analise os valores retornados a fim de identificar se existe algum padrão.
  Crie um bloco PL/SQL anônimo que recupere e imprima na tela o nome de todos os departamentos.
  Use um laço WHILE ou LOOP. NÃO use cursor. Execute o bloco. Copie e cole o código gerado bem como os resultados.
*/

-- A partir do código comentado abaixo, foi possível verificar o padrão de que
-- todos os ID's dos Departamentos aumentam de 10 em 10, são menores que 270 e o menor possui o valor inteiro 10.

-- select department_id FROM OEHR_DEPARTMENTS;

DECLARE
    id_max NUMBER := 270;
    id_dep INTEGER;
    nome_dep VARCHAR2(30);
BEGIN
    id_dep := 10;
    WHILE id_dep <= id_max LOOP
        select DEPARTMENT_NAME
        INTO nome_dep
        FROM OEHR_DEPARTMENTS d
        WHERE d.DEPARTMENT_ID = id_dep;
        
        dbms_output.put_line(nome_dep);
        id_dep := id_dep + 10;
    END LOOP;
END;
