
# Arquitetura do Sistema - EcoMapa Fortaleza

## Descrição da Arquitetura

A arquitetura adotada é baseada em uma **API Monolítica com Fachada de Agregação**, atuando como um serviço centralizado que medeia e agrega informações de múltiplas fontes. A API expõe endpoints unificados para clientes web e mobile, abstraindo a complexidade de comunicação com sistemas backend heterogêneos.

## Componentes do Sistema

### 1. Cliente (Frontend)
- **Aplicativo Flutter** multiplataforma (Web, Android, iOS)
- Interface com mapa interativo como elemento central
- Menu lateral para filtros e navegação
- Sistema de autenticação integrado

### 2. API Central (Backend)
- **Express.js** com Node.js 20+
- Arquitetura modular (controllers, routes, services)
- Orquestração de chamadas para serviços externos
- Agregação e transformação de dados

### 3. Backend as a Service (BaaS)
- **Back4App** (Parse Platform)
- **Autenticação**: Gerenciamento de usuários e sessões
- **Persistência**: Armazenamento de arquivos GeoJSON
- **Escalabilidade**: Infraestrutura em nuvem

### 4. APIs Externas
- **Open-Meteo**: Dados climáticos em tempo real
- **WAQI/OpenAQ**: Índice de qualidade do ar
- Integração via REST/HTTP

## Padrões Arquiteturais Utilizados

### Padrão Principal: API Monolítica com Fachada de Agregação

**Monolítica:**
- Lógica central em aplicação única Express.js
- Desenvolvimento, teste e deploy como unidade coesa
- Todos endpoints servidos pelo mesmo processo

**Fachada de Agregação:**
- API atua como gateway unificado
- Esconde complexidade dos sistemas backend
- Cliente faz requisições simples (/clima, /login)
- API orquestra chamadas e agrega respostas

### Padrão Secundário: Backend as a Service (BaaS)
- Delegação de funcionalidades complexas
- Autenticação e armazenamento como serviço
- Redução de tempo de desenvolvimento
- Custo-benefício em infraestrutura

## Diagrama de Arquitetura

Cliente (Web / Mobile / Outro)
|
| HTTPS + JSON
|
API Express.js (controllers / routes / services)
| | |
Parse SDK/REST GET JSON (Open-Meteo) GET JSON (WAQI/OpenAQ)
| | |
Back4App (Parse Server) Open-Meteo WAQI / OpenAQ
|
GeoJSON Files (Maps collection)


## Diagrama de Sequência

Cliente API Back4App Open-Meteo
| | | |
| GET /pontos-coleta (Auth) | |
|-------------->| | |
| | Busca Map.geojson |
| |------------->| |
| | Retorna arquivo GeoJSON |
| |<-------------| |
| | GET clima?lat,lon (opcional) |
| |------------------------------>|
| | Dados climáticos |
| |<------------------------------|
| FeatureCollection + dados de clima |
|<--------------| | |


## Decisões Técnicas e Justificativas

### 1. Escolha do Node.js + Express.js
- **Justificativa**: Eficiência em operações I/O assíncronas
- **Benefício**: Ideal para API que comunica com múltiplos serviços externos
- **Performance**: Não bloqueio em chamadas de rede

### 2. Uso de Back4App como BaaS
- **Justificativa**: Velocidade de desenvolvimento e custo-benefício
- **Benefício**: Delega autenticação e persistência complexas
- **Redução**: Complexidade operacional de infraestrutura própria

### 3. Arquitetura Monolítica vs Microserviços
- **Decisão**: Monolítica com fachada de agregação
- **Justificativa**: Simplicidade para escopo atual
- **Evita**: Complexidade desnecessária de microserviços

### 4. Frontend com Flutter
- **Justificativa**: Desenvolvimento multiplataforma eficiente
- **Benefício**: Código único para web e mobile
- **Consistência**: Experiência unificada entre plataformas

## Restrições e Dependências

### Dependências de Terceiros
- **Back4App**: Disponibilidade e performance do BaaS
- **Open-Meteo**: Confiabilidade dos dados climáticos
- **WAQI/OpenAQ**: Qualidade e atualização dos dados de ar

### Restrições Técnicas
- **Modelo de Persistência**: Limitado ao oferecido pelo Back4App
- **Consultas Complexas**: Restrições comparadas com banco SQL próprio
- **Escalabilidade**: Dependente do plano do Back4App

## Considerações de Segurança

- **Autenticação**: Bearer Token com sessionToken do Parse
- **HTTPS**: Comunicação criptografada end-to-end
- **Headers Seguros**: Configuração com Helmet.js
- **CORS**: Controle de origens permitidas
- **Validação**: Schemas com Joi para entrada de dados