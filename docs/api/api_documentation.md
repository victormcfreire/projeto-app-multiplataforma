# API de Coletas de Lixo

## Informações Gerais

\- OpenAPI: 3.0.0

\- Título: API de Coletas de Lixo

\- Versão: 1.0.0

\- Descrição: Documentação da API referente a operações de cadastro, login, coleta de lixo, clima, qualidade do ar e turnos de coleta.

## Endpoints

### POST /register

\- Descrição: Registra um novo usuário

\- Request Body:

    {
      "username": "usuario_exemplo",
      "password": "senha123",
      "email": "usuario@example.com"
    }

\- Responses:

\- 201: Usuário registrado com sucesso

    {
      "message": "Usuário registrado com sucesso",
      "user": {
        "id": "1",
        "username": "usuario_novo",
        "email": "usuarionovo@example.com"
      }
    }

\- 400: Requisição inválida

    {
      "error": "Usuário, senha e email são obrigatórios"
    }

\- 500: Erro interno

    {
      "error": "Erro desconhecido ao registrar usuário"
    }

### POST /login

\- Descrição: Realiza login de um usuário

\- Request Body:

    {
      "username": "usuario_novo",
      "password": "senha123",
      "email": "usuarionovo@example.com"
    }

\- Responses:

\- 200: Login realizado com sucesso

    {
      "message": "Login realizado com sucesso",
      "user": {
        "id": "1",
        "username": "usuario_novo",
        "email": "usuarionovo@example.com"
      }
    }

\- 400: Requisição inválida

    {
      "error": "Usuário e senha são obrigatórios"
    }

\- 401: Credenciais inválidas

    {
      "error": "Login falhou"
    }

\- 500: Erro interno

    {
      "error": "Erro desconhecido ao realizar login."
    }

### POST /logout

\- Descrição: Realiza logout do usuário atual

\- Responses:

\- 200: Logout realizado com sucesso

    {
      "message": "Logout realizado com sucesso"
    }

\- 401: Usuário não autenticado

    {
      "error": "Usuário não autenticado"
    }

\- 500: Erro interno

    {
      "error": "Erro desconhecido ao realizar logout."
    }

### GET /pontos-coleta

\- Descrição: Retorna pontos de coleta em formato GeoJSON FeatureCollection

\- Responses:

\- 200: Sucesso

    {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "properties": {
              "id": 1,
              "nome": "Ponto de Coleta A",
              "tipo": "orgânico"
          },
          "geometry": {
              "type": "Point",
              "coordinates": [-38.5267, -3.7319]
          }
        }
      ]
    }

### GET /qualidade-ar

\- Descrição: Retorna dados de qualidade do ar para Fortaleza

\- Responses:

\- 200: Sucesso

    {
      "indiceQualidadeAr": 28,
      "latitude": -3.73382389372,
      "longitude": -38.49113380914,
      "rua": "Rua Professor Dias da Rocha",
      "localizacao": "Edifício Gênova, 482, Rua Professor Dias da Rocha, Meireles, Fortaleza, Região Geográfica Imediata de Fortaleza, Região Geográfica Intermediária de Fortaleza, Ceará, Northeast Region, 60170-310, Brazil",
      "estacao": "https://aqicn.org/station/@562120",
      "poluenteDominante": "pm25",
      "iaqi": {
        "pm10": { "v": 18 },
        "pm25": { "v": 28 }
      }
    }

### GET /turnos-coleta

\- Descrição: Retorna turnos de coleta em GeoJSON. Query opcional ?turno=DIURNO|NOTURNO

\- Parâmetros:

\- turno (opcional): DIURNO ou NOTURNO

\- Responses:

\- 200: Sucesso

    {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": "vw_ColetaDomiciliar.fid-76b6a887_199165f4123_e3e",
          "geometry": {
            "type": "MultiPolygon",
            "coordinates": [
              [[[-38.59522713, -3.77811446, 0],[-38.59517741, -3.77730618, 0],[-38.59263809, -3.77797648, 0]]]
            ]
          },
          "properties": {
            "id": 1,
            "Nome": "211396 - SER V - BOM SUCESSO II 2",
            "Descrição": "DOMICILIAR ECOFOR",
            "Turno": "DIURNO",
            "Ano": "2024",
            "Fonte": "Secretaria Municipal de Conservação e Serviços Públicos - SCSP"
          }
        }
      ]
    }

### GET /clima

\- Descrição: Retorna dados climáticos atuais via Open-Meteo

\- Responses:

\- 200: Sucesso

    {
      "status": "ok",
      "clima": {
        "latitude": -3.75,
        "longitude": -38.5,
        "timezone": "GMT",
        "elevation": 21,
        "temperatura": 32.2,
        "temperatura_unidade": "°C",
        "tempo": "2025-09-20T14:30",
        "vento": {
          "velocidade": 22.2,
          "direcao": 107,
          "unidade": "km/h"
        },
        "codigo_clima": 2,
        "is_dia": true
      }
    }
