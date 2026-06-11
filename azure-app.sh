#!/bin/bash
# Ce script crée une App Service Linux pour héberger l'API Python de NexaCloud.

RESOURCE_GROUP="tenjalbertRG"
APP_NAME_STAGING="ten-nexacloud-api-staging-$RANDOM"
APP_NAME_PRODUCTION="ten-nexacloud-api-production-$RANDOM"
SUBSCRIPTION_ID="5e683e0f-b00c-48d6-9769-5aaf598de8f1" # <-- OCC_Toulouse_AdminCloud_190227_INTENSIF-PRF-2026

# Créer le plan App Service (B1 — nécessaire pour Always On et la stabilité)
# az appservice plan create \
#     --name "plan-nexacloud-we" \
#     --resource-group "$RESOURCE_GROUP" \
#     --sku B1 \
#     --is-linux

# Créer l'App Service Python pour le staging
az webapp create \
    --name "$APP_NAME_STAGING" \
    --resource-group "$RESOURCE_GROUP" \
    --plan "plan-nexacloud-we" \
    --runtime "PYTHON:3.11"

# Récupérer le publish profile (à coller dans les secrets GitHub) pour le staging
# az webapp deployment list-publishing-profiles \
#     --name "$APP_NAME_STAGING" \
#     --resource-group "$RESOURCE_GROUP" \
#     --xml

# Créer l'App Service Python pour la production
az webapp create \
    --name "$APP_NAME_PRODUCTION" \
    --resource-group "$RESOURCE_GROUP" \
    --plan "plan-nexacloud-we" \
    --runtime "PYTHON:3.11"

# Récupérer le publish profile (à coller dans les secrets GitHub) pour la production
# az webapp deployment list-publishing-profiles \
#     --name "$APP_NAME_PRODUCTION" \
#     --resource-group "$RESOURCE_GROUP" \
#     --xml
