/*
  Crie uma tabela chamada SINTETICA com as colunas codigo (PRIMARY KEY) INTEGER, nome VARCHAR2(10), nascimento DATE e sexo CHAR(1).
  Crie um bloco PL/SQL anônimo para inserir 500 linhas na tabela criada. O povoamento das colunas deve obedecer as seguintes regras:
  
    - codigo: valor do contador

    - nome: se contador for par, deve ser Mr. <valor do contador>. Caso contrário, Mrs. <valor do contador>

    - nascimento: data atual - valor do contador

    - sexo: se contador for par, deve ser M. Caso contrário, F.

Execute o bloco criado. Execute uma consulta para mostrar a quantidade de valores distintos na coluna nome.
Copie e cole o código gerado, bem como os resultados.
*/

-- Para reutilizar o código, no mesmo script, basta descomentar a linha abaixo:
-- DROP TABLE SINTETICA;

CREATE TABLE SINTETICA (
    codigo INTEGER,
	nome VARCHAR2(10),
	nascimento DATE,
	sexo CHAR(1),

    CONSTRAINT cod_sintetica
	PRIMARY KEY (codigo)
);

DECLARE
    nome_aux VARCHAR2(10);
    cod INTEGER;
    nome_aux2 VARCHAR2(10);
BEGIN
    FOR i IN 1..500 LOOP
        IF MOD(i,2) = 0 THEN
            nome_aux := ('Mr. ' || i);
            INSERT INTO SINTETICA VALUES (i, nome_aux, SYSDATE - i, 'M');
        ELSE
            nome_aux := ('Mrs. ' || i);
            INSERT INTO SINTETICA VALUES (i, nome_aux, SYSDATE - i, 'F');
        END IF;
    END LOOP;

    cod := 1;
    WHILE cod <= 500 LOOP
        SELECT nome
        INTO nome_aux2
        FROM SINTETICA
        WHERE codigo = cod;

        dbms_output.put_line('A pessoa do código: ' || cod || ', chama-se: ' || nome_aux2);
        cod := cod + 1;
    END LOOP;
END;
