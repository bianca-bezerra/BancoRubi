DROP FUNCTION IF EXISTS SAQUEDEPOSITO(FLOAT, TEXT, TEXT);
-- FALTA VALIDAR SE A CONTA EXISTE, E SE NO CASO DO SAQUE EXISTE SALDO O SUFICIENTE
CREATE OR REPLACE FUNCTION SAQUEDEPOSITO(VALOR FLOAT, _ID_CONTA TEXT, TIPO TEXT) RETURNS VOID AS $$
BEGIN
    IF (VALOR <= 0) THEN
        RAISE EXCEPTION 'OBRIGATORIO PASSAGEM DE UM VALOR POSITIVO!';
    END IF;

    IF (TIPO ILIKE 'S') THEN
        UPDATE CONTA SET SALDO = SALDO - VALOR WHERE ID_CONTA = _ID_CONTA::INT;

    ELSIF (TIPO ILIKE 'D') THEN
        UPDATE CONTA SET SALDO = SALDO + VALOR WHERE ID_CONTA = _ID_CONTA::INT;
    ELSE
        RAISE EXCEPTION 'OPERAÇÃO NÃO PERMITIDA!';
    END IF;

    INSERT INTO SAQUEDEPOSITO VALUES(DEFAULT, _ID_CONTA::INT, TIPO, VALOR, DEFAULT);
END;

$$ LANGUAGE PLPGSQL;