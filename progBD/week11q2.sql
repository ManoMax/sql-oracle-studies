/*
  Adicione ao pacote DDPACK uma função GENERATESTAT para gerar estatísticas sobre todas as tabelas do usuário.
Essas estatísticas incluem informações sobre o número de linhas de uma tabela, a distribuição dos dados, etc.
e são úteis para o Otimizador de Consultas do Oracle.
  A função não recebe parâmetros e deve retornar um inteiro que corresponde ao número de tabelas que tiveram estatísticas geradas.
Para tal, use os comandos ANALYZE TABLE .. GENERATE STATISTICS e EXECUTE IMMEDIATE.
Recrie tanto a especificação quanto o corpo do pacote DDPACK.
Execute a função empacotada GENERATESTAT a partir de um bloco anônimo.
Mostre código e resultado da execução.
*/

-- Tive problemas com a compilação desse programa.
-- Mais uma vez, situações pessoais me atrapalharam,
-- mas, para não ficar em branco, aqui está o resultado do que fiz:

-- Especificação do Pacote:

CREATE OR REPLACE PACKAGE DDPACK IS
    CURSOR o1 (name_of_obj VARCHAR2) IS
        SELECT object_name, status
        FROM user_objects
        WHERE object_type = name_of_obj AND status = 'INVALID';
    CURSOR nomes_tabelas IS 
        SELECT table_name
        FROM user_tables;
    PROCEDURE GETINVALIDOBJ (obj_name VARCHAR); 
    FUNCTION GENERATESTAT RETURN INTEGER;
END DDPACK;

-- Corpo do Pacote:

CREATE OR REPLACE PACKAGE BODY DDPACK IS 
    obj_name VARCHAR2(30);
    obj_status VARCHAR2(7);
    nome_tabela1 VARCHAR2(30);
    
    PROCEDURE GETINVALIDOBJ
    (name_of_obj VARCHAR2) IS
    BEGIN
        OPEN o1 (name_of_obj);
        LOOP
            FETCH o1 INTO obj_name, obj_status;
            EXIT WHEN (o1%NOTFOUND);
            DBMS_OUTPUT.PUT_LINE(obj_name || ' ' || obj_status);
        END LOOP;
        CLOSE o1;
    END GETINVALIDOBJ;

    FUNCTION GENERATESTAT RETURN INTEGER IS
        num_tabelas NUMBER;
        estatistica VARCHAR2(255);
        BEGIN
            num_tabelas := 0;
            OPEN nomes_tabelas;
            LOOP
                FETCH nomes_tabelas INTO nome_tabela1;
                EXIT WHEN (nomes_tabelas%NOTFOUND);
                estatistica := 'ANALYZE TABLE ' || nome_tabela1 || ' COMPUTE STATISTICS';
                EXECUTE IMMEDIATE estatistica;
                num_tabelas := num_tabelas + 1;
            END LOOP;
            CLOSE o1;
        return num_tabelas;
    END GENERATESTAT;    
END DDPACK;
