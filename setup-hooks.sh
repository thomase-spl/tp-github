#!/bin/bash
# setup-hooks.sh — Installe les hooks locaux (à lancer une fois par développeur)

set -e

echo "=== Installation des hooks locaux NexaCloud ==="

# 1. Installer pre-commit
PYTHON=python3
if ! command -v "$PYTHON" &>/dev/null; then
    PYTHON=python
fi

if ! command -v "$PYTHON" &>/dev/null; then
    echo "Erreur : Python n'est pas installé ou inaccessible. Installez Python et relancez le script."
    exit 1
fi

if ! "$PYTHON" -m pip --version &>/dev/null; then
    echo "Erreur : pip n'est pas disponible pour $PYTHON. Installez pip puis relancez le script."
    exit 1
fi

if ! command -v pre-commit &>/dev/null; then
    echo "Installation de pre-commit..."
    "$PYTHON" -m pip install --user pre-commit --quiet
fi

# 2. Activer les hooks pre-commit
"$PYTHON" -m pre_commit install
echo "✅ Hooks pre-commit activés"

# 3. Installer le hook pre-push
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
echo "[pre-push] Lancement des tests..."
cd ressources && pytest -q
EXIT_CODE=$?
cd ..
[ $EXIT_CODE -ne 0 ] && echo "❌ Tests échoués — push bloqué" && exit 1
echo "✅ Tests passés — push autorisé"
EOF
chmod +x .git/hooks/pre-push
echo "✅ Hook pre-push installé"

echo ""
echo "=== Hooks installés avec succès ==="
echo "  pre-commit : flake8 + trailing-whitespace + check-yaml"
echo "  pre-push   : pytest"
