CREATE OR REPLACE FUNCTION COMPRAR_NO_CREDITO(
	NUM_CARTAO INT,
	VALOR_TOTAL FLOAT,
	QTD_PARCELAS INT
) RETURNS VOID AS 
$$ 
	BEGIN
		INSERT INTO COMPRACREDITO( ID_COMPRA, NUM_CARTAO, VALOR_TOTAL, DT_HR, QTD_PARCELAS) 
		    VALUES(DEFAULT, NUM_CARTAO, VALOR_TOTAL,CURRENT_TIMESTAMP, QTD_PARCELAS);
	END; 
$$ LANGUAGE PLPGSQL;