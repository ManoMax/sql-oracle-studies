-- Esquema padrão para o projeto de Banco de Dados 1 2019.2

DROP TABLE REALIZA_RECLAMACAO;
DROP TABLE ITEM;
DROP TABLE ORDEM_COMPRA;
DROP TABLE TELEFONE_FORNECEDOR;
DROP TABLE NOTA_FISCAL;
DROP TABLE SOLICITACAO;
DROP TABLE FORNECEDOR;
DROP TABLE REALIZA_MANUTENCAO;
DROP TABLE EQUIPAMENTO;
DROP TABLE CAIXA;
DROP TABLE PRODUTO;
DROP TABLE CATEGORIA;
DROP TABLE MARCA;
DROP TABLE FILIAL CASCADE CONSTRAINT;
DROP TABLE DEPENDENTE;
DROP TABLE TELEFONE_FUNCIONARIO;
DROP TABLE FUNCIONARIO CASCADE CONSTRAINT;
DROP TABLE TELEFONE_CLIENTE;
DROP TABLE CLIENTE;

CREATE TABLE CLIENTE (
    cpf 	VARCHAR2(14),
	nome 	VARCHAR2(100) NOT NULL,
	email 	VARCHAR2(50) NOT NULL,
	pontos_crm INT,
    rua 	VARCHAR2(100) NOT NULL,
	num 	VARCHAR2(14) NOT NULL,
	cidade 	VARCHAR2(100) NOT NULL,
	estado 	VARCHAR2(100) NOT NULL,
	bairro 	VARCHAR2(100) NOT NULL,

	CONSTRAINT pk_cliente
	PRIMARY KEY (cpf)
);

CREATE TABLE TELEFONE_CLIENTE (
	telefone VARCHAR2(15),
	cpf_cliente VARCHAR2(14),

    CONSTRAINT fk_telefone_cliente 
    FOREIGN KEY (cpf_cliente) 
    REFERENCES  CLIENTE(cpf),

	CONSTRAINT pk_telefone_cliente
	PRIMARY KEY (cpf_cliente, telefone)
);

CREATE TABLE FUNCIONARIO (
    matricula INT,
    cpf		VARCHAR2(14) NOT NULL,
    identidade	VARCHAR2(7) NOT NULL,
    nome 	VARCHAR2(100) NOT NULL,
    endereco    VARCHAR2(200) NOT NULL,
    salario	NUMBER(6,2) NOT NULL,
    funcao	VARCHAR2(50) NOT NULL,
    matricula_supervisor INT,
    codigo_filial INT,
	
    CONSTRAINT fk_funcionario_supervisor
    FOREIGN KEY (matricula_supervisor) 
    REFERENCES  FUNCIONARIO(matricula),

	CONSTRAINT pk_funcionario
	PRIMARY KEY (matricula)
);

CREATE TABLE TELEFONE_FUNCIONARIO (
	telefone VARCHAR2(15),
	matricula INT,

    CONSTRAINT fk_telefone_funcionario
    FOREIGN KEY (matricula)
    REFERENCES  FUNCIONARIO(matricula),

	CONSTRAINT pk_funcionario_telefone
	PRIMARY KEY (telefone, matricula)
);


CREATE TABLE DEPENDENTE (
    cpf 	VARCHAR2(14),
    data_nasc 	DATE NOT NULL,
    nome 	VARCHAR2(100) NOT NULL,
	matricula_funcionario INT NOT NULL,
    
    CONSTRAINT fk_dependente_matricula
    FOREIGN KEY (matricula_funcionario) 
    REFERENCES  FUNCIONARIO(matricula),
	
	CONSTRAINT pk_dependente
	PRIMARY KEY (cpf, matricula_funcionario)	
);

CREATE TABLE FILIAL (
    codigo_identificacao  INT,
    nome  VARCHAR2(100) NOT NULL,
    endereco    VARCHAR2(200) NOT NULL,
    telefone VARCHAR2(15) NOT NULL,
    gerente INT,
	
    CONSTRAINT fk_gerente_filial
    FOREIGN KEY (gerente)
    REFERENCES  FUNCIONARIO(matricula),

    CONSTRAINT pk_filial
    PRIMARY KEY (codigo_identificacao)
);

CREATE TABLE MARCA (
	identificador INT,
    nome  VARCHAR2(100) NOT NULL,

	CONSTRAINT pk_marca
	PRIMARY KEY (identificador)
);

CREATE TABLE CATEGORIA (
	identificador INT,
    nome  VARCHAR2(100) NOT NULL,

	CONSTRAINT pk_categoria
	PRIMARY KEY (identificador)
);

-- MARGE_LUCRO está na representação númerica.
CREATE TABLE PRODUTO (
    codigo_identificacao  INT,
    nome  VARCHAR2(100) NOT NULL,
    descricao	VARCHAR2(255) NOT NULL,
    margem_lucro  NUMBER(6,2) NOT NULL,
    codigo_filial INT NOT NULL,
    quantidade INT,
    preco_compra NUMBER(6,2),
    preco_venda NUMBER(6,2),
    data_compra 	DATE NOT NULL,
    data_validade 	DATE NOT NULL,
    id_marca INT NOT NULL,
    id_categoria INT NOT NULL,

    CONSTRAINT fk_filial_estoca
    FOREIGN KEY (codigo_filial)
    REFERENCES  FILIAL(codigo_identificacao),

    CONSTRAINT fk_marca_produto
    FOREIGN KEY (id_marca)
    REFERENCES  MARCA(identificador),

    CONSTRAINT fk_categoria_produto
    FOREIGN KEY (id_categoria)
    REFERENCES  CATEGORIA(identificador),

	CONSTRAINT pk_produto
	PRIMARY KEY (codigo_identificacao)
);

CREATE TABLE CAIXA (
    numero_caixa  INT,
    codigo_filial INT,

    CONSTRAINT fk_caixa_filial
    FOREIGN KEY (codigo_filial)
    REFERENCES  FILIAL(codigo_identificacao),

	CONSTRAINT pk_caixa
	PRIMARY KEY (numero_caixa)
);

CREATE TABLE EQUIPAMENTO (
	identificador INT,
    descricao	VARCHAR2(255) NOT NULL,
    numero_caixa INT,

    CONSTRAINT fk_equipamento_caixa
    FOREIGN KEY (numero_caixa) 
    REFERENCES  CAIXA(numero_caixa),
	
	CONSTRAINT pk_equipamento
	PRIMARY KEY (numero_caixa, identificador)
);

CREATE TABLE REALIZA_MANUTENCAO (
    id_manutencao INT,
	identificador_equipamento INT NOT NULL,
    numero_caixa INT NOT NULL,
	matricula_funcionario INT NOT NULL,
	data_hora TIMESTAMP NOT NULL,
    custo NUMBER(6,2) NOT NULL,

    CONSTRAINT fk_manutencao_funcionario
    FOREIGN KEY (matricula_funcionario)
    REFERENCES  FUNCIONARIO(matricula),

    CONSTRAINT fk_manutencao_equipamento
    FOREIGN KEY (numero_caixa, identificador_equipamento) 
    REFERENCES  EQUIPAMENTO(numero_caixa, identificador),

	CONSTRAINT pk_manutencao
	PRIMARY KEY (id_manutencao)
);

CREATE TABLE FORNECEDOR (
    cnpj		VARCHAR2(18),
    nome  VARCHAR2(100) NOT NULL,
    endereco    VARCHAR2(200) NOT NULL,
	email 	VARCHAR2(50) NOT NULL,
    id_categoria INT NOT NULL,
    
    CONSTRAINT fk_categoria_fornecedor
    FOREIGN KEY (id_categoria)
    REFERENCES  CATEGORIA(identificador),

	CONSTRAINT pk_fornecedor
	PRIMARY KEY (cnpj)
);

CREATE TABLE SOLICITACAO (
	identificador INT,
    data_solicitacao 	DATE NOT NULL,
    data_prevista 	DATE,
    data_entrega 	DATE,
    valor_compra	NUMBER(10,2) NOT NULL,
    prazo_pagamento 	DATE NOT NULL,
    codigo_filial 	INT NOT NULL,
    cnpj_fornecedor	VARCHAR2(18) NOT NULL,

    CONSTRAINT fk_filial_realiza
    FOREIGN KEY (codigo_filial)
    REFERENCES  FILIAL(codigo_identificacao),

    CONSTRAINT fk_recebe_fornecedor
    FOREIGN KEY (cnpj_fornecedor)
    REFERENCES  FORNECEDOR(cnpj),
    
	CONSTRAINT pk_solicitacao
	PRIMARY KEY (identificador)
);

CREATE TABLE NOTA_FISCAL (
    numero INT,
    cnpj	VARCHAR2(18) NOT NULL,
    quantidade	INT NOT NULL,
    data  DATE NOT NULL,
    valor_por_item	NUMBER(8,2) NOT NULL,
	identificador_solicitacao INT NOT NULL,

    CONSTRAINT fk_solicitacao_tem
    FOREIGN KEY (identificador_solicitacao)
    REFERENCES  SOLICITACAO(identificador),

	CONSTRAINT pk_nota_fiscal
	PRIMARY KEY (numero)
);

CREATE TABLE TELEFONE_FORNECEDOR (
	telefone VARCHAR2(15),
	cnpj VARCHAR2(18),

    CONSTRAINT fk_telefone_fornecedor
    FOREIGN KEY (cnpj)
    REFERENCES  FORNECEDOR(cnpj),

	CONSTRAINT pk_telefone_fornecedor
	PRIMARY KEY (cnpj, telefone)
);

CREATE TABLE ORDEM_COMPRA (
    numero_nota_fiscal  INT,
	data_hora	TIMESTAMP NOT NULL,
	cpf_cliente VARCHAR2(14) NOT NULL,
    codigo_filial INT NOT NULL,
	matricula_funcionario INT NOT NULL,
    numero_caixa INT NOT NULL,

    CONSTRAINT fk_ordem_cliente 
    FOREIGN KEY (cpf_cliente) 
    REFERENCES  CLIENTE(cpf),

    CONSTRAINT fk_filial_possui_ordem
    FOREIGN KEY (codigo_filial)
    REFERENCES  FILIAL(codigo_identificacao),

    CONSTRAINT fk_funcionario_realiza
    FOREIGN KEY (matricula_funcionario) 
    REFERENCES  FUNCIONARIO(matricula),

    CONSTRAINT fk_caixa_realizado
    FOREIGN KEY (numero_caixa) 
    REFERENCES  CAIXA(numero_caixa),

	CONSTRAINT pk_ordem_compra
	PRIMARY KEY (numero_nota_fiscal)
);

-- DESCONTO está na representação númerica.
CREATE TABLE ITEM (
    identificador  INT,
    num_nota_fiscal_ordem INT,
    numero_nota_fiscal INT,
    quantidade	INT NOT NULL,
    preco_produto NUMBER(6,2) NOT NULL,
    desconto NUMBER(3,2) NOT NULL,

    CONSTRAINT fk_ordem_compra
    FOREIGN KEY (num_nota_fiscal_ordem)
    REFERENCES  ORDEM_COMPRA(numero_nota_fiscal),

    CONSTRAINT fk_nota_fiscal
    FOREIGN KEY (numero_nota_fiscal)
    REFERENCES  NOTA_FISCAL(numero),

	CONSTRAINT pk_item
	PRIMARY KEY (identificador, num_nota_fiscal_ordem)
);

CREATE TABLE REALIZA_RECLAMACAO (
    id_reclamacao INT,
	data_hora	TIMESTAMP NOT NULL,
    descricao	VARCHAR2(255) NOT NULL,
    codigo_filial INT NOT NULL,
	cpf_cliente VARCHAR2(14) NOT NULL,

    CONSTRAINT fk_reclamacao_filial
    FOREIGN KEY (codigo_filial)
    REFERENCES  FILIAL(codigo_identificacao),

    CONSTRAINT fk_reclamacao_cliente
    FOREIGN KEY (cpf_cliente) 
    REFERENCES  CLIENTE(cpf),

	CONSTRAINT pk_reclamacao
	PRIMARY KEY (id_reclamacao)
);

ALTER TABLE FUNCIONARIO ADD CONSTRAINT FK_CODIGO_FILIAL_IN_FUNCIONARIO FOREIGN KEY (CODIGO_FILIAL) REFERENCES FILIAL(CODIGO_IDENTIFICACAO);



-- ISSO AQUI É NOSSO

INSERT INTO CLIENTE(cpf, nome, email, pontos_crm, rua, num, cidade, estado, bairro)
  SELECT            '123.456.789-01', 'Gabriel', 'gabriel@email.com', 100, 'R. Zero', '000', 'Cidade Neutra', 'Estado Invisivel', 'Bairro Secreto' FROM dual
  UNION ALL SELECT  '234.567.890-12', 'Afranio', 'afranio@email.com', 99, 'R. Dois', '002', 'Cidade', 'Vista', 'Santa Mamãe' FROM dual
  UNION ALL SELECT  '345.678.901-23', 'Lucas', 'lucas@email.com', 99, 'R. Três', '003', 'Cidade Bela', 'Vista Bela', 'Santa Mamãe' FROM dual
  UNION ALL SELECT  '456.789.012-34', 'Carol', 'carol@email.com', 101, 'R. Quatro', '004', 'Cidade Linda', 'Vista Cega', 'Santa Aparecida' FROM dual
  UNION ALL SELECT  '567.890.123-45', 'Baptista', 'baptista@email.com', 0, 'R. Dez', '100', 'Cidade Incrivel', 'Vista Torta', 'Santa Desaparecida' FROM dual
;

INSERT INTO TELEFONE_CLIENTE(telefone, cpf_cliente)
  SELECT            '4002-8922', '123.456.789-01' FROM dual
  UNION ALL SELECT  '8888-9999', '123.456.789-01' FROM dual
  UNION ALL SELECT  '1111-0000', '234.567.890-12' FROM dual
  UNION ALL SELECT  '1010-1111', '234.567.890-12' FROM dual
  UNION ALL SELECT  '4444-2222', '345.678.901-23' FROM dual
  UNION ALL SELECT  '6555-5666', '456.789.012-34' FROM dual
  UNION ALL SELECT  '4545-4545', '567.890.123-45' FROM dual
;

INSERT INTO FUNCIONARIO (matricula, cpf, identidade, nome, endereco, salario, funcao, matricula_supervisor, codigo_filial)
  SELECT            100, '710.550.280-30', '1234567', 'Antonio', 'Rua A', 1000, 'Caixa', NULL, NULL FROM dual
  UNION ALL SELECT  200, '700.540.270-20', '2345678', 'Bebiano', 'Rua B', 2000, 'Empacotador', NULL, NULL FROM dual
  UNION ALL SELECT  300, '690.530.260-10', '3456789', 'Caio', 'Rua C', 3000, 'Açougueiro', NULL, NULL FROM dual
  UNION ALL SELECT  400, '680.520.250-00', '4567890', 'Dalton', 'Rua D', 4000, 'Padeiro', NULL, NULL FROM dual
  UNION ALL SELECT  500, '670.510.240-90', '5678901', 'Euclides', 'Rua E', 5000, 'Limpeza', NULL, NULL FROM dual
  UNION ALL SELECT  600, '660.500.230-80', '6789012', 'Fernando', 'Rua F', 6000, 'Seguranca', NULL, NULL FROM dual
  UNION ALL SELECT  700, '660.490.220-80', '6789012', 'Gabriel', 'Rua G', 7000, 'Seguranca', NULL, NULL FROM dual
  UNION ALL SELECT  800, '660.480.210-80', '6789012', 'Hericles', 'Rua H', 8000, 'Seguranca', NULL, NULL FROM dual
  UNION ALL SELECT  900, '660.470.200-80', '6789012', 'Ítalo', 'Rua I', 9000, 'Caixa', NULL, NULL FROM dual
;

-- TELEFONE_FUNCIONARIO

INSERT INTO DEPENDENTE(cpf, data_nasc, nome, matricula_funcionario)
  SELECT            '123.456.789-01', TO_DATE('25/05/1998'), 'Max', 700 FROM dual
  UNION ALL SELECT  'cpf.sou.dep-02', TO_DATE('25/04/1998'), 'João', 100 FROM dual
  UNION ALL SELECT  '345.678.901-23', TO_DATE('25/03/1998'), 'Maria', 200 FROM dual
  UNION ALL SELECT  'cpf.sou.dep-04', TO_DATE('25/02/1998'), 'José', 300 FROM dual
  UNION ALL SELECT  'cpf.sou.dep-05', TO_DATE('25/01/1998'), 'Mateus', 400 FROM dual
  UNION ALL SELECT  'cpf.sou.dep-06', TO_DATE('25/12/1997'), 'Rita', 500 FROM dual
;

INSERT INTO FILIAL (codigo_identificacao, nome, endereco, telefone, gerente)
  SELECT            1, 'Bom demais', 'Catolé', '4002-8922', 100 FROM dual
  UNION ALL SELECT  2, 'Bom tambem', 'Malvinas', '0800.88', 200 FROM dual
  UNION ALL SELECT  3, 'Bem melhor', 'São José', '0800.99', 300 FROM dual
  UNION ALL SELECT  4, 'Melhor Ainda', 'Jeremias', '5246-5544', 400 FROM dual
  UNION ALL SELECT  5, 'Sempre Bom', 'Bodocongó', '9420-4200', 500 FROM dual
  UNION ALL SELECT  6, 'Melho que Tem', 'Dinamérica', '4444-4441', 600 FROM dual
  UNION ALL SELECT  7, 'Ainda Bem', 'Liberdade', '0101-0101', 700 FROM dual
  UNION ALL SELECT  8, 'Bem Bom', 'Serrotão', '1111-0000', 800 FROM dual
;

INSERT INTO MARCA(identificador, nome)
  SELECT            101, 'Piracanjuba' FROM dual
  UNION ALL SELECT  102, 'Pira' FROM dual
  UNION ALL SELECT  103, 'Nestle' FROM dual
  UNION ALL SELECT  104, 'canjuba' FROM dual
  UNION ALL SELECT  105, 'jujuba' FROM dual
;

INSERT INTO CATEGORIA(identificador, nome)
  SELECT            1, 'Sao Bras' FROM dual
  UNION ALL SELECT  2, 'Sao Braz' FROM dual
  UNION ALL SELECT  3, 'Nao sao Braz' FROM dual
  UNION ALL SELECT  4, 'Sim sao Braz' FROM dual
  UNION ALL SELECT  5, 'Sao sao Braz' FROM dual
;

INSERT INTO PRODUTO (codigo_identificacao, nome, descricao, margem_lucro, codigo_filial, quantidade, preco_compra, preco_venda, data_compra, data_validade, id_marca, id_categoria)
  SELECT             10,'Arroz', 'Arroz branco integral', 1.00, 1, 100, 2.20, 3.20, TO_DATE('10/10/2019'), TO_DATE('12/01/2020'), 101, 1 FROM dual
  UNION ALL SELECT   11,'Feijao', 'Feijao carioca', 1.50, 1, 50, 2.50, 4.00, TO_DATE('08/10/2019'), TO_DATE('12/01/2020'), 101, 2 FROM dual
  UNION ALL SELECT   12,'Macarrao', 'Macarrao parafuso', 0.50, 3, 150, 2.00, 2.50, TO_DATE('01/10/2019'), TO_DATE('12/01/2020'), 102, 3 FROM dual
  UNION ALL SELECT   13,'Feijao', 'Feijao carioca', 2.00, 3, 500, 4.00, 6.00, TO_DATE('08/09/2019'), TO_DATE('10/02/2020'), 103, 4 FROM dual
  UNION ALL SELECT   14,'Feijao', 'Feijao Preto', 2.00, 2, 200, 3.00, 5.00, TO_DATE('12/09/2019'), TO_DATE('12/02/2020'), 103, 5 FROM dual
;

INSERT INTO CAIXA(numero_caixa, codigo_filial)
  SELECT            90, 1 FROM dual
  UNION ALL SELECT  91, 2 FROM dual
  UNION ALL SELECT  92, 3 FROM dual
  UNION ALL SELECT  93, 4 FROM dual
  UNION ALL SELECT  94, 5 FROM dual
  UNION ALL SELECT  95, 6 FROM dual
  UNION ALL SELECT  96, 7 FROM dual
  UNION ALL SELECT  97, 8 FROM dual
;

-- Equipamento

-- REALIZA_MANUTENCAO

INSERT INTO FORNECEDOR(cnpj, nome, endereco, email, id_categoria)
  SELECT            'cnpj500.111.000-22', 'Distribuidora Ora', 'Rua Gago Ago', 'gagagaguinho@email.com', 1 FROM dual
  UNION ALL SELECT  'cnpj500.111.000-23', 'Distribuidora De Dora', 'Rua Dora Chika', 'dorinha@email.com', 1 FROM dual
  UNION ALL SELECT  'cnpj500.111.000-24', 'Distribuidora Dona Chica', 'Rua Chicabom', 'dona.chica@email.com', 2 FROM dual
  UNION ALL SELECT  'cnpj500.111.000-25', 'Distribuidora Falida', 'Rua Sem Asfalto', 'falindo@email.com', 2 FROM dual
  UNION ALL SELECT  'cnpj500.111.000-26', 'Distribuidora Bem Demais', 'Rua Eterna', 'bem.demais@email.com', 3 FROM dual
;

INSERT INTO SOLICITACAO(identificador, data_solicitacao, data_prevista, data_entrega, valor_compra, prazo_pagamento, codigo_filial, cnpj_fornecedor)
  SELECT            70, TO_DATE('14/10/2019'), TO_DATE('15/10/2019'), TO_DATE('15/10/2019'), 100.00, TO_DATE('14/10/2019'), 1, 'cnpj500.111.000-22' FROM dual
  UNION ALL SELECT  71, TO_DATE('17/10/2019'), TO_DATE('18/10/2019'), TO_DATE('18/10/2019'), 100.00, TO_DATE('17/10/2019'), 1, 'cnpj500.111.000-22' FROM dual
  UNION ALL SELECT  72, TO_DATE('20/10/2019'), TO_DATE('21/10/2019'), TO_DATE('21/10/2019'), 100.00, TO_DATE('20/10/2019'), 1, 'cnpj500.111.000-25' FROM dual
  UNION ALL SELECT  73, TO_DATE('22/10/2019'), TO_DATE('23/10/2019'), TO_DATE('23/10/2019'), 100.00, TO_DATE('22/10/2019'), 1, 'cnpj500.111.000-25' FROM dual
  UNION ALL SELECT  74, TO_DATE('24/10/2019'), TO_DATE('25/10/2019'), TO_DATE('25/10/2019'), 100.00, TO_DATE('24/10/2019'), 1, 'cnpj500.111.000-26' FROM dual
  UNION ALL SELECT  75, TO_DATE('27/10/2019'), TO_DATE('28/10/2019'), TO_DATE('28/10/2019'), 100.00, TO_DATE('27/10/2019'), 1, 'cnpj500.111.000-26' FROM dual
;
INSERT INTO NOTA_FISCAL(numero, cnpj, quantidade, data, valor_por_item, identificador_solicitacao)
  SELECT            800, 'cnpj100.000.111-22', 10, TO_DATE('15/10/2019'), 100.00, 70 FROM dual
  UNION ALL SELECT  801, 'cnpj100.000.111-23', 20, TO_DATE('16/10/2019'), 50.00, 71 FROM dual
  UNION ALL SELECT  802, 'cnpj100.000.111-24', 5, TO_DATE('17/10/2019'), 500.00, 71 FROM dual
  UNION ALL SELECT  803, 'cnpj100.000.111-25', 10, TO_DATE('18/10/2019'), 200.00, 71 FROM dual
  UNION ALL SELECT  804, 'cnpj100.000.111-26', 50, TO_DATE('19/10/2019'), 20.00, 71 FROM dual
;

-- Telefone Fornecedor

INSERT INTO ORDEM_COMPRA(numero_nota_fiscal, data_hora, cpf_cliente, codigo_filial, matricula_funcionario, numero_caixa)
  SELECT            400, timestamp '2017-10-12 21:22:23', '123.456.789-01', 1, 100, 90 FROM dual
  UNION ALL SELECT  401, timestamp '2018-10-12 21:22:23', '123.456.789-01', 1, 100, 91 FROM dual
  UNION ALL SELECT  402, timestamp '2019-10-12 21:22:23', '234.567.890-12', 2, 300, 91 FROM dual
  UNION ALL SELECT  403, timestamp '2020-10-12 21:22:23', '234.567.890-12', 3, 300, 92 FROM dual
  UNION ALL SELECT  404, timestamp '2021-10-12 21:22:23', '567.890.123-45', 4, 100, 93 FROM dual
;

INSERT INTO ITEM(identificador, num_nota_fiscal_ordem, numero_nota_fiscal, quantidade, preco_produto, desconto)
  SELECT             1000, 400, 800, 10, 100.00, 0 FROM dual
  UNION ALL SELECT   2000, 401, 801, 9, 2.50, 0 FROM dual
  UNION ALL SELECT   3000, 402, 802, 9, 200.00, 0 FROM dual
  UNION ALL SELECT   4000, 403, 803, 9, 1.00, 0 FROM dual
  UNION ALL SELECT   5000, 404, 804, 9, 999.00, 0 FROM dual
;

-- REALIZA_RECLAMACAO

UPDATE FUNCIONARIO f SET f.codigo_filial = 1, f.matricula_supervisor = 100 WHERE f.matricula = 100;
UPDATE FUNCIONARIO g SET g.codigo_filial = 1, g.matricula_supervisor = 100 WHERE g.matricula = 200;
UPDATE FUNCIONARIO h SET h.codigo_filial = 2, h.matricula_supervisor = 500 WHERE h.matricula = 300; 
UPDATE FUNCIONARIO i SET i.codigo_filial = 3, i.matricula_supervisor = 600 WHERE i.matricula = 400;
UPDATE FUNCIONARIO j SET j.codigo_filial = 4, j.matricula_supervisor = 200 WHERE j.matricula = 500;
UPDATE FUNCIONARIO k SET k.codigo_filial = 5, k.matricula_supervisor = 200 WHERE k.matricula = 600;
