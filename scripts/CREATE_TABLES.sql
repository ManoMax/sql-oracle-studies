-- Entidades

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
    matrSupervisor INT,
    idFilial INT NOT NULL,
    PRIMARY KEY (matricula),
    CHECK (salario > 0)
);
CREATE TABLE TELEFONE_FUNCIONARIO (
    matFunc INT NOT NULL,
    numero VARCHAR(15) NOT NULL,
    FOREIGN KEY(matFunc) REFERENCES FUNCIONARIO(matricula),
    PRIMARY KEY (matFunc, numero)
);
CREATE TABLE DEPENDENTE_FUNCIONARIO (
    cpf CHAR(11) NOT NULL,
    matFunc INT NOT NULL,
    nascimento DATE NOT NULL,
    nome VARCHAR(50) NOT NULL,
    FOREIGN KEY(matFunc) REFERENCES FUNCIONARIO(matricula),
    PRIMARY KEY (matFunc, cpf)
);

CREATE TABLE FILIAL (
    idFilial INT NOT NULL,
    gerente INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    endereco VARCHAR(50) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    FOREIGN KEY(gerente) REFERENCES FUNCIONARIO(matricula),
    PRIMARY KEY (idFilial)
);

CREATE TABLE CAIXA (
    numCaixa INT NOT NULL,
    idFilial INT NOT NULL,
    FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial),
    PRIMARY KEY (numCaixa)
);

CREATE TABLE EQUIPAMENTO (
    idEquip INT NOT NULL,
    numCaixa INT NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    FOREIGN KEY(numCaixa) REFERENCES CAIXA(numCaixa),
    PRIMARY KEY(idEquip, numCaixa)
);

CREATE TABLE PRODUTO (
    idProduto INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    descricao VARCHAR(50) NOT NULL,
    margemLucro NUMERIC(6,2) NOT NULL,
    PRIMARY KEY(idProduto)
);
CREATE TABLE CATEGORIA_PRODUTO (
    idCategoria INT NOT NULL,
    idProduto INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    FOREIGN KEY(idProduto) REFERENCES PRODUTO(idProduto),
    PRIMARY KEY(idCategoria)
);
CREATE TABLE MARCA_PRODUTO (
    idMarca INT NOT NULL,
    idProduto INT NOT NULL, --
    nome VARCHAR(20) NOT NULL,
    FOREIGN KEY(idProduto) REFERENCES PRODUTO(idProduto),
    PRIMARY KEY(idMarca)
);

CREATE TABLE ORDEM_DE_COMPRA (
    numNotaFiscal INT NOT NULL,
    cpfCliente CHAR(11) NOT NULL,
    matFuncionario INT NOT NULL,
    idFilial INT NOT NULL,
    numCaixa INT NOT NULL,
    data DATE NOT NULL,
    FOREIGN KEY(cpfCliente) REFERENCES CLIENTE(cpf),
    FOREIGN KEY(matFuncionario) REFERENCES FUNCIONARIO(matricula),
    FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial),
    FOREIGN KEY(numCaixa) REFERENCES CAIXA(numCaixa),
    PRIMARY KEY(numNotaFiscal)
);

CREATE TABLE NOTA_FISCAL(
    idNotaFiscal INT NOT NULL,
    cnpj CHAR(14) NOT NULL,
    quantidade INT NOT NULL,
    dataCompra DATE NOT NULL,
    valorCompra NUMERIC (6,2) NOT NULL,
    PRIMARY KEY(idNotaFiscal)
);

CREATE TABLE ITEM_DE_COMPRA (
    idItemComprado INT NOT NULL,
    numNotaFiscal INT NOT NULL,
    quantidade INT NOT NULL,
    precoProd NUMERIC(6,2) NOT NULL,
    desconto NUMERIC(6,2) NOT NULL,
    FOREIGN KEY(numNotaFiscal) REFERENCES ORDEM_DE_COMPRA(numNotaFiscal),
    FOREIGN KEY(numNotaFiscal) REFERENCES NOTA_FISCAL(idNotaFiscal),
    PRIMARY KEY(idItemComprado)
);

CREATE TABLE SOLICITACAO(
    idSolicitacao INT NOT NULL,
    dataSolicitacao DATE NOT NULL,
    dataPrevistaEntrega DATE NOT NULL,
    dataEntrega DATE NOT NULL,
    valorCompra NUMERIC(6,2) NOT NULL, 
    prazoPagamento INT NOT NULL,
    codFilial INT NOT NULL,
    idNotaFiscal INT NOT NULL,
    FOREIGN KEY(idNotaFiscal) REFERENCES NOTA_FISCAL(idNotaFiscal),
    PRIMARY KEY(idSolicitacao) -- Recebe Fornecedor
);

CREATE TABLE FORNECEDORES(
    cnpj CHAR(14) NOT NULL,
    idCategoria INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    endereco VARCHAR(50) NOT NULL,
    email VARCHAR(30) NOT NULL,
    site VARCHAR(50) NOT NULL,
    PRIMARY KEY(cnpj)
);
CREATE TABLE TELEFONE_FORNECEDORES(
    cnpjFornecedor CHAR(14) NOT NULL,
    numero VARCHAR(15) NOT NULL,
    PRIMARY KEY (cnpjFornecedor, numero)
);

-- Relacionamentos

CREATE TABLE FUNCIONARIO_POR_FILIAL (
    matFunc INT NOT NULL,
    idFilial INT NOT NULL,
    FOREIGN KEY(matFunc) REFERENCES FUNCIONARIO(matricula),
    FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial),
    PRIMARY KEY (matFunc, idFilial)
    --
);

CREATE TABLE RECLAMACAO_CLIENTE_FILIAL (
    cpfCliente CHAR(11) NOT NULL,
    idFilial INT NOT NULL,
    data DATE NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    FOREIGN KEY(cpfCliente) REFERENCES CLIENTE(cpf),
    FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial),
    PRIMARY KEY(cpfCliente, idFilial)
);

CREATE TABLE PLANO_DE_MANUTENCAO (
    numCaixa INT NOT NULL,
    idEquip INT NOT NULL,
    idFuncionario INT NOT NULL,
    descManutencao VARCHAR(150) NOT NULL,
    data DATE NOT NULL,
    custo NUMERIC(5,2) NOT NULL,
    FOREIGN KEY(numCaixa) REFERENCES CAIXA(numCaixa),
    FOREIGN KEY(idEquip, numCaixa) REFERENCES EQUIPAMENTO(idEquip, numCaixa),
    PRIMARY KEY(numCaixa, idEquip, idFuncionario)
);

CREATE TABLE PRODUTO_POR_FILIAL (
    idFilial INT NOT NULL,
    idProduto INT NOT NULL,
    dataCompra DATE NOT NULL,
    dataValidade DATE NOT NULL,
    precoCompra NUMERIC(6,2) NOT NULL,
    precoVenda NUMERIC(6,2) NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial),
    FOREIGN KEY(idProduto) REFERENCES PRODUTO(idProduto),
    PRIMARY KEY(idFilial, idProduto)
    --
);


-- Referenciamentos / Contratos

ALTER TABLE FUNCIONARIO ADD CONSTRAINT MatrSupervisorFuncionario FOREIGN KEY(matrSupervisor) REFERENCES FUNCIONARIO(matricula);

ALTER TABLE FUNCIONARIO ADD CONSTRAINT IdFilialDoFuncionario FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial);

ALTER TABLE FORNECEDORES ADD CONSTRAINT IdCategoriaFornecedor FOREIGN KEY(idCategoria) REFERENCES CATEGORIA_PRODUTO(idCategoria);
ALTER TABLE TELEFONE_FORNECEDORES ADD CONSTRAINT CnpjFornecedorTelefone FOREIGN KEY(cnpjFornecedor) REFERENCES FORNECEDORES(cnpj);
