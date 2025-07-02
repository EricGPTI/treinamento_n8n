#!/bin/bash
set -e;

# Conecta ao banco de dados padrão 'postgres' para criar os outros bancos
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL
    -- Cria o banco de dados 'automation' (para n8n e Evolution API) se não existir
    DO
    \$do\$
    BEGIN
        IF NOT EXISTS (SELECT FROM pg_database WHERE datname = '${POSTGRES_DB}') THEN
            CREATE DATABASE ${POSTGRES_DB};
        END IF;
    END
    \$do\$;

    -- Removendo a criação do banco 'evolution', pois a Evolution API usará 'automation' por enquanto.
    -- Se necessário para o Evolution API, poderíamos criar 'evolution' e o usuário 'user' novamente.
    -- Mas vamos simplificar ao máximo para ver se funciona.
EOSQL

# --- Não precisamos conceder permissões para o POSTGRES_USER nos bancos criados,
#     pois ele já é o superusuário e tem acesso total.
# --- Removido as seções de GRANTS para POSTGRES_NON_ROOT_USER e "user".