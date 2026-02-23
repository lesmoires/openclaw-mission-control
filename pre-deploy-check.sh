#!/bin/bash
# ============================================
# PRE-DEPLOY CHECK - Mission Control Railway
# ============================================

set -e

echo "🔍 Vérification pré-déploiement Railway..."
echo ""

ERRORS=0
WARNINGS=0

# 1. Vérifier fichiers essentiels
echo "📁 Vérification fichiers..."
for file in railway.toml railway.env DEPLOY_RAILWAY.md; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file MANQUANT"
        ((ERRORS++))
    fi
done

# 2. Vérifier backend Dockerfile
echo ""
echo "🐳 Vérification Docker..."
if [ -f "backend/Dockerfile" ]; then
    echo "  ✅ backend/Dockerfile"
else
    echo "  ❌ backend/Dockerfile MANQUANT"
    ((ERRORS++))
fi

# 3. Vérifier variables critiques dans railway.env
echo ""
echo "🔐 Vérification variables..."
if [ -f "railway.env" ]; then
    # Vérifier AUTH_MODE
    if grep -q "AUTH_MODE=" railway.env; then
        echo "  ✅ AUTH_MODE défini"
    else
        echo "  ❌ AUTH_MODE manquant"
        ((ERRORS++))
    fi
    
    # Vérifier LOCAL_AUTH_TOKEN placeholder
    if grep -q "LOCAL_AUTH_TOKEN=change_me" railway.env; then
        echo "  ⚠️  LOCAL_AUTH_TOKEN doit être changé avant deploy"
        ((WARNINGS++))
    fi
    
    # Vérifier OPENCLAW_GATEWAY_URL
    if grep -q "OPENCLAW_GATEWAY_URL=" railway.env; then
        echo "  ✅ OPENCLAW_GATEWAY_URL défini"
    else
        echo "  ❌ OPENCLAW_GATEWAY_URL manquant"
        ((ERRORS++))
    fi
else
    echo "  ❌ railway.env introuvable"
    ((ERRORS++))
fi

# 4. Vérifier schéma SQL Supabase
echo ""
echo "🗄️  Vérification Supabase..."
if [ -f "setup-supabase-schema.sql" ]; then
    echo "  ✅ setup-supabase-schema.sql"
    echo "     ⚠️  N'oubliez pas d'exécuter ce script sur Supabase avant deploy"
    ((WARNINGS++))
else
    echo "  ⚠️  setup-supabase-schema.sql manquant (Option B utilisée ?)"
fi

# 5. Vérifier Git
echo ""
echo "📦 Vérification Git..."
if [ -d ".git" ]; then
    echo "  ✅ Repo Git initialisé"
    
    # Vérifier remote
    if git remote -v > /dev/null 2>&1; then
        echo "  ✅ Remote Git configuré"
        git remote -v | head -2
    else
        echo "  ❌ Pas de remote Git configuré"
        ((ERRORS++))
    fi
    
    # Vérifier commits non poussés
    if [ -n "$(git status --porcelain)" ]; then
        echo "  ⚠️  Modifications non commitées:"
        git status --short
        ((WARNINGS++))
    else
        echo "  ✅ Working directory clean"
    fi
else
    echo "  ❌ Pas un repo Git"
    ((ERRORS++))
fi

# 6. Résumé
echo ""
echo "============================================"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ TOUS LES CHECKS PASSÉS !"
    echo ""
    echo "Prêt pour déploiement Railway:"
    echo "  git push origin main"
    echo "  # Puis Railway Dashboard → Deploy"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  $WARNINGS AVERTISSEMENT(S)"
    echo ""
    echo "Déploiement possible mais vérifiez les avertissements ci-dessus."
    exit 0
else
    echo "❌ $ERRORS ERREUR(S), $WARNINGS AVERTISSEMENT(S)"
    echo ""
    echo "Corrigez les erreurs avant de déployer."
    exit 1
fi
