DROP FUNCTION IF EXISTS TRANSFERENCIA(FLOAT, TEXT, TEXT);
-- FALTA VALIDAR SE A CONTA EXISTE, E SE NO CASO DO SAQUE EXISTE SALDO O SUFICIENTE
CREATE OR REPLACE FUNCTION TRANSFERENCIA(VALOR FLOAT, CONTA_ORIGEM TEXT, CONTA_DESTINO TEXT) RETURNS VOID AS $$
BEGIN
    IF (VALOR <= 0) THEN
        RAISE EXCEPTION 'OBRIGATORIO PASSAGEM DE UM VALOR POSITIVO!';
    END IF;

    UPDATE CONTA SET SALDO = SALDO - VALOR WHERE ID_CONTA = CONTA_ORIGEM::INT;
    UPDATE CONTA SET SALDO = SALDO + VALOR WHERE ID_CONTA = CONTA_DESTINO::INT;

    INSERT INTO TRANSFERENCIA VALUES(DEFAULT, CONTA_ORIGEM::INT, CONTA_DESTINO::INT, VALOR);
END;
$$ LANGUAGE PLPGSQL;

