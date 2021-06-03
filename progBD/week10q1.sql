/*
Crie um pacote chamado DDPACK contendo uma procedure chamada GETINVALIDOBJ.

  A procedure deve receber como parâmetro um tipo de objeto (e.g. PROCEDURE, FUNCTION, etc.) e
imprimir na tela o nome dos objetos do tipo fornecido como entrada que estão inválidos no banco de dados.
Crie tanto a especificação quanto o corpo do pacote.
Execute a procedure empacotada para listar as funções inválidas, a partir de um bloco anônimo.
Mostre código e resultado da execução.
*/

-- Especificação do Pacote

CREATE OR REPLACE PACKAGE DDPACK IS
    CURSOR o1 (name_of_obj VARCHAR2) IS
        SELECT object_name, status
        FROM user_objects
        WHERE object_type = name_of_obj AND status = 'INVALID';
    PROCEDURE GETINVALIDOBJ
    (name_of_obj VARCHAR2);
END DDPACK;

-- Corpo do Pacote

CREATE OR REPLACE PACKAGE BODY DDPACK IS
    obj_name VARCHAR2(30);
    obj_status VARCHAR2(7);
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
END DDPACK;

-- Execução de Teste 1:

BEGIN
    DDPACK.GETINVALIDOBJ('PROCEDURE');
END;

-- Saída de Teste 1:

TABELASUSUARIO INVALID

-- Execução de Teste 2:

BEGIN
    DDPACK.GETINVALIDOBJ('FUNCTION');
END;

-- Saída de Teste 2:

CATEGORIA INVALID
