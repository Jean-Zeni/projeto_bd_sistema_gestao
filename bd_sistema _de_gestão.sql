-- COMEÇO DA ESTRUTURAÇÃO DO BANCO DE DADOS
-------------------------------------------
-- -----------------------------------------------------
-- Schema sistema_de_gestao
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sistema_de_gestao` DEFAULT CHARACTER
SET
    utf8;

USE `sistema_de_gestao`;

-- -----------------------------------------------------
-- Table `sistema_de_gestao`.`tb_usuarios`
-- -----------------------------------------------------
CREATE TABLE
    IF NOT EXISTS `sistema_de_gestao`.`tb_usuarios` (
        `pk_id_usuario` INT NOT NULL AUTO_INCREMENT,
        `nome_usuario` VARCHAR(255) NOT NULL,
        `email_usuario` VARCHAR(255) NOT NULL,
        `senha_usuario` VARCHAR(255) NOT NULL,
        `cpf_usuario` VARCHAR(11) NOT NULL,
        `telefone` VARCHAR(15) NOT NULL,
        PRIMARY KEY (`pk_id_usuario`),
        UNIQUE INDEX `email_usuario_UNIQUE` (`email_usuario` ASC) VISIBLE,
        UNIQUE INDEX `cpf_usuario_UNIQUE` (`cpf_usuario` ASC) VISIBLE
    );

-- -----------------------------------------------------
-- Table `sistema_de_gestao`.`tb_contas`
-- -----------------------------------------------------
CREATE TABLE
    IF NOT EXISTS `sistema_de_gestao`.`tb_contas` (
        `pk_id_conta` INT NOT NULL AUTO_INCREMENT,
        `tipo_conta` VARCHAR(50) NOT NULL,
        `numero_conta` VARCHAR(100) NOT NULL,
        `agencia_conta` VARCHAR(55) NOT NULL,
        `fk_id_usuario` INT NOT NULL,
        PRIMARY KEY (`pk_id_conta`),
        UNIQUE INDEX `numero_conta_UNIQUE` (`numero_conta` ASC) VISIBLE,
        INDEX `fk_tb_contas_tb_usuarios_idx` (`fk_id_usuario` ASC) VISIBLE,
        CONSTRAINT `fk_tb_contas_tb_usuarios` FOREIGN KEY (`fk_id_usuario`) REFERENCES `sistema_de_gestao`.`tb_usuarios` (`pk_id_usuario`) ON DELETE CASCADE ON UPDATE NO ACTION
    );

-- -----------------------------------------------------
-- Table `sistema_de_gestao`.`tb_transacoes`
-- -----------------------------------------------------
CREATE TABLE
    IF NOT EXISTS `sistema_de_gestao`.`tb_transacoes` (
        `pk_id_transacao` INT NOT NULL AUTO_INCREMENT,
        `tipo_transacao` VARCHAR(8) NOT NULL,
        `quantidade_monetaria` DECIMAL(10, 2) NOT NULL,
        `fk_id_conta` INT NOT NULL,
        PRIMARY KEY (`pk_id_transacao`),
        INDEX `fk_tb_transacoes_tb_contas1_idx` (`fk_id_conta` ASC) VISIBLE,
        CONSTRAINT `fk_tb_transacoes_tb_contas1` FOREIGN KEY (`fk_id_conta`) REFERENCES `sistema_de_gestao`.`tb_contas` (`pk_id_conta`) ON DELETE CASCADE ON UPDATE NO ACTION
    );

-- -----------------------------------------------------
-- Table `sistema_de_gestao`.`tb_categorias`
-- -----------------------------------------------------
CREATE TABLE
    IF NOT EXISTS `sistema_de_gestao`.`tb_categorias` (
        `pk_id_categorias` INT NOT NULL AUTO_INCREMENT,
        `nome_categoria` VARCHAR(255) NOT NULL,
        `descricao_categoria` VARCHAR(255) NOT NULL,
        PRIMARY KEY (`pk_id_categorias`),
        UNIQUE INDEX `nome_categoria_UNIQUE` (`nome_categoria` ASC) VISIBLE
    );

-- -----------------------------------------------------
-- Table `sistema_de_gestao`.`tb_metas`
-- -----------------------------------------------------
CREATE TABLE
    IF NOT EXISTS `sistema_de_gestao`.`tb_metas` (
        `pk_id_metas` INT NOT NULL AUTO_INCREMENT,
        `descricao` VARCHAR(255) NOT NULL,
        `fk_id_conta` INT NOT NULL,
        PRIMARY KEY (`pk_id_metas`),
        INDEX `fk_tb_metas_tb_contas1_idx` (`fk_id_conta` ASC) VISIBLE,
        CONSTRAINT `fk_tb_metas_tb_contas1` FOREIGN KEY (`fk_id_conta`) REFERENCES `sistema_de_gestao`.`tb_contas` (`pk_id_conta`) ON DELETE CASCADE ON UPDATE NO ACTION
    );

-- -----------------------------------------------------
-- Table `sistema_de_gestao`.`tb_transacoes_has_tb_categorias`
-- -----------------------------------------------------
CREATE TABLE
    IF NOT EXISTS `sistema_de_gestao`.`tb_transacoes_has_tb_categorias` (
        `pk_id_transacao` INT NOT NULL,
        `pk_id_categorias` INT NOT NULL,
        PRIMARY KEY (`pk_id_transacao`, `pk_id_categorias`),
        INDEX `fk_tb_transacoes_has_tb_categorias_tb_categorias1_idx` (`pk_id_categorias` ASC) VISIBLE,
        INDEX `fk_tb_transacoes_has_tb_categorias_tb_transacoes1_idx` (`pk_id_transacao` ASC) VISIBLE,
        CONSTRAINT `fk_tb_transacoes_has_tb_categorias_tb_transacoes1` FOREIGN KEY (`pk_id_transacao`) REFERENCES `sistema_de_gestao`.`tb_transacoes` (`pk_id_transacao`) ON DELETE CASCADE ON UPDATE NO ACTION,
        CONSTRAINT `fk_tb_transacoes_has_tb_categorias_tb_categorias1` FOREIGN KEY (`pk_id_categorias`) REFERENCES `sistema_de_gestao`.`tb_categorias` (`pk_id_categorias`) ON DELETE CASCADE ON UPDATE NO ACTION
    );

-- -----------------------------------------------------
-- Table `sistema_de_gestao`.`tb_categorias_has_tb_metas`
-- -----------------------------------------------------
CREATE TABLE
    IF NOT EXISTS `sistema_de_gestao`.`tb_categorias_has_tb_metas` (
        `pk_id_categorias` INT NOT NULL,
        `pk_id_metas` INT NOT NULL,
        PRIMARY KEY (`pk_id_categorias`, `pk_id_metas`),
        INDEX `fk_tb_categorias_has_tb_metas_tb_metas1_idx` (`pk_id_metas` ASC) VISIBLE,
        INDEX `fk_tb_categorias_has_tb_metas_tb_categorias1_idx` (`pk_id_categorias` ASC) VISIBLE,
        CONSTRAINT `fk_tb_categorias_has_tb_metas_tb_categorias1` FOREIGN KEY (`pk_id_categorias`) REFERENCES `sistema_de_gestao`.`tb_categorias` (`pk_id_categorias`) ON DELETE CASCADE ON UPDATE NO ACTION,
        CONSTRAINT `fk_tb_categorias_has_tb_metas_tb_metas1` FOREIGN KEY (`pk_id_metas`) REFERENCES `sistema_de_gestao`.`tb_metas` (`pk_id_metas`) ON DELETE CASCADE ON UPDATE NO ACTION
    );

ALTER TABLE `sistema_de_gestao`.`tb_transacoes`
ADD COLUMN `data_transacao` VARCHAR(45) NOT NULL AFTER `fk_id_conta`;

ALTER TABLE `sistema_de_gestao`.`tb_transacoes` CHANGE COLUMN `data_transacao` `data_transacao` DATETIME NOT NULL AFTER `quantidade_monetaria`;

ALTER TABLE `sistema_de_gestao`.`tb_transacoes`
ADD COLUMN `descricao_transacao` VARCHAR(255) NULL AFTER `data_transacao`;

ALTER TABLE tb_metas
ADD COLUMN status_meta VARCHAR(30) not null;

UPDATE `sistema_de_gestao`.`tb_metas`
SET
    `status_meta` = 'não alcançada'
WHERE
    (`pk_id_metas` = '1');

UPDATE `sistema_de_gestao`.`tb_metas`
SET
    `status_meta` = 'não alcançada'
WHERE
    (`pk_id_metas` = '2');

UPDATE `sistema_de_gestao`.`tb_metas`
SET
    `status_meta` = 'alcançada'
WHERE
    (`pk_id_metas` = '3');

-------------------------------
--FIM DA ESTRUTURAÇÃO DA TABELA
-------------------------------
---------------------------------------
--COMEÇO DA INSERÇÃO DE DADOS NA TABELA
---------------------------------------
--TABELA DE USUÁRIOS
INSERT INTO
    `sistema_de_gestao`.`tb_usuarios` (
        `nome_usuario`,
        `email_usuario`,
        `senha_usuario`,
        `cpf_usuario`,
        `telefone`
    )
VALUES
    (
        'Jorge Almeida Flores',
        'jorAlmeida@gmail.com',
        '134031211',
        '11122233344',
        '51 99999-8888'
    );

INSERT INTO
    `sistema_de_gestao`.`tb_usuarios` (
        `nome_usuario`,
        `email_usuario`,
        `senha_usuario`,
        `cpf_usuario`,
        `telefone`
    )
VALUES
    (
        'Ambrósio da Cunha',
        'brobrosio@yahoo.com',
        '123456789',
        '22211133355',
        '51 92222-1111'
    );

INSERT INTO
    `sistema_de_gestao`.`tb_usuarios` (
        `nome_usuario`,
        `email_usuario`,
        `senha_usuario`,
        `cpf_usuario`,
        `telefone`
    )
VALUES
    (
        'Janete Kubischek',
        'jane@gmail.com',
        '987654321',
        '33322211156',
        '51 95454-2323'
    );

INSERT INTO
    `sistema_de_gestao`.`tb_usuarios` (
        `nome_usuario`,
        `email_usuario`,
        `senha_usuario`,
        `cpf_usuario`,
        `telefone`
    )
VALUES
    (
        'Alfredo da Silva',
        'alf@gmail.com',
        '987612345',
        '55566644421',
        '51 95544-3322'
    );

INSERT INTO
    `sistema_de_gestao`.`tb_usuarios` (
        `nome_usuario`,
        `email_usuario`,
        `senha_usuario`,
        `cpf_usuario`,
        `telefone`
    )
VALUES
    (
        'Maya Oliveira',
        'maya@yahoo.com',
        '321543645',
        '21234356567',
        '51 98778-3443'
    );

--TABELA DE CONTAS
INSERT INTO
    `sistema_de_gestao`.`tb_contas` (
        `tipo_conta`,
        `numero_conta`,
        `agencia_conta`,
        `fk_id_usuario`
    )
VALUES
    ('salário', '123123', 'Itau', '1');

INSERT INTO
    `sistema_de_gestao`.`tb_contas` (
        `tipo_conta`,
        `numero_conta`,
        `agencia_conta`,
        `fk_id_usuario`
    )
VALUES
    ('salário', '332123', 'Caixa', '2');

INSERT INTO
    `sistema_de_gestao`.`tb_contas` (
        `tipo_conta`,
        `numero_conta`,
        `agencia_conta`,
        `fk_id_usuario`
    )
VALUES
    ('corrente', '213331', 'Santander', '3');

INSERT INTO
    `sistema_de_gestao`.`tb_contas` (
        `tipo_conta`,
        `numero_conta`,
        `agencia_conta`,
        `fk_id_usuario`
    )
VALUES
    ('poupança', '243234', 'Banco do Brasil', '4');

INSERT INTO
    `sistema_de_gestao`.`tb_contas` (
        `tipo_conta`,
        `numero_conta`,
        `agencia_conta`,
        `fk_id_usuario`
    )
VALUES
    ('Pix', '231123', 'Agibank', '5');

INSERT INTO
    `sistema_de_gestao`.`tb_contas` (
        `tipo_conta`,
        `numero_conta`,
        `agencia_conta`,
        `fk_id_usuario`
    )
VALUES
    ('Pix', '312123', 'Caixa', '2');

INSERT INTO
    `sistema_de_gestao`.`tb_contas` (
        `tipo_conta`,
        `numero_conta`,
        `agencia_conta`,
        `fk_id_usuario`
    )
VALUES
    ('salário', '432432', 'Agibank', '5');

INSERT INTO
    `sistema_de_gestao`.`tb_contas` (
        `tipo_conta`,
        `numero_conta`,
        `agencia_conta`,
        `fk_id_usuario`
    )
VALUES
    ('poupança', '567576', 'Itau', '1');

INSERT INTO
    `sistema_de_gestao`.`tb_contas` (
        `tipo_conta`,
        `numero_conta`,
        `agencia_conta`,
        `fk_id_usuario`
    )
VALUES
    ('corrente', '212212', 'Santander', '3');

INSERT INTO
    `sistema_de_gestao`.`tb_contas` (
        `tipo_conta`,
        `numero_conta`,
        `agencia_conta`,
        `fk_id_usuario`
    )
VALUES
    ('Pix', '211112', 'Banco do Brasil', '4');

--TABELA DE CATEGORIAS
INSERT INTO
    `sistema_de_gestao`.`tb_categorias` (`nome_categoria`, `descricao_categoria`)
VALUES
    (
        'Transporte',
        'economias relacionadas com tipos de transporte'
    );

INSERT INTO
    `sistema_de_gestao`.`tb_categorias` (`nome_categoria`, `descricao_categoria`)
VALUES
    (
        'Alimentação',
        'economias relaciondas à alimentação. '
    );

INSERT INTO
    `sistema_de_gestao`.`tb_categorias` (`nome_categoria`, `descricao_categoria`)
VALUES
    ('Higiene', 'economias relacionadas à higiene');

INSERT INTO
    `sistema_de_gestao`.`tb_categorias` (`nome_categoria`, `descricao_categoria`)
VALUES
    ('Lazer', 'economias relacionadas ao lazer.');

INSERT INTO
    `sistema_de_gestao`.`tb_categorias` (`nome_categoria`, `descricao_categoria`)
VALUES
    (
        'Serviços Contratados',
        'economias relacionadas à serviços contratados.'
    );

INSERT INTO
    `sistema_de_gestao`.`tb_categorias` (`nome_categoria`, `descricao_categoria`)
VALUES
    (
        'Serviços Prestados',
        'economias relacionadas aos serviços pretados'
    );

INSERT INTO
    `sistema_de_gestao`.`tb_categorias` (`nome_categoria`, `descricao_categoria`)
VALUES
    (
        'Casa',
        'economias relacionadas àuilo que diz respeito ao lar (reformas, móveis, etc...).'
    )
INSERT INTO
    `sistema_de_gestao`.`tb_categorias` (`nome_categoria`, `descricao_categoria`)
VALUES
    (
        'investimentos',
        'economias relacionadas à investimentos'
    );

-- TABELA DE TRANSAÇÕES
INSERT INTO
    `sistema_de_gestao`.`tb_transacoes` (
        `tipo_transacao`,
        `quantidade_monetaria`,
        `data_transacao`,
        `descricao_transacao`,
        `fk_id_conta`
    )
VALUES
    ('Receita', '2000', '2024-05-03', 'Salário', '7');

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes` (
        `tipo_transacao`,
        `quantidade_monetaria`,
        `data_transacao`,
        `descricao_transacao`,
        `fk_id_conta`
    )
VALUES
    (
        'Despesa',
        '200',
        '2024-05-05',
        'Conta de Energia',
        '5'
    );

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes` (
        `tipo_transacao`,
        `quantidade_monetaria`,
        `data_transacao`,
        `descricao_transacao`,
        `fk_id_conta`
    )
VALUES
    (
        'Despesa',
        '120',
        '2024-05-05',
        'Conta de Internet',
        '5'
    );

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes` (
        `tipo_transacao`,
        `quantidade_monetaria`,
        `data_transacao`,
        `descricao_transacao`,
        `fk_id_conta`
    )
VALUES
    (
        'Despesa',
        '250',
        '2024-05-05',
        'Conta de Água',
        '5'
    );

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes` (
        `tipo_transacao`,
        `quantidade_monetaria`,
        `data_transacao`,
        `descricao_transacao`,
        `fk_id_conta`
    )
VALUES
    (
        'Receita',
        '200',
        '2024-05-07',
        'Corridas de Uber',
        '5'
    );

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes` (
        `tipo_transacao`,
        `quantidade_monetaria`,
        `data_transacao`,
        `descricao_transacao`,
        `fk_id_conta`
    )
VALUES
    (
        'Despesa',
        '100',
        '2024-05-10',
        'Compras de produto de higiene',
        '7'
    );

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes` (
        `tipo_transacao`,
        `quantidade_monetaria`,
        `data_transacao`,
        `descricao_transacao`,
        `fk_id_conta`
    )
VALUES
    ('Despesa', '500', '2024-05-12', 'Rancho', '5');

--TABELA CATEGORIAS/TRANSAÇÕES
INSERT INTO
    `sistema_de_gestao`.`tb_transacoes_has_tb_categorias` (`pk_id_transacao`, `pk_id_categorias`)
VALUES
    ('1', '6');

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes_has_tb_categorias` (`pk_id_transacao`, `pk_id_categorias`)
VALUES
    ('2', '5');

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes_has_tb_categorias` (`pk_id_transacao`, `pk_id_categorias`)
VALUES
    ('3', '5');

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes_has_tb_categorias` (`pk_id_transacao`, `pk_id_categorias`)
VALUES
    ('4', '5');

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes_has_tb_categorias` (`pk_id_transacao`, `pk_id_categorias`)
VALUES
    ('5', '6');

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes_has_tb_categorias` (`pk_id_transacao`, `pk_id_categorias`)
VALUES
    ('6', '3');

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes_has_tb_categorias` (`pk_id_transacao`, `pk_id_categorias`)
VALUES
    ('7', '2');

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes_has_tb_categorias` (`pk_id_transacao`, `pk_id_categorias`)
VALUES
    ('7', '3');

INSERT INTO
    `sistema_de_gestao`.`tb_transacoes_has_tb_categorias` (`pk_id_transacao`, `pk_id_categorias`)
VALUES
    ('7', '4');

--TABELA DE METAS
INSERT INTO
    `sistema_de_gestao`.`tb_metas` (`descricao`, `fk_id_conta`)
VALUES
    ('Economizr no gastos em lazer', '5');

INSERT INTO
    `sistema_de_gestao`.`tb_metas` (`descricao`, `fk_id_conta`)
VALUES
    ('Economizar em higiene', '5');

INSERT INTO
    `sistema_de_gestao`.`tb_metas` (`descricao`, `fk_id_conta`)
VALUES
    ('Fazer horas extras', '7');

--------------------------
-- TABELA CATEGORIAS/METAS
--------------------------
INSERT INTO
    `sistema_de_gestao`.`tb_categorias_has_tb_metas` (`pk_id_categorias`, `pk_id_metas`)
VALUES
    ('4', '1');

INSERT INTO
    `sistema_de_gestao`.`tb_categorias_has_tb_metas` (`pk_id_categorias`, `pk_id_metas`)
VALUES
    ('3', '2');

INSERT INTO
    `sistema_de_gestao`.`tb_categorias_has_tb_metas` (`pk_id_categorias`, `pk_id_metas`)
VALUES
    ('6', '3');

--------------------------------------
--FIM DA INSERÇÃO DE DADOS NAS TABELAS
--------------------------------------
-------------------
--CONSULTAS BÁSICAS
-------------------
SELECT
    *
FROM
    tb_contas
WHERE
    fk_id_usuario = 5;

SELECT
    *
FROM
    tb_usuarios
limit
    3;

SELECT
    nome_categoria
FROM
    sistema_de_gestao.tb_categorias
WHERE
    pk_id_categorias = 1;

SELECT
    descricao
FROM
    sistema_de_gestao.tb_metas
WHERE
    status_meta = 'alcançada';

SELECT
    descricao_transacao
FROM
    sistema_de_gestao.tb_transacoes
WHERE
    tipo_transacao = 'Receita';

---------------------------
--FIM DAS CONSULTAS BÁSICAS
---------------------------


