-- CADASTRAR CLIENTE
CREATE OR REPLACE FUNCTION INSERTO (NUM_AGENCIA INTEGER, CPF INTEGER, 
                                    NOME TEXT, ENDERECO TEXT, 
                                    DT_NASC DATE, TELEFONE TEXT) 
RETURNS VOID AS $$ 
DECLARE
    ID_NOVO_CLIENTE INT;
BEGIN 
    INSERT INTO CLIENTE VALUES(DEFAULT,CPF,NOME,ENDERECO,DT_NASC,TELEFONE);
    SELECT MAX(ID_CLIENTE) INTO ID_NOVO_CLIENTE FROM CLIENTE;
    INSERT INTO CONTA VALUES(DEFAULT, ID_NOVO_CLIENTE, NUM_AGENCIA, DEFAULT, DEFAULT);
END; 
$$ 
LANGUAGE PLPGSQL;

-- CADASTRAR BANCO
CREATE OR REPLACE FUNCTION INSERTO (NOME TEXT) 
RETURNS VOID AS $$ 

BEGIN 
    INSERT INTO BANCO VALUES(DEFAULT,NOME);
END; 
$$ 
LANGUAGE PLPGSQL;

-- CADASTRAR AGENCIA
CREATE OR REPLACE FUNCTION INSERTO (ID_BANCO INTEGER,ENDERECO TEXT) 
RETURNS VOID AS $$ 

BEGIN 
    INSERT INTO AGENCIA VALUES(DEFAULT, ID_BANCO,ENDERECO);
END; 
$$ 
LANGUAGE PLPGSQL;

--CADASTRAR FUNCIONARIO
CREATE OR REPLACE FUNCTION INSERTO ( NOME TEXT,SALARIO FLOAT,NUM_AGENCIA INTEGER) 
RETURNS VOID AS $$ 

BEGIN 
    INSERT INTO FUNCIONARIO VALUES(NOME,SALARIO,NUM_AGENCIA);
END; 
$$ 
LANGUAGE PLPGSQL;

--CADASTRAR CARTAO
CREATE OR REPLACE FUNCTION INSERTO (ID_CONTA INTEGER, DT_ABERTURA TIMESTAMP,DT_FECHAMENTO TIMESTAMP,) 
RETURNS VOID AS $$ 
DECLARE
    DT_VAL TIMESTAMP;
    CVV INT;
BEGIN
    DT_VAL := DT_ABERTURA + INTERVAL '10 YEARS';
    CVV := FLOOR(RANDOM() * 900) + 100;
    INSERT INTO CARTAO VALUES(ID_CONTA,DT_VAL,CVV,DT_ABERTURA,DT_FECHAMENTO);
END; 
$$ 
LANGUAGE PLPGSQL;