WITH dados_consolidados AS (
    SELECT 
        c.cliente_id,
        c.nome_cliente,
        c.regiao,
        c.status_cliente,
        c.data_cadastro,
        COUNT(v.venda_id) AS total_compras,
        SUM(v.valor_total) AS faturamento_total,
        MAX(v.data_venda) AS data_ultima_compra
    FROM empresa_ecommerce.clientes c
    LEFT JOIN empresa_ecommerce.vendas v ON c.cliente_id = v.cliente_id
    GROUP BY c.cliente_id, c.nome_cliente, c.regiao, c.status_cliente, c.data_cadastro
),
analise_recencia AS (
    SELECT 
        *,
        DATE_DIFF(CURRENT_DATE(), data_ultima_compra, DAY) AS dias_sem_comprar
    FROM dados_consolidados
)
SELECT 
    cliente_id,
    nome_cliente,
    regiao,
    faturamento_total,
    total_compras,
    dias_sem_comprar,
    CASE 
        WHEN status_cliente = 'Cancelado' THEN 'Churn Confirmado'
        WHEN dias_sem_comprar > 90 THEN 'Risco Alto de Churn'
        WHEN dias_sem_comprar BETWEEN 45 AND 90 THEN 'Risco Médio'
        ELSE 'Cliente Ativo / Risco Baixo'
    END AS status_risco_churn
FROM analise_recencia
ORDER BY faturamento_total DESC;
