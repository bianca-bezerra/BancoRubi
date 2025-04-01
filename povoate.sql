-- 1. Povoa a tabela BANCO
-- Adiciona vários bancos
SELECT INSERTO('Banco A', 'Banco B', 'Banco C', 'Banco D', 'Banco E');

-- 2. Povoa a tabela AGENCIA
-- Adiciona várias agências
-- Supondo que os IDs de banco sejam 1, 2, 3, etc., ajustados conforme necessário
SELECT INSERTO(1, 'Rua da Agência A, 123');
SELECT INSERTO(2, 'Avenida da Agência B, 456');
SELECT INSERTO(3, 'Rua da Agência C, 789');
SELECT INSERTO(4, 'Praça da Agência D, 101');
SELECT INSERTO(5, 'Avenida da Agência E, 202');

-- 3. Povoa a tabela CLIENTE
-- Adiciona vários clientes
-- Supondo que as agências adicionadas são de 1 a 5
SELECT INSERTO(1, '12345678901', 'João Silva', 'Rua do João, 321', '1980-01-01', '9999-9999');
SELECT INSERTO(2, '23456789012', 'Maria Oliveira', 'Rua da Maria, 654', '1990-02-02', '8888-8888');
SELECT INSERTO(3, '34567890123', 'Pedro Santos', 'Rua do Pedro, 987', '1985-03-03', '7777-7777');
SELECT INSERTO(4, '45678901234', 'Ana Souza', 'Rua da Ana, 135', '1992-04-04', '6666-6666');
SELECT INSERTO(5, '56789012345', 'Carlos Lima', 'Rua do Carlos, 246', '1988-05-05', '5555-5555');

-- 4. Povoa a tabela FUNCIONARIO
-- Adiciona vários funcionários
-- Supondo que as agências adicionadas são de 1 a 5
SELECT INSERTO('Lucas Costa', 3000.00, 1);
SELECT INSERTO('Fernanda Lima', 3500.00, 2);
SELECT INSERTO('Rafael Martins', 3200.00, 3);
SELECT INSERTO('Juliana Pereira', 3300.00, 4);
SELECT INSERTO('Bruno Almeida', 3400.00, 5);

-- 5. Povoa a tabela CONTA
-- Cada cliente terá uma conta
-- Supondo que os IDs de cliente são de 1 a 5
-- (O número da agência é assumido aqui para simplificação; ajuste conforme necessário)
-- Você precisará garantir que a tabela CONTA está pronta para receber os dados
SELECT INSERTO(1, 1, DEFAULT, DEFAULT);
SELECT INSERTO(2, 2, DEFAULT, DEFAULT);
SELECT INSERTO(3, 3, DEFAULT, DEFAULT);
SELECT INSERTO(4, 4, DEFAULT, DEFAULT);
SELECT INSERTO(5, 5, DEFAULT, DEFAULT);

-- 6. Povoa a tabela CARTAO
-- Adiciona cartões para contas existentes
-- Supondo que as contas têm IDs de 1 a 5
-- Ajuste as datas conforme necessário
SELECT INSERTO(1, '2024-01-01 10:00:00', '2024-12-31 23:59:59');
SELECT INSERTO(2, '2024-01-15 10:00:00', '2024-12-31 23:59:59');
SELECT INSERTO(3, '2024-02-01 10:00:00', '2024-12-31 23:59:59');
SELECT INSERTO(4, '2024-03-01 10:00:00', '2024-12-31 23:59:59');
SELECT INSERTO(5, '2024-04-01 10:00:00', '2024-12-31 23:59:59');
