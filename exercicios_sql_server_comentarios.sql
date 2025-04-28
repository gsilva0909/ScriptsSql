-- 1. Quantidade de produtos vendidos mensalmente
-- Esta consulta retorna a quantidade de produtos vendidos por mês, diferenciando os meses por ano (ex.: Jan/2023 e Jan/2024).
-- Utiliza a função FORMAT para formatar a data e agrupa os resultados por mês/ano.

-- 2. Relatório de aniversário dos clientes
-- Retorna o primeiro nome dos clientes, o dia e o mês de nascimento, sem exibir o ano.
-- Os resultados são ordenados por mês e dia de nascimento.

-- 3. Ticket médio dos clientes
-- Calcula o ticket médio de cada cliente e compara com o ticket médio da empresa.
-- Mostra o nome do cliente, total comprado, ticket médio do cliente, ticket médio da empresa e a porcentagem de comparação.

-- 4. Marcas com maior quantidade de produtos vendidos
-- Lista as marcas com a maior quantidade de produtos vendidos.
-- Inclui uma coluna com a porcentagem de vendas em relação ao total de vendas.

-- 5. Views para clientes pessoa física e jurídica
-- Cria duas views: uma para clientes pessoa física e outra para pessoa jurídica.
-- Também cria uma terceira view que une os resultados das duas primeiras usando UNION.

-- 6. Valor acumulado em vendas por Grupo e Ano
-- Calcula o valor total de vendas acumulado por grupo e ano.
-- Também cria uma view para armazenar os resultados desta consulta.

-- 7. Soma total de desconto por produto
-- Calcula o total de desconto por produto e a porcentagem que cada desconto representa em relação ao total de descontos.

-- 8. Procedure para pesquisar clientes por tipo
-- Cria uma procedure que permite pesquisar clientes por tipo (F para pessoa física, J para pessoa jurídica).
-- Caso nenhum tipo seja informado, retorna todos os clientes.

-- 9. Produtos cadastrados de um grupo
-- Retorna a quantidade de produtos cadastrados e vendidos por grupo, além da última data de venda.
-- Caso não haja vendas, exibe "sem registro" na coluna de data.

-- 10. Procedure para pesquisar clientes com nome começando com 'R'
-- Cria uma procedure que retorna os clientes cujo nome começa com a letra 'R'.
-- Utiliza o operador LIKE para realizar a busca.

-- 11. Procedure para pesquisar produtos por nome
-- Cria uma procedure que permite pesquisar produtos pelo nome.
-- Utiliza o operador LIKE para buscar produtos que contenham o texto informado no parâmetro.

-- 12. Tabela temporária e procedure para pesquisar marcas
-- Cria uma tabela temporária para armazenar o código, descrição e valor total vendido por marca.
-- Também cria uma procedure que permite pesquisar marcas com valor vendido menor ou igual ao informado.

-- 13. Função para produtos com quantidade vendida maior que parâmetro
-- Cria uma função que retorna os produtos cuja quantidade vendida é maior que o valor informado como parâmetro.

-- 14. Função para clientes sem vendas em uma cidade
-- Cria uma função que retorna os clientes que não possuem vendas e residem em uma cidade específica.

-- 15. Trigger para atualizar descrição de produtos ao alterar marca
-- Cria uma trigger que atualiza a descrição dos produtos quando a descrição da marca associada é alterada.

-- 16. Trigger para registrar produtos com saldo <= 0
-- Cria uma tabela de log e uma trigger que registra o código do produto e a data quando o saldo do produto atinge zero ou menos.

-- 17. Trigger para desativar grupo ao invés de excluir
-- Adiciona uma coluna "Ativo" à tabela de grupos e cria uma trigger que desativa o grupo (em vez de excluí-lo) ao tentar removê-lo.

-- 18. Crescimento entre dois meses usando PIVOT
-- Utiliza a cláusula PIVOT para mostrar o crescimento das vendas entre dois meses.
-- Os resultados são organizados por ano e mês.

-- 19. Duas últimas compras de cada cliente
-- Retorna as duas últimas compras de cada cliente, ordenadas pela data de compra.
-- Caso o cliente tenha apenas uma compra, exibe apenas essa.

-- 20. Duas últimas vendas de cada produto por cliente
-- Retorna as duas últimas vendas de cada produto para cada cliente, ordenadas pela data de venda.

-- 21. Cursor para calcular os 5 produtos mais vendidos
-- Utiliza um cursor para percorrer os registros de vendas e calcular a quantidade total vendida de cada produto.
-- Exibe os 5 produtos mais vendidos juntamente com a quantidade total vendida.
