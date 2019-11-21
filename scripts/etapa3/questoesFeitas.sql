DROP VIEW TELEFONES_CLIENTES;

-- Questão 1
SELECT f.funcao, f.nome, f.matricula, f.cpf FROM FUNCIONARIO f GROUP BY f.funcao, f.nome, f.matricula, f.cpf ORDER BY f.funcao;

-- Questão 2
SELECT AVG(p.preco_venda - p.preco_compra) FROM PRODUTO p GROUP BY p.preco_compra, p.preco_venda;

-- Questão 3
CREATE VIEW TELEFONES_CLIENTES(nome, telefone) AS SELECT c.nome, t.telefone FROM (CLIENTE c join TELEFONE_CLIENTE t on (c.cpf = t.cpf_cliente)) GROUP BY c.nome, t.telefone ORDER BY c.nome;
SELECT nome, telefone FROM TELEFONES_CLIENTES;

-- Questão 4
SELECT i.* FROM (PRODUTO p join ITEM i on (p.preco_compra != i.preco_produto));

-- Questão 5
SELECT f1.nome FROM FUNCIONARIO f1 WHERE f1.salario > (SELECT AVG(f.salario) FROM FUNCIONARIO f) GROUP BY f1.nome;
