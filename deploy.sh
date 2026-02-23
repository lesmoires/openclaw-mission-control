#!/bin/bash
# ============================================
# DEPLOY MISSION CONTROL TO MOIRA ROSE
# Choix: Option A (Supabase) ou Option B (Isolation)
# ============================================

set -e

echo "🚀 Déploiement Mission Control sur Railway - Moira Rose"
echo ""

# Vérifier répertoire
if [ ! -f "railway.toml" ]; then
    echo "❌ Lancer depuis le repo openclaw-mission-control/"
    exit 1
fi

echo "Choisissez l'architecture:"
echo ""
echo "[A] Option A - Réutiliser Supabase existant (GRATUIT)"
echo "    ✅ $0/mois - Schéma 'mission_control' dans DB existante"
echo "    ⚠️  Partage ressources avec PG on Rails"
echo ""
echo "[B] Option B - Services Railway séparés (~$20/mois)"
echo "    ✅ Isolation complète - Scaling indépendant"
echo "    💰 Nouvelle PostgreSQL + Redis Railway"
echo ""
read -p "Votre choix [A/B]: " CHOICE

if [[ $CHOICE == "A" || $CHOICE == "a" ]]; then
    echo ""
    echo "✅ Option A sélectionnée: Supabase Existant"
    echo ""
    
    # Copier config Option A
    cp railway-optionA-supabase.toml railway.toml
    cp railway-optionA.env railway.env
    
    echo "📋 Prochaines étapes:"
    echo ""
    echo "1. Exécuter sur Supabase SQL Editor:"
    echo "   → setup-supabase-schema.sql"
    echo "   (Créera le schéma 'mission_control')"
    echo ""
    echo "2. Configurer variables Railway:"
    echo "   AUTH_MODE=local"
    echo "   LOCAL_AUTH_TOKEN=$(openssl rand -hex 32)"
    echo "   OPENCLAW_GATEWAY_URL=ws://gateway.railway.internal:18789"
    echo "   OPENCLAW_GATEWAY_TOKEN=<votre_token>"
    echo ""
    echo "3. Deploy sur Railway"
    echo ""
    
elif [[ $CHOICE == "B" || $CHOICE == "b" ]]; then
    echo ""
    echo "✅ Option B sélectionnée: Services Séparés"
    echo ""
    
    # Copier config Option B
    cp railway-optionB-isolation.toml railway.toml
    
    echo "📋 Railway créera automatiquement:"
    echo "   - PostgreSQL dédiée"
    echo "   - Redis dédié"
    echo ""
    echo "Variables à configurer:"
    echo "   AUTH_MODE=local"
    echo "   LOCAL_AUTH_TOKEN=$(openssl rand -hex 32)"
    echo "   OPENCLAW_GATEWAY_URL=ws://gateway.railway.internal:18789"
    echo "   OPENCLAW_GATEWAY_TOKEN=<votre_token>"
    echo ""
    echo "💰 Coût estimé: ~$15-25/mois"
    echo ""
    
else
    echo "❌ Choix invalide. Relancer le script."
    exit 1
fi

echo "✅ Configuration prête !"
echo ""
echo "Commandes Git:"
echo "  git add railway.toml railway.env"
echo "  git commit -m 'Configure Railway deployment - Option $CHOICE'"
echo "  git push origin main"
echo ""
echo "Puis: Railway Dashboard → Deploy"
