DROP FUNCTION IF EXISTS TRANSFERENCIA(FLOAT, INT, INT);
-- FALTA VALIDAR SE A CONTA EXISTE, E SE NO CASO DO SAQUE EXISTE SALDO O SUFICIENTE
CREATE OR REPLACE FUNCTION TRANSFERENCIA(VALOR FLOAT, CONTA_ORIGEM INT, CONTA_DESTINO INT) RETURNS VOID AS $$
BEGIN
    IF (VALOR <= 0) THEN
        RAISE EXCEPTION 'OBRIGATORIO PASSAGEM DE UM VALOR POSITIVO!';
    END IF;

    INSERT INTO TRANSFERENCIA VALUES(DEFAULT, CONTA_ORIGEM, CONTA_DESTINO, VALOR);

    UPDATE CONTA SET SALDO = SALDO - VALOR WHERE ID_CONTA = CONTA_ORIGEM;
    UPDATE CONTA SET SALDO = SALDO + VALOR WHERE ID_CONTA = CONTA_DESTINO;

END;
$$ LANGUAGE PLPGSQL;

DROP FUNCTION IF EXISTS TRANSFERENCIA(FLOAT, TEXT, TEXT);
-- FALTA VALIDAR SE A CONTA EXISTE, E SE NO CASO DO SAQUE EXISTE SALDO O SUFICIENTE
CREATE OR REPLACE FUNCTION TRANSFERENCIA(VALOR FLOAT, NOME_ORIGEM TEXT, NOME_DESTINO TEXT) RETURNS VOID AS $$
DECLARE 
    CONTA_ORIGEM INT;
    CONTA_DESTINO INT;
BEGIN
    SELECT GET_ID_CONTA(NOME_ORIGEM) INTO CONTA_ORIGEM;
    SELECT GET_ID_CONTA(NOME_DESTINO) INTO CONTA_DESTINO;

    PERFORM TRANSFERENCIA(VALOR, CONTA_ORIGEM, CONTA_DESTINO);
END;
$$ LANGUAGE PLPGSQL;
