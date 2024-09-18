CREATE OR REPLACE FUNCTION EXTRATO(
    ID_CONTA_BUSCADA INT,
    DT_INICIO DATE DEFAULT NULL,
    DT_FIM DATE DEFAULT NULL
)
RETURNS TABLE (
    valor_op FLOAT, 
    tipo_op TEXT,
    dia DATE,
    hora TIME
) AS $$
BEGIN
    IF DT_INICIO IS NULL THEN
        DT_INICIO := CURRENT_DATE - INTERVAL '1 month';
    END IF;
    
    IF DT_FIM IS NULL THEN
        DT_FIM := CURRENT_DATE;
    END IF;
	
    RETURN QUERY
    -- Saques e Depósitos
    SELECT
        VALOR AS valor_op,
        CASE
            WHEN TIPO = 'S' THEN 'Saque'
            WHEN TIPO = 'D' THEN 'Depósito'
        END AS tipo_op,
        DATE(DT_HR) AS dia,      
        DATE_TRUNC('second', DT_HR)::TIME AS hora       
    FROM
        SAQUEDEPOSITO
    WHERE
        ID_CONTA = ID_CONTA_BUSCADA
        AND DT_HR BETWEEN DT_INICIO::TIMESTAMP AND DT_FIM::TIMESTAMP
    
    UNION ALL
    
    -- Transferências
    SELECT
        VALOR AS valor_op,
        CASE
            WHEN CONTA_ORIGEM = ID_CONTA_BUSCADA THEN 'Transferência Enviada'
            WHEN CONTA_DESTINO = ID_CONTA_BUSCADA THEN 'Transferência Recebida'
        END AS tipo_op,
        DATE(DT_HR) AS dia, 
        DATE_TRUNC('second', DT_HR)::TIME AS hora     
    FROM
        TRANSFERENCIA
    WHERE
        (CONTA_ORIGEM = ID_CONTA_BUSCADA OR CONTA_DESTINO = ID_CONTA_BUSCADA)
        AND DT_HR BETWEEN DT_INICIO::TIMESTAMP AND DT_FIM::TIMESTAMP
    
    UNION ALL


    -- Compra no cartão
    SELECT
        C.VALOR_TOTAL AS valor_op,
        'Compra no cartão' AS tipo_op,
        DATE(C.DT_HR) AS dia, 
        DATE_TRUNC('second', C.DT_HR)::TIME AS hora
    FROM
        COMPRACREDITO C
    JOIN
        CARTAO CA ON C.NUM_CARTAO = CA.NUM_CARTAO
    WHERE
        CA.ID_CONTA = ID_CONTA_BUSCADA
        AND C.DT_HR BETWEEN DT_INICIO::TIMESTAMP AND DT_FIM::TIMESTAMP
    
    ORDER BY dia DESC, hora DESC;

END;
$$ LANGUAGE plpgsql;
