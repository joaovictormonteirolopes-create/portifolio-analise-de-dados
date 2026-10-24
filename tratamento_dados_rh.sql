CREATE OR REPLACE VIEW empresa_rh.vw_funcionarios_auditado AS
WITH dados_unicos AS (
    SELECT 
        funcionario_id,
        UPPER(TRIM(nome_completo)) AS nome_completo,
        CASE 
            WHEN cargo IN ('Analista Jr', 'analista junior', 'An. Jr') THEN 'Analista Júnior'
            WHEN cargo IN ('Analista Pl', 'analista pleno') THEN 'Analista Pleno'
            WHEN cargo IN ('Dev', 'desenvolvedor', 'Developer') THEN 'Engenheiro de Software'
            ELSE TRIM(cargo)
        END AS cargo_padronizado,
        COALESCE(salario, 3500.00) AS salario_corrigido,
        data_admissao,
        ROW_NUMBER() OVER(PARTITION BY funcionario_id ORDER BY data_admissao DESC) as indice_duplicidade
    FROM empresa_rh.base_bruta_funcionarios
)
SELECT 
    funcionario_id,
    nome_completo,
    cargo_padronizado AS cargo,
    salario_corrigido AS salario,
    data_admissao
FROM dados_unicos
WHERE indice_duplicidade = 1;
