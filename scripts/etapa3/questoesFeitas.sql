DROP VIEW TELEFONES_CLIENTES;

-- Questão 1
SELECT f.funcao, f.nome, f.matricula, f.cpf FROM FUNCIONARIO f GROUP BY f.funcao, f.nome, f.matricula, f.cpf ORDER BY f.funcao;

-- Questão 2
SELECT AVG(p.preco_venda - p.preco_compra) FROM PRODUTO p GROUP BY p.preco_compra, p.preco_venda;

-- Questão 3
CREATE VIEW TELEFONES_CLIENTES(nome, telefone) AS SELECT c.nome, t.telefone FROM (CLIENTE c join TELEFONE_CLIENTE t on (c.cpf = t.cpf_cliente))
GROUP BY c.nome, t.telefone ORDER BY c.nome;
-- Testando Questão 3
SELECT nome, telefone FROM TELEFONES_CLIENTES;

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

