CREATE OR REPLACE FUNCTION PAGAR_FATURA(ID_FATURA_ INT) RETURNS VARCHAR AS 
$$ 
	DECLARE
		TAXA_JUROS_DIARIOS_ FLOAT := 0.05;
		TOTAL_COM_MULTA_ FLOAT := 0;
		NUM_DIAS_ATRASADOS_ INT := 0;
		DT_FECHAMENTO DATE;
	BEGIN

		IF (SELECT DT_PAGAMENTO FROM FATURA WHERE ID_FATURA = ID_FATURA_) IS NOT NULL THEN
			RAISE EXCEPTION 'FATURA JÁ FOI PAGA!';
		END IF;
		
    	SELECT (F.DT_FECHAMENTO - CURRENT_DATE) INTO NUM_DIAS_ATRASADOS_ FROM FATURA F
			WHERE ID_FATURA = ID_FATURA_;

		IF NUM_DIAS_ATRASADOS_ < 0 THEN-- Quando é um número negativo é pq tá com multa
			SELECT VALOR_TOTAL + VALOR_TOTAL * ( TAXA_JUROS_DIARIOS_ * (NUM_DIAS_ATRASADOS_ * -1)) INTO TOTAL_COM_MULTA_ FROM FATURA 
				WHERE ID_FATURA = ID_FATURA_; 

		END IF;

		UPDATE CONTA SET SALDO = SALDO - TOTAL_COM_MULTA_ FROM CARTAO, FATURA WHERE CONTA.ID_CONTA = CARTAO.ID_CONTA AND
			FATURA.NUM_CARTAO = CARTAO.NUM_CARTAO AND ID_FATURA = ID_FATURA_;

		UPDATE FATURA SET DT_PAGAMENTO = CURRENT_TIMESTAMP WHERE ID_FATURA = ID_FATURA_;

	
		RETURN 'VALOR TOTAL COM MULTAS: ' || TOTAL_COM_MULTA_;
		
		-- ADICIONAR UMA DATA_DE_PAGAMENTO NA  FATURA
		-- VERIFICAR A QUESTAO DAS MULTAS
        
		-- ATUALIZAR O SALDO DA CONTA TIRANDO O VALOR
	END; 
$$ LANGUAGE PLPGSQL;