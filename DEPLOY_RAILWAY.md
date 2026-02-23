# 🚀 DÉPLOIEMENT RAILWAY - Mission Control Les Moires

## Architecture

```
┌─────────────────────────────────────────┐
│         Railway Project: moira-rose     │
│                                         │
│  ┌─────────────┐    ┌─────────────────┐ │
│  │  Frontend   │◄──►│     Backend     │ │
│  │   (UI)      │    │   (FastAPI)     │ │
│  │   :3000     │    │    :8000        │ │
│  └─────────────┘    └────────┬────────┘ │
│                              │          │
│  ┌───────────────────────────┼────────┐ │
│  │                           ▼        │ │
│  │  ┌──────────┐    ┌────────────────┐│ │
│  │  │PostgreSQL│    │     Redis      ││ │
│  │  │   (DB)   │    │    (Queue)     ││ │
│  │  └──────────┘    └────────────────┘│ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

## Prérequis

1. **Compte Railway** avec projet `moira-rose`
2. **Fork GitHub** : `lesmoires/openclaw-mission-control`
3. **Token OpenClaw Gateway** (pour connexion)

## Étapes de Déploiement

### 1. Connexion GitHub → Railway

Dans Railway Dashboard:
- **New Project** → **Deploy from GitHub repo**
- Sélectionner: `lesmoires/openclaw-mission-control`

### 2. Configuration Services

Railway détectera automatiquement les services via `railway.toml`:

| Service | Détecté | Action |
|---------|---------|--------|
| `mission-control-backend` | ✅ Auto | Vérifier build |
| `mission-control-frontend` | ✅ Auto | Vérifier build |
| `mission-control-worker` | ✅ Auto | Optionnel |
| PostgreSQL | ✅ Auto | Créer DB |
| Redis | ✅ Auto | Créer Redis |

### 3. Variables d'Environnement

Ajouter dans Railway Dashboard → Variables:

```bash
# Authentification (CRITIQUE)
AUTH_MODE=local
LOCAL_AUTH_TOKEN=<générer_un_token_50_chars+>

# OpenClaw Gateway
OPENCLAW_GATEWAY_URL=ws://host.railway.internal:18789
OPENCLAW_GATEWAY_TOKEN=<token_gateway>

# Frontend
NEXT_PUBLIC_API_URL=<railway_backend_url>/api
```

**Générer LOCAL_AUTH_TOKEN:**
```bash
openssl rand -hex 32
```

### 4. Déploiement

1. **Backend** se déploie d'abord (dépendances DB)
2. **Frontend** se déploie ensuite
3. **Worker** démarre (si activé)

### 5. Vérification

```bash
# Health check backend
curl https://<backend-url>/health

# Vérifier Gateway connection
# (dans les logs Railway)
```

## URLs après déploiement

| Service | URL Pattern |
|---------|-------------|
| Frontend | `https://mission-control-frontend-<hash>.up.railway.app` |
| Backend API | `https://mission-control-backend-<hash>.up.railway.app` |

## Configuration DNS (Optionnel)

Pour utiliser `mission-control.lesmoires.com`:
1. Railway → Domain → Custom Domain
2. Ajouter CNAME chez registrar
3. Attendre validation SSL

## Troubleshooting

### Erreur "Field required [auth_mode]"
→ Vérifier que `AUTH_MODE=local` est bien configuré

### Connexion Gateway échoue
→ Vérifier `OPENCLAW_GATEWAY_URL` et `OPENCLAW_GATEWAY_TOKEN`
→ Vérifier que Gateway est accessible depuis Railway (networking interne)

### Database connection failed
→ Vérifier que `DATABASE_URL` est bien injecté par Railway PostgreSQL

## Fichiers Modifiés pour Railway

- `railway.toml` (nouveau) - Configuration multi-services
- `railway.env` (nouveau) - Variables template
- `backend/Dockerfile` (existant) - Déjà compatible

## Commandes Utiles

```bash
# Logs
railway logs --service mission-control-backend

# Variables
railway variables --service mission-control-backend

# Redeploy
railway up --service mission-control-backend
```
