Vamos criar um app de gerencia financeira para mobile e web.
utilizaremos flutter para isso. para os devidos fins, saiba que já existe um backend criado em php, voce pode ver o seu codigo em F:\nao_softwares\projetos\flutter\financas_app\php\create_movimentacao.php e F:\nao_softwares\projetos\flutter\financas_app\php\get_movimentacoes.php
a ideia do app a principio é logar o cliente com 1 ou 2 (id, futuramente implemento login)
a partir do login, o usuario vê os gastos de cada um (1 e 2 verão gastos um do outro por que futuramente vou implementar grupo familiar)
a primeiar tela traz resumo geral (gastos vs ganhos) mediante filtro de data inicial e final
a segunda tela traz uma lista com todas as movimentações (gastos e ganhos) mediante filtro de data inicial e final
a terceira tela permite registrar movimentações (entrada ou saída), sendo obrigatorio data de gasto/recebimento, nome, tipo e meio da movimentação, opcional a descrição e data de vencimento/pagamento
a quarta tela permite cadastrar tipos de movimentações (ex: salário, aluguel, comida, etc)
a quinta tela permite cadastrar meios de movimentações (ex: cartão, dinheiro, pix)
a sexta permite exportar isto em excel de acordo com periodo selecionado