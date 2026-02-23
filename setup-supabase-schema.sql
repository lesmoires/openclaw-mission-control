-- ============================================
-- MIGRATION: Création Schéma Mission Control
-- Dans Supabase Moira Rose Existant
-- ============================================

-- 1. Créer le schéma isolé
CREATE SCHEMA IF NOT EXISTS mission_control;

-- 2. Créer un user dédié (optionnel mais recommandé)
-- CREATE USER mission_control_app WITH PASSWORD 'secure_password';
-- GRANT USAGE ON SCHEMA mission_control TO mission_control_app;
-- ALTER USER mission_control_app SET search_path TO mission_control;

-- 3. Permissions pour Railway backend
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA mission_control TO mission_control_app;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA mission_control TO mission_control_app;

-- 4. Note: Les tables seront créées automatiquement par le backend
-- avec DB_AUTO_MIGRATE=true dans les variables Railway

-- ============================================
-- VÉRIFICATION POST-DÉPLOIEMENT:
-- ============================================
-- Vérifier que le schéma existe:
-- SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'mission_control';

-- Vérifier les tables créées:
-- SELECT tablename FROM pg_tables WHERE schemaname = 'mission_control';
