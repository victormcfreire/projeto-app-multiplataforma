# EcoMapa Fortaleza

## 1. Título e Descrição do Projeto

**Nome do Sistema:** EcoMapa Fortaleza

**Descrição:**  
Sistema multiplataforma voltado para informar e conscientizar a população sobre o descarte correto de lixo, reunindo em um só lugar dados de pontos de coleta, turnos de coleta, clima e qualidade do ar.

**Problema Solucionado:**  
- Falta de centralização de informações sobre pontos de coleta  
- Descarte incorreto de resíduos  
- Proliferação de pragas e doenças  
- Alagamentos causados por lixo em vias públicas  
- Acesso dificultado a dados ambientais em tempo real

---

## 2. Funcionalidades Implementadas

### Funcionalidades Principais
- Exibição de mapa interativo com pontos de coleta
- Informações sobre turnos de coleta
- Sistema de autenticação
- API RESTful centralizadora (backend)
- Aplicativo multiplataforma (web e mobile) em Flutter

### Status das Funcionalidades
| Funcionalidade | Status |
|----------------|--------|
| Mapa interativo | Concluído |
| Pontos de coleta (API + exibição) | Concluído |
| Turnos de coleta (filtros) | Concluído |
| Autenticação | Concluído |
| Interface Flutter | Concluído |

### Screenshots
Tela de Login ![Tela de Login](<screenshots\/Tela_Login.png>)  Tela de Cadastro ![Tela de Cadastro](<screenshots\/Tela_Cadastro.png>) Visão do Mapa Interativo e os Pontos de Coleta ![Visão do Mapa Interativo e os Pontos de Coleta](<screenshots\/Mapa_Pontos.png>) Visão da Aba Lateral de Filtros ![Visão da Aba Lateral de Filtros](<screenshots\/Aba_Lateral.png>) Visão do Mapa com Pontos de Coleta e Quadrantes de Turnos de Coleta ![Visão do Mapa com Pontos de Coleta e Quadrantes de Turnos de Coleta](<screenshots\/Mapa_Completo.png>)

---

## 3. Tecnologias Utilizadas

### Linguagens de Programação
- JavaScript (Node.js)
- Dart (Flutter)

### Frameworks e Bibliotecas
- Express.js  
- Flutter  
- Provider  
- Bibliotecas de mapas interativos (flutter_map, flutter_map_geojson, latlong2)

### Banco de Dados
- Back4App (Parse Platform)

### Ferramentas de Desenvolvimento
- Postman / Insomnia  
- Swagger  
- Jest / Supertest
- VsCode
- Android Studio

---

## 4. Arquitetura do Sistema

### Visão Geral da Arquitetura

Cliente (Web/Mobile Flutter)  
↓  
API Central (Node.js / Express.js)  
↓  
Back4App – Autenticação, Turnos e Pontos de Coleta, Persistência de dados 
Open-Meteo – Dados Climáticos  
WAQI/OpenAQ – Dados de Qualidade do Ar

### Componentes Principais
- **Frontend:** Flutter  
- **Backend:** Node.js + Express.js  
- **BaaS/Banco de Dados:** Back4App  
- **APIs Externas:** Open-Meteo, WAQI/OpenAQ

### Integrações Realizadas
- Integração backend ↔ Back4App
- Integração backend ↔ Open-Meteo
- Integração backend ↔ WAQI/OpenAQ

---

## 5. Instruções de Instalação e Execução

---

## Guia de Instalação e Execução do Front
**REQUISITOS DO SISTEMA**

**Flutter**

-   Flutter SDK >= 3.4.4 < 4.0.0
    
-   Dart >= 3.4.4 < 4.0.0
    
-   Comando para verificar versão: `flutter --version`
    
-   Lembre-se de verificar o arquivo android/local.properties e apontar corretamente os caminhos dos SDKs do seu Android e Flutter
    

**Android**

-   Android Studio (ou SDK standalone se usar VS Code)
    
-   Android SDK 33 ou superior
    
-   Emulador Android configurado ou dispositivo físico
    
-   Java 17 (necessário para o Gradle)
    
-   Comando para verificar Java: `java -version`
    

**Web**

-   Google Chrome instalado
    
-   Flutter Web ativado
    
-   Comando para listar dispositivos: `flutter devices`
    

* * *

**DEPENDÊNCIAS PRINCIPAIS DO FLUTTER**

-   `flutter_map`
    
-   `latlong2`
    
-   `flutter_map_geojson`
    
-   `flutter_map_cancellable_tile_provider`
    
-   `geolocator`
    
-   `provider`
    
-   `flutter_secure_storage`
    
-   `http`
    

Comando para instalar dependências:  
`flutter pub get`

* * *

**ESTRUTURA DO PROJETO**

-   Projeto segue estrutura padrão Flutter (`android`, `web`, `lib`)
    
-   Provider é usado para gerenciamento de estado
    
-   API consumida na nuvem
    

* * *

**CONFIGURAÇÃO DA URL DA API**

-   Arquivo: `lib/pages/main/controller/api_controller.dart`
    
-   Linha: `static const String baseUrl = "https://trabalho-integracao-sistemas.vercel.app"`
    
-   Para testar outra API, basta alterar essa linha

* * *

**COMO RODAR O PROJETO**

**1. Instalar dependências**

`flutter pub get`

**2. Rodar no navegador (Web)**

`flutter run -d chrome`

O app abrirá automaticamente em uma nova janela do navegador (certifique-se de permitir a leitura de localização quando solicitado)

**3. Rodar no Android (emulador ou dispositivo físico)**

-   Iniciar emulador no Android Studio ou via terminal:

`flutter emulators --launch <nome_do_emulador>`

-   Rodar app:

`flutter run`

* * *

**SOLUÇÃO DE PROBLEMAS COMUNS**

**Erro “Java 17 required”**

-   Instalar Java 17:
    

`sudo apt install openjdk-17-jdk`

**Erro no Android SDK**

-   Abrir Android Studio → SDK Manager
    
-   Instalar: Android SDK Platform 33/34, Android SDK Tools, Google Play Services

---

## Guia de Execução da API (Caso necessite realizar chamadas HTTP sem usar o app)

### Requisitos

- **Node.js 20 ou superior** instalado na máquina.
- Acesso à internet para baixar dependências do `package.json`.

---

### Instalação

1. Clone o repositório da API (ou faça download do projeto).
2. No terminal, entre na pasta do projeto:
   ```bash 
   cd nome-do-projeto
   ```

3. Instale as dependências:

   ```bash
   npm install
   ```

---

### Rodando a API

1. Para iniciar a API, execute:

   ```bash
   npm run start
   ```
2. A API será iniciada no endereço:

   [http://localhost:3000](http://localhost:3000)
  
3. Para acessar a documentação da API (Swagger), abra no navegador:

   [http://localhost:3000/docs](http://localhost:3000/docs)


---

### Usando a Autenticação no Swagger

1. Para acessar endpoints protegidos via `/docs`, você precisa de um **sessionToken** válido:

   * Faça login utilizando o endpoint de login da API.
   * Pegue o valor retornado no campo `sessionToken`.
2. Clique no botão **Authorize** no Swagger.
3. Insira o token no campo

4. Após isso, você poderá testar os endpoints protegidos diretamente no Swagger.

---

### Executando os Testes

1. Para rodar todos os testes automatizados, execute:

   ```bash
   npm test
   ```
2. O Jest irá executar todos os testes definidos no projeto e mostrar o resultado no terminal.

---

### Observações

* Certifique-se de que a porta 3000 não esteja sendo usada por outro serviço.
* Para alterar a porta, modifique a configuração no .env (propriedade `PORT`).
* Para qualquer dúvida sobre endpoints ou uso da API, consulte a documentação Swagger em `/docs`.

---

### Pré-requisitos
- Node.js 20+
- Flutter (3.35.3)
- Postman/Insomnia (para endpoints não implementados no app)
- Token de autenticação obtido via `/login`

### Configurações Necessárias
- Token obtido via endpoint `/login`  
- Envio do token no header `Authorization` para rotas protegidas

---

## 6. Acesso ao Sistema

### URL de Acesso
[Url Web](https://trabalho-mapa.vercel.app/)

### Credenciais de Teste
- **Usuário:** usuario_exemplo 
- **Senha:** senha123 

---

## 7. Validação com Público-Alvo
*(Seção deixada em branco conforme solicitado.)*

---

## 8. Equipe de Desenvolvimento
| Nome | Papel Principal |
|------|----------------|
| Francisco Evando Gomes de Lima |Design da Arquitetura |
| Gunther Cristiano de Morais | Documentação |
| Ingrynd Vasconcelos Loiola | Prototipação |
| Maria Elania Vieira Asevedo | Análise e Planejamento |
| Victor Martins Castro Freire | Desenvolvimento, Arquitetura e Modelagem |
| Vinícius Dantas de Sousa | Modelagem |


## 9. Observações
   - Conforme alinhado com o professor atráves do fórum, foi necessário uma adaptação na estrutura do repositório devido ao fato de usarmos o Flutter como framework.
     Por conta disso, adaptamos a estrutura da pasta frontend de forma que o código principal se encontra na pasta frontend/lib(widgets, páginas e modelos do flutter),
     o conteúdo mobile se encontra na pasta /android, o conteúdo web na pasta /web e o arquivo pubspec.yaml é equivalente ao que seria o package.json. O arquivo pubspec.lock foi adicionado por questões de garantia de compatibilidade entre os pacotes do aplicativo.

   - Também foi adicionado o arquivo mapa.iml por exigência dos pacotes de geolocalização/renderização de mapas.

   - O arquivo database/schema.sql foi criado convertendo o schema real do banco no Back4App. O Back4App, sendo uma plataforma BaaS (Backend-as-a-Service) baseada no    Parse Server, utiliza um banco de dados MongoDB (NoSQL) como padrão. Por isso, a exportação nativa do schema é fornecida em formato JSON, que é o padrão para bancos de dados orientados a documentos. O schema SQL resultante é estruturalmente equivalente ao original do Back4App, permitindo que qualquer sistema SQL tradicional possa compreender a organização do banco de dados do aplicativo. Caso necessário, entre em contato com um dos membros da equipe para obter o schema em seu formato JSON original.
