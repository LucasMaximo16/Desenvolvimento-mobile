# Horizonte Viagens

Aplicativo de agência de viagens em SwiftUI, desenvolvido para a atividade prática de acompanhamento.

## Executar

Abra `HorizonteViagens.xcodeproj`, selecione o scheme `HorizonteViagens`, escolha um simulador de iPhone com iOS 17 ou superior e execute com **⌘R**. Para executar os testes, use **⌘U**.

## Funcionalidades

- Explorar seis pacotes nacionais e internacionais, com filtros Todos, Brasil e Mundo.
- Consultar destino, duração, partida, retorno, hospedagem e preço em reais.
- Adicionar e remover favoritos na listagem e nos detalhes.
- Acessar Meus Favoritos pelo coração com contador na barra superior.
- Persistir favoritos localmente com UserDefaults e identificadores estáveis.
- Exibir mensagem e retorno à exploração quando a lista de favoritos estiver vazia.
- Simular a reserva com um aviso, sem pagamentos ou reservas reais.

## Layout e organização

Identidade visual em azul e verde, cartões arredondados, tipografia do sistema e grade adaptável. As ilustrações são compostas por formas SwiftUI e SF Symbols, disponíveis offline, conforme a alternativa permitida no enunciado. Valores, hotéis e pacotes são fictícios.

- `PacoteViagem.swift`: modelo Identifiable/Hashable, catálogo e estado observável dos favoritos.
- `ContentView.swift`: exploração, filtros, cartões e favoritos.
- `DetalhesPacoteView.swift`: detalhes, hospedagem, roteiro e reserva ilustrativa.
- `HorizonteViagensTests`: persistência, remoção, IDs, datas e moeda.
- `HorizonteViagensUITests`: navegação e reserva ilustrativa.

Projeto independente da atividade Controle de Notas de Alunos. Publicação no Git pendente de aprovação visual.

## Validação nesta entrega

Compilação para iPhone 17 Pro (iOS 26.5) concluída e aplicativo iniciado no simulador. Tela inicial conferida por captura. Os testes foram compilados, mas sua execução foi bloqueada pelo ambiente com `Pseudo Terminal Setup Error` (permissão do executor). A navegação completa e a persistência ainda precisam de validação de execução dos testes ou conferência manual.
