-- CRIAR
CREATE TRIGGER VALIDATE_CLI_INSERT_TR BEFORE INSERT ON CLIENTE
EXECUTE PROCEDURE

CREATE TRIGGER VALIDATE_SALDO BEFORE INSERT ON SAQUEDEPOSITO FOR EACH ROW
EXECUTE PROCEDURE VERIFICAR_SALDO('SAQUEDEPOSITO');

CREATE TRIGGER VALIDATE_SALDO BEFORE INSERT ON TRANSFERENCIA FOR EACH ROW
EXECUTE PROCEDURE VERIFICAR_SALDO('TRANSFERENCIA');

CREATE TRIGGER VALIDATE_EXISTENCIA_CONTA BEFORE INSERT ON SAQUEDEPOSITO FOR EACH ROW
EXECUTE PROCEDURE VERIFICAR_EXISTENCIA_CONTA('SAQUEDEPOSITO')

CREATE TRIGGER VALIDATE_EXISTENCIA_CONTA BEFORE INSERT ON TRANSFERENCIA FOR EACH ROW
EXECUTE PROCEDURE VERIFICAR_EXISTENCIA_CONTA('TRANSFERENCIA')

CREATE TRIGGER VALIDATE_CAMPOS_CLIENTE BEFORE INSERT ON CLIENTE FOR EACH ROW
EXECUTE PROCEDURE VERIFICAR_CAMPOS_CLIENTE()

CREATE TRIGGER VALIDATE_MUTATION BEFORE UPDATE OR DELETE ON SAQUEDEPOSITO FOR EACH ROW
EXECUTE PROCEDURE NAO_PERMITIR_OPERACOES()

CREATE TRIGGER VALIDATE_MUTATION BEFORE UPDATE OR DELETE ON TRANSFERENCIA FOR EACH ROW
EXECUTE PROCEDURE NAO_PERMITIR_OPERACOES()


/* -------------------------------------------------------------------------- */
/*                                   FUNCOES                                  */
/* -------------------------------------------------------------------------- */

CREATE OR REPLACE FUNCTION verificar_saldo() RETURNS TRIGGER AS $$
BEGIN
    IF TG_ARGV[0] = 'SAQUEDEPOSITO' THEN 
        IF NEW.TIPO = 'S' AND (SELECT SALDO FROM CONTA WHERE ID_CONTA = NEW.ID_CONTA) < NEW.VALOR THEN
            RAISE EXCEPTION 'SALDO INSUFICIENTE!';
        END IF;

    ELSIF TG_ARGV[0] = 'TRANSFERENCIA' THEN
        IF (SELECT SALDO FROM CONTA WHERE ID_CONTA = NEW.CONTA_ORIGEM) < NEW.VALOR THEN
            RAISE EXCEPTION 'SALDO INSUFICIENTE PARA TRANSFERÊNCIA!';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION VERIFICAR_EXISTENCIA_CONTA() RETURNS TRIGGER AS $$
BEGIN
    IF TG_ARGV[0] = 'SAQUEDEPOSITO' THEN
        IF NOT EXISTS (SELECT 1 FROM CONTA WHERE ID_CONTA = NEW.ID_CONTA) THEN
            RAISE EXCEPTION 'CONTA NÃO EXISTE!';
        END IF;

    ELSIF TG_ARGV[0] = 'TRANSFERENCIA' THEN
        IF NOT EXISTS (SELECT 1 FROM CONTA WHERE ID_CONTA = NEW.CONTA_ORIGEM) THEN
            RAISE EXCEPTION 'CONTA DE ORIGEM NÃO EXISTE!';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM CONTA WHERE ID_CONTA = NEW.CONTA_DESTINO) THEN
            RAISE EXCEPTION 'CONTA DE DESTINO NÃO EXISTE';
        END IF;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- VERIFICAR OS CAMPOS DE INSERT DE CLIENTE
CREATE OR REPLACE FUNCTION VERIFICAR_CAMPOS_CLIENTE() RETURNS TRIGGER AS $$
BEGIN

    -- SE O CPF JÁ EXISTE COMO CLIENTE
    IF EXISTS (SELECT 1 FROM CLIENTE WHERE CPF = NEW.CPF) THEN
        RAISE EXCEPTION 'CLIENTE JÁ CADASTRADO!';
    END IF;

    -- SE O CPF É VÁLIDO (CABE UMA VALIDAÇÃO?)
    IF LENGTH(NEW.CPF) != 11 OR THEN
        RAISE EXCEPTION 'CPF DEVE TER 11 CARACTERES'
    END IF;

    -- SE A DT_NASC NÃO É FUTURA
    IF NEW.DT_NASC > CURRENT_DATE THEN
        RAISE EXCEPTION 'DATA DE NASCIMENTO NÃO PODE SER UMA DATA FUTURA!';
    END IF;

    -- SE A PESSOA É DE MAIOR
    IF(EXTRACT(YEAR FROM AGE(CURRENT_DATE, NEW.DT_NASC))) < 18 THEN
        RAISE EXCEPTION 'NÃO PERMITIDO CADASTRO DE MENORES!'
    END IF;

    RETURN NEW;
END;

$$ LANGUAGE PLPGSQL



