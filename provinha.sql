1. Monte uma consulta SQL que exiba o nome da fazenda, a quantidade de talhões e a soma da area total dos talhões cadastrados por fazenda, utilizando join entre Fazebda e Talhao, e agrupando os resultados.
SELECT 
    f.Descricao AS NomeDaFazenda,
    COUNT(t.TalhaoID) AS QuantidadeDeTalhoes,
    SUM(t.AreaTotal) AS SomaAreaTotal
FROM 
    Fazenda f
JOIN 
    Talhao t ON f.FazendaID = t.FazendaID
GROUP BY 
    f.Descricao;

2. Monte uma Consulta sql que exiba o nome da fazenda, o total de area plantada (somando a area total da tabela SafraTalhao)
e a producao esperada total por fazenda, considerando apenas as safras que ja tenham data de inicio preenchida, 
utilizando join entre as tabelas Fazenda, Talhao, SafraTalhao e Safra, e agrupando os resultados por fazenda.
SELECT 
    f.Descricao AS NomeDaFazenda,
    SUM(st.AreaTotal) AS TotalAreaPlantada,
    SUM(st.ProducaoEsperada) AS ProducaoEsperadaTotal
FROM 
    Fazenda f
JOIN 
    Talhao t ON f.FazendaID = t.FazendaID
JOIN 
    SafraTalhao st ON t.TalhaoID = st.TalhaoID
JOIN 
    Safra s ON st.SafraID = s.SafraID
WHERE 
    s.DataInicio IS NOT NULL
GROUP BY 
    f.Descricao;


3. Crie uma procedure que receba duas datas inicial e final e mostre os talhões que tiverão producao neste intervalo.
CREATE PROCEDURE TalhoesPorIntervaloDeData
    @DataInicial DATETIME,
    @DataFinal DATETIME
AS
BEGIN
    SELECT 
        t.TalhaoID,
        t.Descricao AS DescricaoTalhao,
        st.DataPlantio,
        st.ProducaoEsperada
    FROM 
        Talhao t
    JOIN 
        SafraTalhao st ON t.TalhaoID = st.TalhaoID
    WHERE 
        st.DataPlantio BETWEEN @DataInicial AND @DataFinal;
END;
