
# Requisitos do Sistema - EcoMapa Fortaleza

## Requisitos Funcionais (RF)

| ID | Descrição | Prioridade |
|----|-----------|------------|
| RF01 | Disponibilizar pontos de coleta via GET /pontos-coleta | Alta |
| RF02 | Disponibilizar turnos de coleta via GET /turnos-coleta | Alta |
| RF03 | Fornecer informações meteorológicas via GET /clima | Média |
| RF04 | Fornecer qualidade do ar via GET /qualidade-ar | Média |
| RF05 | Autenticação de usuários (/register, /login, /logout) | Alta |
| RF06 | Aceitar parâmetros de filtro (ex.: turno em /turnos-coleta) | Média |
| RF07 | Retornar respostas JSON/GeoJSON válidas | Alta |
| RF08 | Tratamento de erros e exceções | Alta |
| RF09 | Testes unitários com Jest/Supertest | Média |
| RF10 | Integração com Back4App | Alta |
| RF11 | Registro e login de usuários via Back4App | Alta |
| RF12 | Documentação via Swagger (/docs) | Baixa |

## Requisitos Não-Funcionais (RNF)

| ID | Descrição | Categoria |
|----|-----------|-----------|
| RNF01 | Linguagem Node.js 20+ com Express | Performance |
| RNF02 | Arquitetura modular (controllers, routes, services) | Manutenibilidade |
| RNF03 | Comunicação assíncrona | Performance |
| RNF04 | Integração com APIs externas e Back4App | Interoperabilidade |
| RNF05 | Testabilidade (cobertura de 90.29%) | Confiabilidade |
| RNF06 | Padronização de dados (JSON/GeoJSON) | Interoperabilidade |
| RNF07 | Variáveis de ambiente para configuração | Segurança |
| RNF08 | Segurança (proteção de dados, tratamento de erros) | Segurança |
| RNF09 | Documentação acessível (Swagger) | Usabilidade |
| RNF10 | Escalabilidade e manutenção | Escalabilidade |
| RNF11 | Reutilização de código | Manutenibilidade |
| RNF12 | Front-end multiplataforma com Flutter | Portabilidade |

## Regras de Negócio

| ID | Regra | Descrição |
|----|-------|-----------|
| RN01 | Autenticação obrigatória | Endpoints de dados sensíveis requerem autenticação |
| RN02 | Filtro por turno | /turnos-coleta deve aceitar parâmetro ?turno= |
| RN03 | Formato GeoJSON | Pontos de coleta devem seguir padrão GeoJSON |
| RN04 | Sessão de usuário | Tokens de sessão expiram após período de inatividade |
| RN05 | Dados ambientais em cache | APIs externas podem ter cache para performance |

## Histórias de Usuário

**Como** morador de Fortaleza  
**Quero** visualizar os pontos de coleta mais próximos no mapa  
**Para que** eu possa descartar meu lixo corretamente

**Como** usuário consciente  
**Quero** consultar a qualidade do ar e condições climáticas  
**Para** planejar melhor meus deslocamentos

**Como** secretário do meio ambiente  
**Quero** acessar dados centralizados sobre coleta  
**Para** tomar decisões baseadas em dados reais

**Como** cidadão  
**Quero** filtrar pontos de coleta por turno  
**Para** encontrar locais que estejam funcionando no meu horário disponível

## Perfis de Usuários

### 1. Morador Urbano
- **Necessidades:** Encontrar pontos de coleta próximos, saber horários de funcionamento
- **Habilidades Técnicas:** Básicas a intermediárias com smartphones
- **Frequência de Uso:** Semanal a mensal

### 2. Autoridade Municipal
- **Necessidades:** Dados agregados sobre coleta, relatórios de uso do sistema
- **Habilidades Técnicas:** Intermediárias a avançadas
- **Frequência de Uso:** Diária a semanal

### 3. Empresa de Coleta
- **Necessidades:** Informações sobre demanda, otimização de rotas
- **Habilidades Técnicas:** Intermediárias
- **Frequência de Uso:** Diária

### 4. Organização Ambiental
- **Necessidades:** Dados para campanhas de conscientização, métricas de impacto
- **Habilidades Técnicas:** Variadas
- **Frequência de Uso:** Semanal a mensal
