-- Questão 1
SELECT f.funcao, f.nome, f.matricula, f.cpf FROM FUNCIONARIO f GROUP BY f.funcao, f.nome, f.matricula, f.cpf ORDER BY f.funcao;

-- Questão 2
SELECT AVG(p.preco_venda - p.preco_compra) FROM PRODUTO p GROUP BY p.preco_compra, p.preco_venda;

-- Questão 3
CREATE OR REPLACE VIEW TELEFONES_CLIENTES(nome, telefone) AS SELECT c.nome, t.telefone FROM (CLIENTE c join TELEFONE_CLIENTE t on (c.cpf = t.cpf_cliente))
GROUP BY c.nome, t.telefone ORDER BY c.nome;

-- Questão 4
SELECT i.* FROM (PRODUTO p join ITEM i on (p.preco_compra != i.preco_produto));

-- Questão 5
SELECT f1.nome FROM FUNCIONARIO f1 WHERE f1.salario > (SELECT AVG(f.salario) FROM FUNCIONARIO f) GROUP BY f1.nome;

-- Questão 6
SELECT c.nome, c.rua, c.num, c.bairro, c.cidade, c.estado FROM CLIENTE c WHERE c.pontos_crm >= (SELECT MAX(c1.pontos_crm) FROM CLIENTE c1)
GROUP BY c.nome, c.rua, c.num, c.bairro, c.cidade, c.estado;

-- Questão 7
SELECT * FROM (CLIENTE c join DEPENDENTE d on (c.cpf = d.cpf));

-- Questão 8
SELECT SUM(i.preco_produto * i.quantidade) FROM 
(ITEM i join (SELECT o1.* FROM (ORDEM_COMPRA o1 join 
(SELECT c1.* FROM CLIENTE c1 WHERE c1.nome = 'José') c on (o1.cpf_cliente = c.cpf))) o on (i.num_nota_fiscal_ordem = o.numero_nota_fiscal));

-- Questão 9
SELECT f.funcao, COUNT(f.funcao) FROM FUNCIONARIO f GROUP BY f.funcao;

-- Questão 10
SELECT f.matricula, f.nome, f.cpf FROM (ORDEM_COMPRA o join (SELECT h.matricula, h.nome, h.cpf FROM FUNCIONARIO h WHERE h.funcao != 'Caixa') f on (f.cpf = o.cpf_cliente)) GROUP BY f.matricula, f.nome, f.cpf;

-- Questão 11
SELECT * FROM SOLICITACAO s WHERE s.valor_compra > (SELECT AVG(s1.valor_compra) FROM SOLICITACAO s1);

-- Questão 12
SELECT AVG(i.quantidade) FROM ITEM i;

-- Questão 13
CREATE OR REPLACE VIEW ACOUGUEIRO_DANTAS(cpf, data_nasc, nome, matricula_funcionario) AS SELECT d.cpf, d.data_nasc, d.nome, d.matricula_funcionario
FROM (DEPENDENTE d join (SELECT * FROM FUNCIONARIO f1 WHERE f1.nome = 'Dantas' and f1.funcao = 'Açougueiro') f on (d.matricula_funcionario = f.matricula))
GROUP BY d.cpf, d.data_nasc, d.nome, d.matricula_funcionario;

-- Questão 14
CREATE OR REPLACE VIEW CLIENTES_ESTRANGEIROS(cpf, nome, pontos_crm, rua, num, cidade, estado, bairro, telefone) AS SELECT c.cpf, c.nome, c.pontos_crm, c.rua, c.num, c.cidade, c.estado, c.bairro, t.telefone 
FROM (CLIENTE c left join TELEFONE_CLIENTE t on (c.cpf = t.cpf_cliente))
WHERE c.cidade <> 'Campina Grande' and (NOT EXISTS (SELECT * FROM TELEFONE_CLIENTE d WHERE c.cpf = t.cpf_cliente));

-- Questão 15
                                                    
ALTER TABLE FORNECEDOR ADD CONSTRAINT emailCorretoFornecedor
CHECK (REGEXP_INSTR(email, '^[[:alnum:]_]+@[[:alnum:]]+((\.)[[:alpha:]]+)+$') > 0);


-- QUESTÃO 16
CREATE OR REPLACE TRIGGER CNPJ_NAO_CADASTRADO 
BEFORE INSERT ON NOTA_FISCAL 
FOR EACH ROW 
DECLARE    
    total_cnpj varchar;
BEGIN SELECT COUNT(*) AS total_cnpj FROM FORNECEDOR WHERE cnpj = :NEW.cnpj IF (total_cnpj = 0) 
THEN raise_application_error(-20502,'CNPJ não cadastrado');
END IF;
END


-- QUESTÃO 17
CREATE OR REPLACE TRIGGER LIMITE_TELEFONE_EXCEDIDO 
BEFORE INSERT ON TELEFONE_CLIENTE
FOR EACH ROW
DECLARE total_telefones number;
BEGIN 
SELECT COUNT(DISTINCT t.cpf_cliente) INTO total_telefones
FROM TELEFONE_CLIENTE t
WHERE :new.cpf_cliente = t.cpf_cliente
IF(total_telefone > 3) THEN
RAISE_APPLICATION_ERROR(-20001,'Cliente já possui 3 telefones');
END IF;
END;

--QUESTÃO 18

--Questão 19

--QUESTÃO 20
CREATE OR REPLACE calculaEstoqueTotal 
RETURN NUMBER
AS resultFunction NUMBER
CURSOR calculaEstoque IS SELECT p.quantidade FROM PRODUTO 
sum(p.quantidade) AS resultFunction;



