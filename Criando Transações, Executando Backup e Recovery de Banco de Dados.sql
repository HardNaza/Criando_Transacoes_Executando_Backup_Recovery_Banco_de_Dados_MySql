####################
## 1 - TRANSAÇÕES ##
####################
-- Desabilitar o autocommit
SET autocommit = 0;

-- Iniciar a transação
START TRANSACTION;

-- Executar instruções SQL
INSERT INTO e_commerce.address (road, cep, neighborhood, number, city, state)
VALUES ('Rua A', '12345', 'Bairro A', '1', 'Cidade A', 'Estado A');

UPDATE e_commerce.product
SET price = '19.99'
WHERE idproduct = 1;

-- Confirmar a transação
COMMIT;

-------------------
-- comando ROLLBACK
-------------------

-- Desabilitar o autocommit
SET autocommit = 0;

-- Iniciar a transação
START TRANSACTION;

-- Executar instruções SQL
INSERT INTO e_commerce.address (road, cep, neighborhood, number, city, state)
VALUES ('Rua A', '12345', 'Bairro A', '1', 'Cidade A', 'Estado A');

-- Verificar se ocorreu algum erro
IF FOUND_ROWS() > 0 THEN
  -- Cancelar a transação e desfazer as alterações
  ROLLBACK;
ELSE
  -- Confirmar a transação
  COMMIT;
END IF;

#################################
## 2 - TRANSAÇÃO COM PROCEDURE ##
#################################

DELIMITER //

CREATE PROCEDURE e_commerce.insert_customer(
  IN p_first_name VARCHAR(10),
  IN p_last_name VARCHAR(20),
  IN p_CPF CHAR(11),
  IN p_road VARCHAR(45),
  IN p_cep VARCHAR(45),
  IN p_neighborhood VARCHAR(45),
  IN p_number VARCHAR(45),
  IN p_city VARCHAR(45),
  IN p_state VARCHAR(45)
)
BEGIN
  
  -- Desabilitar o autocommit
  SET autocommit = 0;

  -- Iniciar a transação
  START TRANSACTION;
  
  -- Variável para verificar se ocorreu algum erro
  DECLARE error_occurred INT DEFAULT 0;

  -- Inserir endereço
  INSERT INTO e_commerce.address (road, cep, neighborhood, number, city, state)
  VALUES (p_road, p_cep, p_neighborhood, p_number, p_city, p_state);
  
  -- Verificar se ocorreu algum erro
  IF FOUND_ROWS() = 0 THEN
    SET error_occurred = 1;
  END IF;

  -- Inserir cliente individual
  IF error_occurred = 0 THEN
    INSERT INTO e_commerce.individual_customer (first_name, last_name, CPF, address_idaddress)
    VALUES (p_first_name, p_last_name, p_CPF, LAST_INSERT_ID());
    
    -- Verificar se ocorreu algum erro
    IF FOUND_ROWS() = 0 THEN
      SET error_occurred = 1;
    END IF;
  END

#####################################################
## 3 - BACKUP E RECUPERAÇÃO (VIA LINHA DE COMANDO) ##
#####################################################
-- OBS: NÃO FOI REALIZADA A INSTALAÇÃO DO MySQL EM MINHA MAQUINA, DESTE MODO ESTAREI ENVIANDO O PASSO A PASSO PARA REALIZAÇÃO DO BKP + INSERT DOS DADOS
--------------------------------------------------------------------
-- Backup Físico (cópia dos arquivos do banco de dados) Via Terminal
--------------------------------------------------------------------
1. Abra o terminal no seu sistema operacional.

2. Acesse o diretório onde os arquivos de banco de dados estão armazenados. O caminho pode variar dependendo do sistema operacional e da instalação do MySQL.

3. Faça uma cópia dos arquivos de dados do banco de dados "e-commerce" para um diretório de backup:
cp -R /caminho/para/dados/e-commerce /caminho/do/diretorio/de/backup/
Certifique-se de substituir "/caminho/para/dados/e-commerce" pelo caminho correto dos arquivos de dados do banco de dados "e-commerce" e "/caminho/do/diretorio/de/backup/" pelo diretório de backup desejado.

--------------------------------------------------
-- Backup Lógico (uso do `mysqldump`) Via Terminal
--------------------------------------------------
1. Abra o terminal no seu sistema operacional.

2. Certifique-se de que você tem o utilitário `mysqldump` instalado e configurado corretamente.

3. Para fazer um backup lógico do banco de dados "e-commerce" com todas as tabelas, procedimentos, eventos e outros recursos, execute o seguinte comando:
mysqldump -u seu_usuario -p --routines --events e-commerce > backup.sql
Certifique-se de substituir "seu_usuario" pelo nome de usuário correto para acessar o banco de dados. O comando solicitará sua senha do MySQL.
O comando irá gerar um arquivo chamado "backup.sql" contendo todas as instruções SQL necessárias para restaurar o banco de dados "e-commerce" juntamente com seus recursos.

----------------------
-- Via MySQL Workbench
----------------------
1. Abra o MySQL Workbench e conecte-se ao servidor de banco de dados.

2. Selecione o banco de dados "e-commerce" na lista de bancos de dados.

3. Clique com o botão direito do mouse no banco de dados "e-commerce" e selecione "Backup".

4. Na janela de backup, selecione os objetos que você deseja incluir no backup, como tabelas, procedimentos armazenados, eventos, etc.

5. Escolha um local para salvar o arquivo de backup e clique em "Iniciar Backup".
O MySQL Workbench irá gerar um arquivo de backup contendo todas as informações e recursos selecionados.

-- OBS: REPITA ESSES PASSOS PARA FAZER O BACKUP E RECOVERY DE DIFERENTES BANCOS DE DADOS, ALTERANDO O NOME DO BANCO DE DADOS NO COMANDO DE BACKUP E NO COMANDO DE RECOVERY, BEM COMO O NOME DO ARQUIVO DE BACKUP.

#################################################
## 4 - QUERYS PARA INSERÇÃO DOS DADOS NO BANCO ##
#################################################
----------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "ADDRESS"
----------------------------------------
INSERT INTO e_commerce.address (road, cep, neighborhood, number, city, state)
VALUES ('Rua das Flores', '12345-678', 'Centro', '100', 'São Paulo', 'SP');

----------------------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "INDIVIDUAL_CUSTOMER"
----------------------------------------------------
INSERT INTO e_commerce.individual_customer (first_name, middle_name, last_name, CPF, date_of_birth, phone, address_idaddress)
VALUES ('Maria', 'A.', 'Silva', '12345678901', '1990-05-10', '987654321', 1);

-----------------------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "CREDIT_DEBIT_PAYMENT"
-----------------------------------------------------
INSERT INTO e_commerce.credit_debit_payment (cardholder_name, card_number, expiration_date, security_code)
VALUES ('Fulano de Tal', '1234567890123456', '2025-12-31', '123');

----------------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "PAYMENT_MONEY"
----------------------------------------------
INSERT INTO e_commerce.payment_money (amount_received, change_value)
VALUES ('100.00', '20.00');

-----------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "DELIVERY"
-----------------------------------------
INSERT INTO e_commerce.delivery (delivery_code, status)
VALUES ('D123456', 'Em Processamento');

-------------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "DEPARTMENT"
-------------------------------------------
INSERT INTO e_commerce.Department (idDepartment, Department_name, Description, number_of_employees)
VALUES (1, 'Sales', 'Sales Department', 10);

---------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "SELLER"
---------------------------------------
INSERT INTO e_commerce.seller (seller_name, cpf, registration, hiring_date, function, salary, Department_idDepartment)
VALUES ('José', '98765432101', 1234, '2020-01-01', 'Sales Manager', 5000.00, 1);

--------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "ORDER"
--------------------------------------
INSERT INTO e_commerce.order (status_order, description, freight, quantity_of_orders, credit_debit_payment_idcredit_debit_payment, payment_money_idpayment_money, delivery_iddelivery, seller_idseller)
VALUES ('Em andamento', 'Order 1', 10.00, 1, 1, 1, 1, 1);

----------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "PRODUCT"
----------------------------------------
INSERT INTO e_commerce.product (category, description, price)
VALUES ('Electronics', 'Smartphone', '999.99');

-----------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "SUPPLIER"
-----------------------------------------
INSERT INTO e_commerce.supplier (idsupplier, corporate_name, CNPJ, phone, address_idaddress)
VALUES (1, 'Fornecedor X', '12345678901234', '987654321', 1);

-------------------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "PRODUCT_SUPPLIER"
-------------------------------------------------
INSERT INTO e_commerce.product_supplier (Fornecedor_idFornecedor, amount, product_idproduct)
VALUES (1, 100, 1);

----------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "DEPOSIT"
----------------------------------------
INSERT INTO e_commerce.deposit (iddeposit, amount, address_idaddress)
VALUES (1, 500, 1);

------------------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "PRODUCT_DEPOSIT"
------------------------------------------------
INSERT INTO e_commerce.product_deposit (location, product_idproduct, deposit_iddeposit)
VALUES (1, 1, 1);

------------------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "DISCOUNT_COUPON"
------------------------------------------------
INSERT INTO e_commerce.discount_coupon (code, discount_percentage, expiration_date)
VALUES ('COUPON123', 10, '2023-12-31');

---------------------------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "CUSTOMER_DISCOUNT_COUPON"
---------------------------------------------------------
INSERT INTO e_commerce.customer_discount_coupon (Individual_customer_idIndividual_customer, Discount_coupon_idDiscount_coupon)
VALUES (1, 1);

-----------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "CATEGORY"
-----------------------------------------
INSERT INTO e_commerce.category (idCategory, category_name)
VALUES (1, 'Electronics');

-------------------------------------------------
-- INSERÇÃO DE DADOS NA TABELA "PRODUCT_CATEGORY"
-------------------------------------------------
INSERT INTO e_commerce.product_category (Product_idProduct, Category_idCategory)
VALUES (1, 1);