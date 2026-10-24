import pandas as pd

dados_marketing = {
    'Canal': ['Google Ads', 'Facebook Ads', 'Instagram Orgânico', 'TikTok Ads', 'E-mail Marketing'],
    'Investimento_R$': [12000.00, 8500.00, 0.00, 5000.00, 1200.00],
    'Receita_Gerada_R$': [48000.00, 22000.00, 15000.00, 8000.00, 18000.00],
    'Novos_Clientes': [150, 95, 120, 40, 450]
}

df = pd.DataFrame(dados_marketing)

df['Lucro_Liquido_R$'] = df['Receita_Gerada_R$'] - df['Investimento_R$']
df['ROI_Percentual'] = (df['Lucro_Liquido_R$'] / df['Investimento_R$']).round(2) * 100
df.loc[df['Canal'] == 'Instagram Orgânico', 'ROI_Percentual'] = 100.0
df['CAC_R$'] = (df['Investimento_R$'] / df['Novos_Clientes']).round(2)

df_resultado = df.sort_values(by='ROI_Percentual', ascending=False)

print("--- RELATÓRIO DE PERFORMANCE DE MARKETING CORRETO ---")
print(df_resultado[['Canal', 'Investimento_R$', 'Receita_Gerada_R$', 'ROI_Percentual', 'CAC_R$']])
