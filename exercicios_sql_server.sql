-- 1. Quantidade de produtos vendidos mensalmente
SELECT 
    FORMAT(DataVenda, 'MMM/yyyy') AS MesAno,
    COUNT(*) AS QuantidadeVendida
FROM Vendas
GROUP BY FORMAT(DataVenda, 'MMM/yyyy')
ORDER BY FORMAT(DataVenda, 'yyyyMM');

-- 2. Relatório de aniversário dos clientes
SELECT 
    LEFT(Nome, CHARINDEX(' ', Nome + ' ') - 1) AS PrimeiroNome,
    DAY(DataNascimento) AS DiaNascimento,
    MONTH(DataNascimento) AS MesNascimento
FROM Clientes
ORDER BY MONTH(DataNascimento), DAY(DataNascimento);

-- 3. Ticket médio dos clientes
WITH TicketCliente AS (
    SELECT 
        Nome,
        SUM(ValorCompra) AS TotalComprado,
        AVG(ValorCompra) AS TicketMedioCliente
    FROM Compras
    GROUP BY Nome
), TicketEmpresa AS (
    SELECT AVG(ValorCompra) AS TicketMedioEmpresa FROM Compras
)
SELECT 
    c.Nome,
    c.TotalComprado,
    c.TicketMedioCliente,
    e.TicketMedioEmpresa,
    (c.TicketMedioCliente * 100.0 / e.TicketMedioEmpresa) AS ComparativoPercentual
FROM TicketCliente c
CROSS JOIN TicketEmpresa e;

-- 4. Marcas com maior quantidade de produtos vendidos
WITH TotalVendas AS (
    SELECT 
        Marca,
        COUNT(*) AS QuantidadeVendida
    FROM Produtos
    JOIN Vendas ON Produtos.CodProd = Vendas.CodProd
    GROUP BY Marca
)
SELECT 
    Marca,
    QuantidadeVendida,
    (QuantidadeVendida * 100.0 / SUM(QuantidadeVendida) OVER()) AS Percentual
FROM TotalVendas
ORDER BY QuantidadeVendida DESC;

-- 5. Views para clientes pessoa física e jurídica
CREATE VIEW vw_ClientesFisicos AS
SELECT Nome, Codigo, CPF AS CPFCNPJ
FROM Clientes
WHERE Tipo = 'F';

CREATE VIEW vw_ClientesJuridicos AS
SELECT Nome, Codigo, CNPJ AS CPFCNPJ
FROM Clientes
WHERE Tipo = 'J';

CREATE VIEW vw_ClientesUnion AS
SELECT Nome, Codigo, CPF AS CPFCNPJ
FROM Clientes
WHERE Tipo = 'F'
UNION
SELECT Nome, Codigo, CNPJ AS CPFCNPJ
FROM Clientes
WHERE Tipo = 'J';

-- 6. Valor acumulado em vendas por Grupo e Ano
SELECT 
    Grupo,
    YEAR(DataVenda) AS Ano,
    SUM(ValorVenda) AS ValorAcumulado
FROM Vendas
GROUP BY Grupo, YEAR(DataVenda);

CREATE VIEW vw_ValorAcumulado AS
SELECT 
    Grupo,
    YEAR(DataVenda) AS Ano,
    SUM(ValorVenda) AS ValorAcumulado
FROM Vendas
GROUP BY Grupo, YEAR(DataVenda);

-- 7. Soma total de desconto por produto
WITH TotalDescontos AS (
    SELECT 
        CodProd,
        Descricao,
        SUM(Desconto) AS TotalDesconto
    FROM Produtos
    JOIN Vendas ON Produtos.CodProd = Vendas.CodProd
    GROUP BY CodProd, Descricao
)
SELECT 
    CodProd,
    Descricao,
    TotalDesconto,
    (TotalDesconto * 100.0 / SUM(TotalDesconto) OVER()) AS Percentual
FROM TotalDescontos;

-- 8. Procedure para pesquisar clientes por tipo
CREATE PROCEDURE sp_PesquisarClientesPorTipo (@Tipo CHAR(1) = NULL)
AS
BEGIN
    SELECT Nome, Codigo, Tipo
    FROM Clientes
    WHERE @Tipo IS NULL OR Tipo = @Tipo;
END;

-- 9. Produtos cadastrados de um grupo
SELECT 
    Grupo,
    COUNT(*) AS QuantidadeCadastrada,
    COUNT(Vendas.CodProd) AS QuantidadeVendida,
    COALESCE(MAX(DataVenda), 'sem registro') AS UltimaDataVenda
FROM Produtos
LEFT JOIN Vendas ON Produtos.CodProd = Vendas.CodProd
GROUP BY Grupo;

-- 10. Procedure para pesquisar clientes com nome começando com 'R'
CREATE PROCEDURE sp_PesquisarClientesPorLetra (@Letra CHAR(1))
AS
BEGIN
    SELECT Codigo, Nome
    FROM Clientes
    WHERE Nome LIKE @Letra + '%';
END;

-- 11. Procedure para pesquisar produtos por nome
CREATE PROCEDURE sp_PesquisarProdutosPorNome (@NomeProduto NVARCHAR(50))
AS
BEGIN
    SELECT CodProd, NomeProduto, Marca
    FROM Produtos
    WHERE NomeProduto LIKE '%' + @NomeProduto + '%';
END;

-- 12. Tabela temporária e procedure para pesquisar marcas
IF OBJECT_ID('tempdb..#TempMarcas') IS NOT NULL
    DROP TABLE #TempMarcas;

CREATE TABLE #TempMarcas (
    CodMarca INT,
    Descricao NVARCHAR(50),
    ValorTotalVendido DECIMAL(18, 2)
);

INSERT INTO #TempMarcas
SELECT 
    CodMarca,
    Descricao,
    SUM(ValorVenda) AS ValorTotalVendido
FROM Marcas
JOIN Produtos ON Marcas.CodMarca = Produtos.CodMarca
JOIN Vendas ON Produtos.CodProd = Vendas.CodProd
GROUP BY CodMarca, Descricao;

CREATE PROCEDURE sp_PesquisarMarcasPorValor (@Valor DECIMAL(18, 2) = NULL)
AS
BEGIN
    SELECT *
    FROM #TempMarcas
    WHERE @Valor IS NULL OR ValorTotalVendido <= @Valor;
END;

-- 13. Função para produtos com quantidade vendida maior que parâmetro
CREATE FUNCTION fn_ProdutosPorQuantidade (@Quantidade INT)
RETURNS TABLE
AS
RETURN
    SELECT CodProd, NomeProduto
    FROM Produtos
    JOIN Vendas ON Produtos.CodProd = Vendas.CodProd
    GROUP BY CodProd, NomeProduto
    HAVING SUM(Quantidade) > @Quantidade;

-- 14. Função para clientes sem vendas em uma cidade
CREATE FUNCTION fn_ClientesSemVendas (@Cidade NVARCHAR(50))
RETURNS TABLE
AS
RETURN
    SELECT Nome, Cidade
    FROM Clientes
    WHERE Cidade = @Cidade
    AND NOT EXISTS (
        SELECT 1
        FROM Vendas
        WHERE Vendas.CodCliente = Clientes.CodCliente
    );

-- 15. Trigger para atualizar descrição de produtos ao alterar marca
CREATE TRIGGER trg_AtualizarDescricaoProdutos
ON Marcas
AFTER UPDATE
AS
BEGIN
    UPDATE Produtos
    SET Descricao = REPLACE(Descricao, DELETED.Descricao, INSERTED.Descricao)
    FROM Produtos
    JOIN DELETED ON Produtos.CodMarca = DELETED.CodMarca
    JOIN INSERTED ON Produtos.CodMarca = INSERTED.CodMarca;
END;

-- 16. Trigger para registrar produtos com saldo <= 0
CREATE TABLE LOGPRODUTO (
    IdProduto INT,
    DataAtual DATETIME
);

CREATE TRIGGER trg_RegistrarProdutoSaldoZero
ON Vendas
AFTER INSERT
AS
BEGIN
    INSERT INTO LOGPRODUTO (IdProduto, DataAtual)
    SELECT CodProd, GETDATE()
    FROM Produtos
    WHERE Saldo <= 0;
END;

-- 17. Trigger para desativar grupo ao invés de excluir
ALTER TABLE Grupos ADD Ativo BIT DEFAULT 1;

CREATE TRIGGER trg_DesativarGrupo
ON Grupos
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Grupos
    SET Ativo = 0
    WHERE CodGrupo IN (SELECT CodGrupo FROM DELETED);
END;

-- 18. Crescimento entre dois meses usando PIVOT
SELECT *
FROM (
    SELECT 
        YEAR(DataVenda) AS Ano,
        DATENAME(MONTH, DataVenda) AS Mes,
        SUM(ValorVenda) AS Total
    FROM Vendas
    GROUP BY YEAR(DataVenda), DATENAME(MONTH, DataVenda)
) AS Fonte
PIVOT (
    SUM(Total) FOR Mes IN ([Jan], [Fev], [Mar], [Abr], [Mai], [Jun], [Jul], [Ago], [Set], [Out], [Nov], [Dez])
) AS Pivo;

-- 19. Duas últimas compras de cada cliente
WITH UltimasCompras AS (
    SELECT 
        NomeCliente,
        DataCompra,
        ValorCompra,
        ROW_NUMBER() OVER (PARTITION BY CodCliente ORDER BY DataCompra DESC) AS Rn
    FROM Compras
)
SELECT NomeCliente, DataCompra, ValorCompra
FROM UltimasCompras
WHERE Rn <= 2;

-- 20. Duas últimas vendas de cada produto por cliente
WITH UltimasVendas AS (
    SELECT 
        DescricaoProduto,
        DataVenda,
        Quantidade,
        ROW_NUMBER() OVER (PARTITION BY CodCliente, CodProd ORDER BY DataVenda DESC) AS Rn
    FROM Vendas
    JOIN Produtos ON Vendas.CodProd = Produtos.CodProd
)
SELECT DescricaoProduto, DataVenda, Quantidade
FROM UltimasVendas
WHERE Rn <= 2;

-- 21. Cursor para calcular os 5 produtos mais vendidos
DECLARE @CodProd INT, @QuantidadeTotal INT;

DECLARE CursorVendas CURSOR FOR
SELECT CodProd, SUM(Quantidade)
FROM Vendas
GROUP BY CodProd;

OPEN CursorVendas;

FETCH NEXT FROM CursorVendas INTO @CodProd, @QuantidadeTotal;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Produto: ' + CAST(@CodProd AS NVARCHAR) + ', Quantidade Total: ' + CAST(@QuantidadeTotal AS NVARCHAR);
    FETCH NEXT FROM CursorVendas INTO @CodProd, @QuantidadeTotal;
END;

CLOSE CursorVendas;
DEALLOCATE CursorVendas;

SELECT TOP 5 CodProd, SUM(Quantidade) AS QuantidadeTotal
FROM Vendas
GROUP BY CodProd
ORDER BY QuantidadeTotal DESC;
