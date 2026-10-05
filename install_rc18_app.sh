#!/usr/bin/env bash

# ==============================================================================
# Script de Instalação do App BACEN RC 18 no OpenMetadata
# Desenvolvido para: Ambiente Livre / Governança de Dados
# ==============================================================================

set -e

OM_HOST="${OPENMETADATA_URL:-http://localhost:8585}"
OM_TOKEN="${OPENMETADATA_JWT_TOKEN:-}"

if [ -z "$OM_TOKEN" ]; then
    echo "Erro: A variável OPENMETADATA_JWT_TOKEN não foi informada."
    echo ""
    echo "Uso:"
    echo "  export OPENMETADATA_URL=\"http://seu-server:8585\""
    echo "  export OPENMETADATA_JWT_TOKEN=\"seu_jwt_token_aqui\""
    echo "  ./install_rc18_app.sh"
    exit 1
fi

echo "Iniciando registro do App BACEN RC 18 no OpenMetadata ($OM_HOST)..."

PAYLOAD=$(cat <<EOF
{
  "name": "BacenRC18GovernanceApp",
  "displayName": "BACEN RC 18 - Governança & Dossiê",
  "description": "App para validação de KPIs, linhagem, qualidade e geração de evidências para a Resolução Conjunta nº 18 do BACEN.",
  "appType": "Internal",
  "scheduleType": "Scheduled",
  "className": "openmetadata_managed_apis.apps.bacen_rc18.app.BacenRC18App",
  "developer": "Ambiente Livre",
  "developerUrl": "https://www.ambientelivre.com.br",
  "privacyPolicyUrl": "https://www.ambientelivre.com.br",
  "supportEmail": "suporte@ambientelivre.com.br",
  "bot": "ingestion-bot",
  "appConfiguration": {
    "targetTag": "BACEN.RC18_Scope",
    "outputCustomProperty": "rc18_audit_summary",
    "minQualityScore": 90.0
  }
}
EOF
)

# Utiliza PUT para permitir registro e atualização
HTTP_RESPONSE=$(curl -s -o response.json -w "%{http_code}" -X PUT "${OM_HOST}/api/v1/apps" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${OM_TOKEN}" \
  -d "${PAYLOAD}")

if [ "$HTTP_RESPONSE" -eq 200 ] || [ "$HTTP_RESPONSE" -eq 201 ]; then
    echo "App registrado com sucesso (HTTP $HTTP_RESPONSE)!"
    echo "Acesse no OpenMetadata: Settings -> Management -> Applications"
else
    echo "Falha ao registrar o App (HTTP $HTTP_RESPONSE)."
    echo "Detalhes do erro:"
    cat response.json
    echo ""
    rm -f response.json
    exit 1
fi

rm -f response.json
