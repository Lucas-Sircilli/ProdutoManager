# Produto Manager - Frontend

- **Frontend (ProdutoManager)**: Aplicação Flutter para consumir a API e permitir a interação do usuário.

## 📋 Pré-requisitos

### Frontend
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão mais recente)
- [Dart SDK](https://dart.dev/get-dart) (já incluso no Flutter)
- [Android Studio](https://developer.android.com/studio) ou VS Code com extensões Flutter/Dart
- Emulador Android ou dispositivo físico conectado

## 🚀 Configuração e Execução

### 1️⃣ Clonar repositórios
```bash
git clone https://github.com/Lucas-Sircilli/ProdutoManager.git
```

### 2️⃣ Frontend - ProdutoManager
```bash
# Acessar pasta
cd ProdutoManager

# Instalar dependências
flutter pub get

# Configurar URL da API (editar lib/main.dart e atualizar para a UrlBase que foi encaminhada no email)
# Endereços padrão:
# - https://localhost:7055
# - http://localhost:5055
# Substituir as atribuições das variáveis a seguir:
# url -> método _buscarProdutoParaAtualizar
# baseUrl -> método fazerPesquisa
# url -> método _deletarProduto

# Rodar o app
flutter run
```

## 📱 Funcionalidades do Frontend
- Listagem de produtos
- Cadastro de novos produtos
- Edição de produtos
- Exclusão de produtos
- Interface responsiva

## 📄 Licença
Este projeto está sob a licença MIT.
