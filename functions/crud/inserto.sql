-- CADASTRAR CLIENTE
CREATE OR REPLACE FUNCTION INSERTO (NUM_AGENCIA INTEGER, CPF TEXT, 
                                    NOME TEXT, ENDERECO TEXT, 
                                    DT_NASC DATE, TELEFONE VARCHAR(50)) 
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
CREATE OR REPLACE FUNCTION INSERTO (VARIADIC NOMES TEXT[]) 
RETURNS VOID AS $$ 
DECLARE
    NOME TEXT;
BEGIN 
    FOREACH NOME IN ARRAY NOMES LOOP
        INSERT INTO BANCO VALUES(DEFAULT,NOME);
    END LOOP;

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

CREATE OR REPLACE FUNCTION INSERTO(NOME_BANCO_ TEXT,ENDERECO TEXT) 
RETURNS VOID AS $$ 

DECLARE ID_BANCO_ INT; 
BEGIN 
	IF NOT EXISTS (SELECT 1 FROM BANCO WHERE NOME ILIKE NOME_BANCO_) THEN
		RAISE EXCEPTION 'NÃO FOI ENCONTRADO UM BANCO COM ESSE NOME!';
	END IF;
    SELECT ID_BANCO INTO ID_BANCO_ FROM BANCO WHERE NOME ILIKE NOME_BANCO_;
    INSERT INTO AGENCIA VALUES(DEFAULT, ID_BANCO_,ENDERECO);
END; 
$$ 
LANGUAGE PLPGSQL;


--CADASTRAR FUNCIONARIO
CREATE OR REPLACE FUNCTION INSERTO( NOME_ TEXT,SALARIO_ FLOAT,NUM_AGENCIA_ INTEGER) 
RETURNS VOID AS $$ 

BEGIN 
    INSERT INTO FUNCIONARIO(MATRICULA,NOME,SALARIO,NUM_AGENCIA) 
        VALUES(DEFAULT, NOME_,SALARIO_,NUM_AGENCIA_);
END; 
$$ 
LANGUAGE PLPGSQL;

--CADASTRAR CARTAO
DROP FUNCTION IF EXISTS INSERTO(INTEGER, INT);
CREATE OR REPLACE FUNCTION INSERTO (ID_CONTA INTEGER, _DIA_FECHAMENTO INT) 
RETURNS VOID AS $$ 
DECLARE
    DT_VAL TIMESTAMP;
    CVV INT;
BEGIN
    DT_VAL := CURRENT_TIMESTAMP + INTERVAL '10 YEARS';
    CVV := FLOOR(RANDOM() * 900) + 100;
    INSERT INTO CARTAO VALUES(DEFAULT, ID_CONTA,DT_VAL,CVV,_DIA_FECHAMENTO);
END; 
$$ 
LANGUAGE PLPGSQL;