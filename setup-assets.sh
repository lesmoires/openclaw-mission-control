#!/bin/bash
# ============================================
# SETUP ASSETS - Mission Control Railway Template
# ============================================
# Ce script prépare les assets visuels nécessaires
# pour la publication sur Railway Templates
# ============================================

set -e

echo "🎨 Préparation des assets visuels..."
echo ""

# Créer le dossier assets
mkdir -p assets

# ============================================
# OPTION 1: Télécharger les screenshots existants
# ============================================
echo "📸 Option 1: Téléchargement des screenshots existants..."

# Screenshot principal (depuis le README original)
curl -sL "https://github.com/user-attachments/assets/49a3c823-6aaf-4c56-8328-fb1485ee940f" \
  -o assets/screenshot-main.png 2>/dev/null && echo "  ✅ Screenshot principal" || echo "  ❌ Échec download"

# Screenshot secondaire
curl -sL "https://github.com/user-attachments/assets/2bfee13a-3dab-4f4a-9135-e47bb6949dcf" \
  -o assets/screenshot-2.png 2>/dev/null && echo "  ✅ Screenshot 2" || echo "  ❌ Échec download"

# ============================================
# OPTION 2: Créer un icône placeholder (SVG → PNG)
# ============================================
echo ""
echo "🎨 Option 2: Création icône placeholder..."

cat > assets/icon.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512">
  <defs>
    <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#6366f1;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#a855f7;stop-opacity:1" />
    </linearGradient>
  </defs>
  <rect width="512" height="512" rx="128" fill="url(#grad)"/>
  <text x="256" y="320" font-family="Arial, sans-serif" font-size="200" 
        font-weight="bold" text-anchor="middle" fill="white">🏗️</text>
</svg>
EOF

# Convertir SVG en PNG (si ImageMagick disponible)
if command -v convert > /dev/null 2>&1; then
    convert assets/icon.svg -resize 512x512 assets/icon.png
    echo "  ✅ Icône créée (icon.png)"
else
    echo "  ⚠️  ImageMagick non disponible"
    echo "     L'icône SVG est créée, convertissez-la manuellement:"
    echo "     convert assets/icon.svg assets/icon.png"
    cp assets/icon.svg assets/icon.png  # Copie temporaire
fi

# ============================================
# OPTION 3: Instructions pour création manuelle
# ============================================
echo ""
echo "📝 Instructions pour assets professionnels:"
echo ""
echo "Si vous voulez des assets de meilleure qualité:"
echo ""
echo "1. Icône (512x512px, fond transparent):"
echo "   - Utiliser: https://canva.com"
echo "   - Template: Logo 512x512"
echo "   - Couleurs: Violet (#6366f1) → Mauve (#a855f7)"
echo "   - Texte: '🏗️' ou 'MC'"
echo "   - Export: PNG transparent"
echo ""
echo "2. Screenshot (1920x1080px):"
echo "   - Démarrer Mission Control en local"
echo "   - Capturer le dashboard principal"
echo "   - Sauvegarder: assets/screenshot.png"
echo ""
echo "3. Hero Image (2400x1200px):"
echo "   - Bannière large avec logo + texte"
echo "   - 'OpenClaw Mission Control by Les Moires'"
echo ""

# ============================================
# RÉSUMÉ
# ============================================
echo ""
echo "============================================"
echo "✅ ASSETS PRÉPARÉS"
echo "============================================"
echo ""
ls -lh assets/ 2>/dev/null || echo "Aucun asset créé"
echo ""
echo "Prochaines étapes:"
echo "  1. Vérifier les assets dans ./assets/"
echo "  2. Les déplacer à la racine si OK:"
echo "     mv assets/icon.png ./icon.png"
echo "     mv assets/screenshot-main.png ./screenshot.png"
echo "  3. Commit & Push"
echo ""
