/*
Crie a função CATEGORIA que receba o CPF de um proprietário e retorne sua categoria: GOLD, se possui 10 ou mais registros de estacionamento,
SILVER (entre 9 e 5) e BRONZE (entre 1 e 4).
Só devem ser considerados registros de estacionamento a partir do ano de 2001 e com duração de pelo menos 10 minutos.
Trate o caso de o valor do CPF não estar cadastrado. Crie um bloco PL/SQL que chame a função CATEGORIA e imprima na tela a categoria do proprietário.
Mostre o código-fonte e o resultado da execução.


(*) Se achar necessário, crie e popule as tabelas.

Link das tabelas: https://imgur.com/8zkeR1u
*/

CREATE OR REPLACE FUNCTION CATEGORIA(cpf VARCHAR2) RETURN VARCHAR2
IS
categoria VARCHAR2(6);
aux_id_proprietario proprietario.id_proprietario%TYPE;
num_registros INTEGER;

BEGIN
    -- Selecionando o id de Proprietario com o cpf especifico
    SELECT id_proprietario
    INTO aux_id_proprietario
    FROM PROPRIETARIO
    WHERE cpf = cpf;

    -- Selecionando o numero de registros dos veiculos desse usuario
    -- com a data superior a minima e permanencia maior que 10 min
    SELECT COUNT(*)
    INTO num_registros
    FROM VEICULO NATURAL JOIN REGISTRO
    WHERE id_proprietario = aux_id_proprietario AND
        data_uso >= '01/01/2001' AND
        permanencia >= 10;
    
    -- Verificando categorias
    IF (num_registros > 0 and num_registros < 5) THEN
         categoria := 'BRONZE';
    ELSIF (num_registros >= 5 and num_registros < 10) THEN
         categoria := 'SILVER';
    ELSIF (num_registros >= 10) THEN
        categoria := 'GOLD';
    END IF;

    RETURN categoria;

EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('O valor do CPF não esta cadastrado.');
        RETURN NULL;
END;
