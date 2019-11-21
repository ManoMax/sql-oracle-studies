-- Entidade

CREATE TABLE CLIENTE (
    cpf CHAR(11) NOT NULL,
    nome varchar(50) NOT NULL,
    email varchar(30) NOT NULL,
    crm INT NOT NULL,
    rua varchar(50) NOT NULL,
    num varchar(5) NOT NULL,
    bairro varchar(20) NOT NULL,
    cidade varchar(20) NOT NULL,
    estado varchar(20) NOT NULL,
    PRIMARY KEY (cpf)
);
-- Atributo Multivalorado
CREATE TABLE TELEFONE_CLIENTE (
    cpfCliente CHAR(11) NOT NULL,
    numero VARCHAR(15) NOT NULL,
    FOREIGN KEY(cpfCliente) REFERENCES CLIENTE(cpf),
    PRIMARY KEY (cpfCliente, numero)
);

CREATE TABLE FUNCIONARIO (
    matricula INT NOT NULL,
    cpf CHAR(11) NOT NULL,
    identidade CHAR(7) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    endereco VARCHAR(50) NOT NULL,
    salario NUMERIC(6,2) NOT NULL,
    funcao VARCHAR(15) NOT NULL,
    -- relacionamento
    matrSupervisor INT,
    idFilial INT NOT NULL,
    PRIMARY KEY (matricula),
    CHECK (salario > 0)
);
-- Atributo Multivalorado
CREATE TABLE TELEFONE_FUNCIONARIO (
    matFunc INT NOT NULL,
    numero VARCHAR(15) NOT NULL,
    FOREIGN KEY(matFunc) REFERENCES FUNCIONARIO(matricula),
    PRIMARY KEY (matFunc, numero)
);
-- Entidade Fraca
CREATE TABLE DEPENDENTE_FUNCIONARIO (
    cpf CHAR(11) NOT NULL,
    nascimento DATE NOT NULL,
    nome VARCHAR(50) NOT NULL,
    -- relacionamento
    matFunc INT NOT NULL,
    FOREIGN KEY(matFunc) REFERENCES FUNCIONARIO(matricula),
    PRIMARY KEY (matFunc, cpf)
);

CREATE TABLE FILIAL (
    idFilial INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    endereco VARCHAR(50) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    -- relacionamento
    gerente INT NOT NULL,
    FOREIGN KEY(gerente) REFERENCES FUNCIONARIO(matricula),
    PRIMARY KEY (idFilial)
);

CREATE TABLE CAIXA (
    numCaixa INT NOT NULL,
    -- relacionamento
    idFilial INT NOT NULL,
    FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial),
    PRIMARY KEY (numCaixa)
);

-- Entidade Fraca
CREATE TABLE EQUIPAMENTO (
    idEquip INT NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    -- relacionamento
    numCaixa INT NOT NULL,
    FOREIGN KEY(numCaixa) REFERENCES CAIXA(numCaixa),
    PRIMARY KEY(idEquip, numCaixa)
);

CREATE TABLE MARCA_PRODUTO (
    idMarca INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    PRIMARY KEY(idMarca)
);
CREATE TABLE CATEGORIA_PRODUTO (
    idCategoria INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    PRIMARY KEY(idCategoria)
);
CREATE TABLE PRODUTO (
    idProduto INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    descricao VARCHAR(50) NOT NULL,
    margemLucro NUMERIC(6,2) NOT NULL,
    -- Estoque
    idFilial INT NOT NULL,
    dataCompra DATE NOT NULL,
    dataValidade DATE NOT NULL,
    precoCompra NUMERIC(6,2) NOT NULL,
    precoVenda NUMERIC(6,2) NOT NULL,
    quantidade INT NOT NULL,
    -- relacionamento
    idMarca INT NOT NULL,
    idCategoria INT NOT NULL,
    FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial),
    FOREIGN KEY(idMarca) REFERENCES MARCA_PRODUTO(idMarca),
    FOREIGN KEY(idCategoria) REFERENCES CATEGORIA_PRODUTO(idCategoria),
    PRIMARY KEY(idProduto)
);

CREATE TABLE ORDEM_DE_COMPRA (
    numNotaFiscal INT NOT NULL,
    data TIMESTAMP NOT NULL,
    -- relacionamento
    numCaixa INT NOT NULL,
    cpfCliente CHAR(11) NOT NULL,
    idFilial INT NOT NULL,
    matFuncionario INT NOT NULL,
    FOREIGN KEY(numCaixa) REFERENCES CAIXA(numCaixa),
    FOREIGN KEY(cpfCliente) REFERENCES CLIENTE(cpf),
    FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial),
    FOREIGN KEY(matFuncionario) REFERENCES FUNCIONARIO(matricula),
    PRIMARY KEY(numNotaFiscal)
);

CREATE TABLE NOTA_FISCAL(
    numero INT NOT NULL,
    cnpj CHAR(14) NOT NULL,
    quantidade INT NOT NULL,
    dataCompra DATE NOT NULL,
    valorPorItem NUMERIC (6,2) NOT NULL,
    PRIMARY KEY(numero)
);

CREATE TABLE ITEM_DE_COMPRA (
    idItemComprado INT NOT NULL,
    quantidade INT NOT NULL,
    precoProd NUMERIC(6,2) NOT NULL,
    desconto NUMERIC(6,2) NOT NULL,
    -- relacionamento
    idProduto INT NOT NULL,
    notaFiscalOrdemDeCompra INT NOT NULL,
    numNotaFiscal INT NOT NULL,
    FOREIGN KEY(idProduto) REFERENCES PRODUTO(idProduto),
    FOREIGN KEY(notaFiscalOrdemDeCompra) REFERENCES ORDEM_DE_COMPRA(numNotaFiscal),
    FOREIGN KEY(numNotaFiscal) REFERENCES NOTA_FISCAL(numero),
    PRIMARY KEY(idItemComprado)
);

CREATE TABLE FORNECEDORES(
    cnpj CHAR(14) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    endereco VARCHAR(50) NOT NULL,
    email VARCHAR(30) NOT NULL,
    site VARCHAR(50) NOT NULL,
    -- relacionamento
    idCategoria INT NOT NULL,
    FOREIGN KEY(idCategoria) REFERENCES CATEGORIA_PRODUTO(idCategoria),
    PRIMARY KEY(cnpj)
);
-- Atributo Multivalorado
CREATE TABLE TELEFONE_FORNECEDORES(
    cnpjFornecedor CHAR(14) NOT NULL,
    numero VARCHAR(15) NOT NULL,
    FOREIGN KEY(cnpjFornecedor) REFERENCES FORNECEDORES(cnpj),
    PRIMARY KEY (cnpjFornecedor, numero)
);

CREATE TABLE SOLICITACAO(
    idSolicitacao INT NOT NULL,
    dataSolicitacao DATE NOT NULL,
    dataPrevistaEntrega DATE NOT NULL,
    dataEntrega DATE NOT NULL,
    valorCompra NUMERIC(6,2) NOT NULL, 
    prazoPagamento INT NOT NULL,
    -- relacionamento
    idFilial INT NOT NULL,
    numNotaFiscal INT NOT NULL,
    cnpjFornecedor CHAR(14) NOT NULL,
    FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial),
    FOREIGN KEY(numNotaFiscal) REFERENCES NOTA_FISCAL(numero),
    FOREIGN KEY(cnpjFornecedor) REFERENCES FORNECEDORES(cnpj),
    PRIMARY KEY(idSolicitacao)
);

-- Relacionamentos

CREATE TABLE RECLAMACAO_CLIENTE_FILIAL (
    data DATE NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    -- relacionamento
    cpfCliente CHAR(11) NOT NULL,
    idFilial INT NOT NULL,
    FOREIGN KEY(cpfCliente) REFERENCES CLIENTE(cpf),
    FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial),
    PRIMARY KEY(cpfCliente, idFilial)
);

CREATE TABLE PLANO_DE_MANUTENCAO (
    descManutencao VARCHAR(150) NOT NULL,
    data DATE NOT NULL,
    custo NUMERIC(5,2) NOT NULL,
    -- relacionamento
    idEquip INT NOT NULL,
    numCaixa INT NOT NULL,
    matrFuncionario INT NOT NULL,
    FOREIGN KEY(idEquip, numCaixa) REFERENCES EQUIPAMENTO(idEquip, numCaixa),
    FOREIGN KEY(matrFuncionario) REFERENCES FUNCIONARIO(matricula),
    PRIMARY KEY(numCaixa, idEquip, matrFuncionario)
);


-- Referenciamentos / Contratos

ALTER TABLE FUNCIONARIO ADD CONSTRAINT MatrSupervisorFuncionario FOREIGN KEY(matrSupervisor) REFERENCES FUNCIONARIO(matricula);
ALTER TABLE FUNCIONARIO ADD CONSTRAINT IdFilialDoFuncionario FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial);
