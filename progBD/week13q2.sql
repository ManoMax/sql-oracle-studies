/*
Adicione a função TOTALSAQUE ao pacote FINANCEIRO.
A função deve calcular e retornar o valor da taxa a ser paga após uma determinada quantidade de saques feitos em uma conta
(ID_CONTA é fornecido como parâmetro de entrada).

É possível realizar até dois saques sem cobrança de taxa.
Após isso, deve ser cobrado o valor de R$ 3,00 multiplicado pelo número de saques realizados acima do limite permitido.
Usando a cláusula EXCEPTION, trate os casos em que:

a) não houve saque para a conta informada; e
b) não existe a conta informada.

Crie um bloco PL/SQL anônimo para chamar a função criada.
Execute o bloco PL/SQL anônimo criado para testar os dois casos de exceção além de um caso para mostrar o valor da taxa de cobrança.
Mostre todos os comandos usados na questão bem como o resultado das execuções.
*/

-- Criando (replace) Especificação do Pacote FINANCEIRO:

CREATE OR REPLACE PACKAGE FINANCEIRO
IS
    PROCEDURE CALCULASALDO;
    FUNCTION TOTALSAQUE(aux_id_conta INTEGER) RETURN INTEGER;
END FINANCEIRO;

-- Criando (replace) Corpo do Pacote FINANCEIRO:

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

    FUNCTION TOTALSAQUE(aux_id_conta INTEGER) RETURN INTEGER IS
        num_saques INTEGER;
        taxa INTEGER;
    BEGIN
        SELECT COUNT(*)
        INTO num_saques
        FROM MOVIMENTO
        WHERE id_conta = aux_id_conta;

        IF (num_saques > 0 and num_saques <= 2) THEN
            taxa := 0;
        ELSIF num_saques > 2 THEN
            taxa := 3 * (num_saques - 2);
        ELSE
            taxa := -1;
        END IF;

        RETURN taxa;
    END TOTALSAQUE;
END;

-- Caso de Teste 1: ID = 100 (dois saques):

DECLARE
    taxa INTEGER;
    v_conta CONTA%ROWTYPE;
    sem_saques_exception EXCEPTION;
    conta_id INTEGER;
BEGIN
    conta_id := 100;

    SELECT *
    INTO v_conta
    FROM CONTA
    WHERE id_conta = conta_id;

    taxa := FINANCEIRO.TOTALSAQUE(v_conta.id_conta);

    IF taxa = -1 THEN
        RAISE sem_saques_exception;
    ELSE
        dbms_output.put_line('R$ ' || taxa || ',00');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Não existe a conta informada.');
    WHEN sem_saques_exception THEN
        dbms_output.put_line('Não houve saque para a conta informada.');
END;

-- Saída Caso 1:

R$ 0,00

-- Caso de Teste 2: ID = 200 (três saques):

DECLARE
    taxa INTEGER;
    v_conta CONTA%ROWTYPE;
    sem_saques_exception EXCEPTION;
    conta_id INTEGER;
BEGIN
    conta_id := 200;

    SELECT *
    INTO v_conta
    FROM CONTA
    WHERE id_conta = conta_id;

    taxa := FINANCEIRO.TOTALSAQUE(v_conta.id_conta);

    IF taxa = -1 THEN
        RAISE sem_saques_exception;
    ELSE
        dbms_output.put_line('R$ ' || taxa || ',00');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Não existe a conta informada.');
    WHEN sem_saques_exception THEN
        dbms_output.put_line('Não houve saque para a conta informada.');
END;

-- Saída Caso 2:

R$ 3,00

-- Caso de Teste 3: ID = 400 (nenhum saque):

DECLARE
    taxa INTEGER;
    v_conta CONTA%ROWTYPE;
    sem_saques_exception EXCEPTION;
    conta_id INTEGER;
BEGIN
    conta_id := 400;

    SELECT *
    INTO v_conta
    FROM CONTA
    WHERE id_conta = conta_id;

    taxa := FINANCEIRO.TOTALSAQUE(v_conta.id_conta);

    IF taxa = -1 THEN
        RAISE sem_saques_exception;
    ELSE
        dbms_output.put_line('R$ ' || taxa || ',00');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Não existe a conta informada.');
    WHEN sem_saques_exception THEN
        dbms_output.put_line('Não houve saque para a conta informada.');
END;

-- Saída Caso 3:

Não houve saque para a conta informada.

-- Caso de Teste 4: ID = 900 (Conta inexistente):

DECLARE
    taxa INTEGER;
    v_conta CONTA%ROWTYPE;
    sem_saques_exception EXCEPTION;
    conta_id INTEGER;
BEGIN
    conta_id := 900;

    SELECT *
    INTO v_conta
    FROM CONTA
    WHERE id_conta = conta_id;

    taxa := FINANCEIRO.TOTALSAQUE(v_conta.id_conta);

    IF taxa = -1 THEN
        RAISE sem_saques_exception;
    ELSE
        dbms_output.put_line('R$ ' || taxa || ',00');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Não existe a conta informada.');
    WHEN sem_saques_exception THEN
        dbms_output.put_line('Não houve saque para a conta informada.');
END;

-- Saída Caso 4:

Não existe a conta informada.
