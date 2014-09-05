# New App

Este guia destina-se apenas à instalação e execução do sistema em modo desenvolvimento.

## Instalação

O sistema utiliza a linguagem Ruby em sua versão 2.1.x, o framework Ruby on Rails em sua versão 4.1.x, o banco de dados PostgreSQL em sua versão 9.3.x e o banco de dados Redis em sua versão 2.2.x.

Clone o repositório:

    $ git clone git@github.com:fbazzarella/newapp.git
    $ cd newapp

Instale as dependências:

    newapp$ bundle install

## Configuração

Copie o arquivo `config/database.yml.example` para `config/database.yml` e preencha-o de acordo com suas configurações. Após, basta criar o banco e rodar as migrations:

    newapp$ rake db:create db:migrate

## Execução

Agora basta iniciar o servidor para que o sistema esteja rodando:

    newapp$ rails server

## Testes

Os testes automatizados são escritos em RSpec e utilizam FactoryGirl para a criação de registros. Antes de rodar os testes, você precisará preparar o banco de dados:

    newapp$ rake db:test:prepare
    
Agora, rode os testes:

    newapp$ rspec spec/

### Atenção

É extremamente importante enviar ao repositório somente commits que estejam com todos os testes em verde. Essa atitude evita problemas no futuro, economizando tempo e paciência.
