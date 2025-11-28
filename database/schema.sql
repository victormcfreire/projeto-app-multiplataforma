-- Tabela _User (Usuários)
CREATE TABLE _User (
    objectId VARCHAR(255) PRIMARY KEY,
    createdAt TIMESTAMP,
    updatedAt TIMESTAMP,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    emailVerified BOOLEAN DEFAULT FALSE,
    authData JSON,
    ACL JSON
);

-- Índices para _User
CREATE INDEX idx_user_objectId ON _User(objectId);
CREATE INDEX idx_user_username ON _User(username);
CREATE INDEX idx_user_email ON _User(email);
CREATE INDEX idx_user_username_ci ON _User(LOWER(username));
CREATE INDEX idx_user_email_ci ON _User(LOWER(email));

-- Tabela _Role (Roles/Papéis)
CREATE TABLE _Role (
    objectId VARCHAR(255) PRIMARY KEY,
    createdAt TIMESTAMP,
    updatedAt TIMESTAMP,
    name VARCHAR(255) UNIQUE NOT NULL,
    ACL JSON
);

-- Tabela de relação _Role_users (Relacionamento Role-User)
CREATE TABLE _Role_users (
    roleId VARCHAR(255),
    userId VARCHAR(255),
    FOREIGN KEY (roleId) REFERENCES _Role(objectId),
    FOREIGN KEY (userId) REFERENCES _User(objectId),
    PRIMARY KEY (roleId, userId)
);

-- Tabela de relação _Role_roles (Relacionamento Role-Role hierárquico)
CREATE TABLE _Role_roles (
    parentRoleId VARCHAR(255),
    childRoleId VARCHAR(255),
    FOREIGN KEY (parentRoleId) REFERENCES _Role(objectId),
    FOREIGN KEY (childRoleId) REFERENCES _Role(objectId),
    PRIMARY KEY (parentRoleId, childRoleId)
);

-- Índices para _Role
CREATE INDEX idx_role_objectId ON _Role(objectId);
CREATE INDEX idx_role_name ON _Role(name);

-- Tabela Maps
CREATE TABLE Maps (
    objectId VARCHAR(255) PRIMARY KEY,
    createdAt TIMESTAMP,
    updatedAt TIMESTAMP,
    GeoJSON VARCHAR(255) NOT NULL, -- Referência ao arquivo
    Nome VARCHAR(255) NOT NULL,
    ACL JSON
);

-- Índices para Maps
CREATE INDEX idx_maps_objectId ON Maps(objectId);

-- Tabela _Session (Sessões)
CREATE TABLE _Session (
    objectId VARCHAR(255) PRIMARY KEY,
    createdAt TIMESTAMP,
    updatedAt TIMESTAMP,
    user VARCHAR(255),
    installationId VARCHAR(255),
    sessionToken VARCHAR(255) UNIQUE,
    expiresAt TIMESTAMP,
    createdWith JSON,
    ACL JSON,
    FOREIGN KEY (user) REFERENCES _User(objectId)
);

-- Índices para _Session
CREATE INDEX idx_session_objectId ON _Session(objectId);
CREATE INDEX idx_session_user ON _Session(user);
CREATE INDEX idx_session_token ON _Session(sessionToken);
CREATE INDEX idx_session_expires ON _Session(expiresAt);

-- Comentários explicativos das tabelas
COMMENT ON TABLE _User IS 'Tabela de usuários do sistema Back4App';
COMMENT ON TABLE _Role IS 'Tabela de roles/papéis do sistema Back4App';
COMMENT ON TABLE Maps IS 'Tabela de mapas com arquivos GeoJSON';
COMMENT ON TABLE _Session IS 'Tabela de sessões de usuário';