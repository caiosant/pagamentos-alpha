<h1 align="center">
    Plataforma de pagamentos(time alpha)
</h1>
<p align="center"> Esta plataforma web facilita pagamentos, conectando financeiramente empresas com seus clientes. </p>

## 🚀 Começando

Essas instruções permitirão que você obtenha uma cópia do projeto em operação na sua máquina local para fins de desenvolvimento e teste.

### 📋 Pré-requisitos

Para executar a versão de desenvolvimento é preciso:

```
Ruby 3.0.2
Rails 6.1+
Git
NodeJs
Yarn
```
### 🔧 Instalação

- Clonar o repositório
- Acessar a pasta freela pelo terminal
```
cd freela
```
- Executar:
```
bundle config set --local without production
bundle install
```
- Em seguida executar:
```
rails webpacker:install
```

- Em seguida executar:
```
rails db:migrate
rails db:seed
rails server
```
Acesse a aplicação pelo navegador: digitando http://localhost:3000/ na barra de endereço.

## ⚙️ Executando os testes

Para executar os testes execute no terminal:
```
rspec --format=documentation
```
## 📦 Desenvolvimento

O sistema foi desenvolvido usando TDD(Test-driven development), com testes unitários e de integração, utilzando as gems rspec e capybara.
Esse é o projeto final da etapa 2 da turma 7 do programa [Treinadev](https://treinadev.com.br/) da [Campuscode](https://campuscode.com.br/).

## Features

- [ ] Cadastro de administradores
- [x] Cadastro de usuários
- [ ] Registro de empresas pelos usuários
- [ ] Administradores podem aprovar ou rejeitar empresas
- [ ] Administradores podem criar meios de pagamentos
- [ ] Administradores podem desativar ou ativar meios de pagamentos
- [ ] Usuários podem selecionar quais meios de pagamentos serão usados por suas empresas

Mais features serão planejadas e implementadas no futuro!

## 🛠️ Construído com

* [Ruby on Rails](https://rubyonrails.org/) - O framework web usado
* [Bundle](https://bundler.io/) - Gerenciador de dependências (gems)
* [Yarn](https://yarnpkg.com/) - Gerenciador de dependências do front-end 