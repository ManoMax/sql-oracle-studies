/*
Crie uma função chamada CALCULATARIFA para computar e retornar o valor total a ser cobrado para os estacionamentos de um proprietário.
O CPF deve ser fornecido como entrada. Um proprietário pode ter mais de um veículo cadastrado.
A taxa a ser cobrada é de R$ 0,10 por cada minuto excedido em cada estacionamento que tenha durado mais de 30 minutos.
Caso o tempo de um estacionamento não tenha excedido 30 minutos a taxa é zero.
Por exemplo, o proprietário de CPF 939387738-98 fez três estacionamentos com duração de 60, 22 e 32 minutos.
O valor total a ser retornado é de 30 (minutos excedidos) * 0,10 (reais) + 0 (minuto excedido) * 0,10 (reais) + 2 (minutos excedidos) * 0,10 (reais) = 3,20 reais.
Trate o caso em que não existe registro de estacionamento para o proprietário informado, retornando uma mensagem de erro.
Crie um bloco PL/SQL anônimo para executar a função CALCULATARIFA e imprimir na tela o resultado retornado.
Mostre o código-fonte e o resultado da execução do bloco anônimo.

(*) Caso ache necessário, crie e popule as tabelas.

Link das tabelas: https://imgur.com/8zkeR1u
*/

-- Instância das tabelas (com inserções):

DROP TABLE REGISTRO;
DROP TABLE VEICULO;
DROP TABLE PROPRIETARIO;

CREATE TABLE PROPRIETARIO (
	id_proprietario INTEGER,
	cpf VARCHAR2(12),
    cobranca NUMBER,

	CONSTRAINT pk_id_proprietario
	PRIMARY KEY (id_proprietario)
);

CREATE TABLE VEICULO (
    id_veiculo INTEGER,
	placa VARCHAR2(8),
	id_proprietario INTEGER,

    CONSTRAINT pk_dono_do_veiculo 
    FOREIGN KEY (id_proprietario) 
    REFERENCES  PROPRIETARIO(id_proprietario),

	CONSTRAINT pk_id_veiculo
	PRIMARY KEY (id_veiculo)
);

CREATE TABLE REGISTRO (
    id_registro INTEGER,
    id_veiculo INTEGER,
    data_uso DATE,
    permanencia INTEGER,

    CONSTRAINT pk_registro_do_veiculo
    FOREIGN KEY (id_veiculo) 
    REFERENCES  VEICULO(id_veiculo),

	CONSTRAINT pk_id_registro
	PRIMARY KEY (id_registro)
);

INSERT INTO PROPRIETARIO(id_proprietario, cpf, cobranca)
  SELECT            100, '883773874-98', 0 FROM dual
  UNION ALL SELECT  200, '939387738-98', 0 FROM dual
  UNION ALL SELECT  300, '338872779-88', 0 FROM dual
  UNION ALL SELECT  400, '927272882-12', 0 FROM dual
;

INSERT INTO VEICULO(id_veiculo, placa, id_proprietario)
  SELECT            10, 'KKC-6278', 200 FROM dual
  UNION ALL SELECT  20, 'MMN-3982', 300 FROM dual
  UNION ALL SELECT  30, 'KKW-8372', 100 FROM dual
  UNION ALL SELECT  40, 'MMX-3837', 400 FROM dual
  UNION ALL SELECT  50, 'OPP-3876', 200 FROM dual
;

INSERT INTO REGISTRO(id_registro, id_veiculo, data_uso, permanencia)
  SELECT            1, 10, (TO_DATE('2004/12/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss')), 60 FROM dual
  UNION ALL SELECT  2, 20, (TO_DATE('2000/01/13 21:02:44', 'yyyy/mm/dd hh24:mi:ss')), 75 FROM dual
  UNION ALL SELECT  3, 20, (TO_DATE('2000/09/12 21:02:44', 'yyyy/mm/dd hh24:mi:ss')), 20 FROM dual
  UNION ALL SELECT  4, 30, (TO_DATE('2002/05/19 21:02:44', 'yyyy/mm/dd hh24:mi:ss')), 35 FROM dual
  UNION ALL SELECT  5, 10, (TO_DATE('2005/12/12 21:02:44', 'yyyy/mm/dd hh24:mi:ss')), 22 FROM dual
  UNION ALL SELECT  6, 50, (TO_DATE('2007/08/09 21:02:44', 'yyyy/mm/dd hh24:mi:ss')), 32 FROM dual
;

-- Código (Função):

CREATE OR REPLACE FUNCTION CALCULATARIFA (cpf VARCHAR2) RETURN INTEGER
IS
d_id_proprietario INTEGER;
tempo_permanencia REGISTRO.permanencia%TYPE;
tarifa NUMBER(9,2);

CURSOR registros(aux_id_proprietario NUMBER) IS
    SELECT permanencia
    FROM veiculo NATURAL JOIN registro
    WHERE id_proprietario = aux_id_proprietario;

BEGIN
    SELECT id_proprietario
    INTO d_id_proprietario
    FROM PROPRIETARIO p
    WHERE p.cpf = cpf;

    tarifa := 0;
    OPEN registros(d_id_proprietario);
    LOOP
        FETCH registros INTO tempo_permanencia;
        IF registros%NOTFOUND THEN
            dbms_output.put_line('Não existe registro de estacionamento para o proprietário informado.');
            RETURN NULL;
        END IF;

        IF (tempo_permanencia > 30) THEN
            tarifa := tarifa + (tempo_permanencia - 30) * 0.10;
        END IF;
    END LOOP;
    CLOSE registros;
    RETURN tarifa;
END;
