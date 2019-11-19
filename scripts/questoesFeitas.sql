DROP VIEW TELEFONES_CLIENTES;

-- Questão 1
SELECT f.funcao, f.nome, f.matricula, f.cpf FROM FUNCIONARIO f GROUP BY f.funcao, f.nome, f.matricula, f.cpf ORDER BY f.funcao;

-- Questão 2
SELECT AVG(p.preco_compra - p.preco_venda) FROM PRODUTO p GROUP BY p.preco_compra, p.preco_venda;

-- Questão 3
CREATE VIEW TELEFONES_CLIENTES(nome, telefone) AS SELECT c.nome, t.telefone FROM (CLIENTE c join TELEFONE_CLIENTE t on (c.cpf = t.cpf_cliente)) GROUP BY c.nome, t.telefone;
SELECT nome, telefone FROM TELEFONES_CLIENTES;


