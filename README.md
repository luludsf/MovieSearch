# MovieSearch

Um aplicativo iOS nativo desenvolvido em Swift para busca e gerenciamento de filmes favoritos, construído com arquitetura limpa e padrões modernos de desenvolvimento.

## Configuração e Instalação

### Pré-requisitos
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Instalação
1. Clone o repositório
2. Abra o projeto no Xcode
3. Crie um arquivo **Config.xcconfig** na pasta **AppSetupFiles** adicionando **API_KEY=XPTO**
4. Build e execute no simulador ou dispositivo

## Arquitetura

O projeto segue os princípios da **Clean Architecture** com separação clara de responsabilidades:

### Estrutura do Projeto

```
MovieSearch/
├── MovieSearchData/          # Camada de Dados
├── MovieSearchDomain/        # Camada de Domínio (Lógica de Negócio)
├── MovieSearchUI/            # Camada de Apresentação
└── Networking/               # Camada de Rede
```

### Padrões Utilizados

- MVVM (Model-View-ViewModel)
- Repository Pattern
- Use Case Pattern
- Coordinator Pattern
- Factory Pattern
- Protocol-Oriented Programming

## Tecnologias e Frameworks

- Swift 5.9+
- UIKit
- SwiftData
- URLSession