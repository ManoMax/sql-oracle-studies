/*
Link da Imagem: https://imgur.com/HUi8hUB

Crie e popule todas as tabelas com os mesmos dados da figura.
Em PL/SQL, crie uma stored procedure empacotada chamada CALCULASALDO (nome do pacote: FINANCEIRO)
para computar os valores da coluna SALDO da tabela CONTA de acordo com as movimentações financeiras registradas na tabela MOVIMENTO.
É obrigatório o uso de cursor com laço LOOP.
Crie um bloco PL/SQL anônimo que chame a procedure CALCULASALDO e, em seguida, leia e mostre na tela os valores dos campos ID_CONTA e SALDO da tabela CONTA.
Use laço FOR.
Execute o bloco PL/SQL anônimo e apresente o resultado.
Mostre ainda todos os comandos utilizados na questão, incluindo os de criação das tabelas e inserção de dados.

*/

-- Criando e populando as Tabelas:
-- Para reuso do script, remova os comentários das duas linhas abaixo:

-- DROP TABLE MOVIMENTO;
-- DROP TABLE CONTA;

CREATE TABLE CONTA(
	id_conta INTEGER,
	criacao DATE,
    id_correntista INTEGER,
    saldo INTEGER,

	CONSTRAINT pk_id_conta
	PRIMARY KEY (id_conta)
);

CREATE TABLE MOVIMENTO(
    id_movimento INTEGER,
    id_conta INTEGER,
	operacao VARCHAR2(10),
	valor INTEGER,

    CONSTRAINT fk_id_conta
    FOREIGN KEY (id_conta) 
    REFERENCES  CONTA(id_conta),

	CONSTRAINT pk_id_movimento
	PRIMARY KEY (id_movimento)
);

INSERT INTO CONTA(id_conta, criacao, id_correntista, saldo)
    SELECT            100, TO_DATE('01/03/2004'), 1001, NULL FROM dual
    UNION ALL SELECT  200, TO_DATE('05/09/2002'), 1003, NULL FROM dual
    UNION ALL SELECT  300, TO_DATE('06/11/2008'), 1002, NULL FROM dual
    UNION ALL SELECT  400, TO_DATE('15/09/1996'), 1004, NULL FROM dual
;

INSERT INTO MOVIMENTO(id_movimento, id_conta, operacao, valor)
  SELECT            1, 100, 'Saque', 50 FROM dual
  UNION ALL SELECT  2, 200, 'Depósito', 400 FROM dual
  UNION ALL SELECT  3, 100, 'Depósito', 300 FROM dual
  UNION ALL SELECT  4, 300, 'Saque', 1000 FROM dual
  UNION ALL SELECT  5, 200, 'Saque', 300 FROM dual
  UNION ALL SELECT  6, 300, 'Depósito', 500 FROM dual
  UNION ALL SELECT  9, 200, 'Depósito', 300 FROM dual
;

--  Criação da Especificação da procedure CALCULASALDO dentro do Pacote FINANCEIRO:

CREATE OR REPLACE PACKAGE FINANCEIRO
IS
    PROCEDURE CALCULASALDO;
END FINANCEIRO;

-- Criação do Corpo da procedure CALCULASALDO dentro do Pacote FINANCEIRO:

CREATE OR REPLACE PACKAGE BODY FINANCEIRO
IS
    PROCEDURE CALCULASALDO
    IS
        CURSOR movimentacoes(aux_id_conta INTEGER) IS
        SELECT valor
        FROM CONTA NATURAL JOIN MOVIMENTO
        WHERE id_conta = aux_id_conta;

        CURSOR all_accounts IS
            SELECT id_conta, saldo
            FROM CONTA;

        v_conta all_accounts%ROWTYPE;
        v_movimentacao movimentacoes%ROWTYPE;
        valor_total INTEGER;
    BEGIN
        OPEN all_accounts;
        LOOP
            FETCH all_accounts INTO v_conta;
            EXIT WHEN all_accounts%NOTFOUND;

            valor_total := 0;
            OPEN movimentacoes(v_conta.id_conta);
            LOOP
                FETCH movimentacoes INTO v_movimentacao;
                EXIT WHEN movimentacoes%NOTFOUND;
                valor_total := valor_total + v_movimentacao.valor;
            END LOOP;
            CLOSE movimentacoes;

            UPDATE CONTA
            SET saldo = valor_total
            WHERE id_conta = v_conta.id_conta;
            
        END LOOP;
        CLOSE all_accounts;
    END;
END;

-- Mostrando na tela os valores dos campos ID_CONTA e SALDO da tabela CONTA:

DECLARE
    CURSOR view_table IS
    SELECT id_conta, saldo
    FROM CONTA;
BEGIN
    FINANCEIRO.CALCULASALDO;
    FOR v_conta_aux IN view_table LOOP
        dbms_output.put_line(v_conta_aux.id_conta || ' ' || v_conta_aux.saldo);    
    END LOOP;
END;

-- Saída desse último Script:

100 350
200 1000
300 1500
400 0
