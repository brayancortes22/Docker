#!/bin/bash
# Script simple que detecta cambios en la rama remota y actualiza el proyecto.
# Ajusta BRANCH si usas otra rama (ej: main, master).
BRANCH="${BRANCH:-main}"
REPO_DIR="/app/back"
LOGFILE="/var/log/git_autorefresh.log"
ERRFILE="/var/log/git_autorefresh.err"

echo "$(date '+%F %T') - git_autorefresh iniciado. Observando rama: $BRANCH" >> "$LOGFILE"

cd "$REPO_DIR" || { echo "No existe $REPO_DIR" >> "$ERRFILE"; exit 1; }

while true; do
  # Obtener datos remotos
  git fetch origin "$BRANCH" --quiet 2>>"$ERRFILE" || true
  LOCAL=$(git rev-parse HEAD 2>>"$ERRFILE" || echo "")
  REMOTE=$(git rev-parse origin/"$BRANCH" 2>>"$ERRFILE" || echo "")
  if [ -n "$LOCAL" ] && [ -n "$REMOTE" ] && [ "$LOCAL" != "$REMOTE" ]; then
    echo "$(date '+%F %T') - Cambios detectados en origin/$BRANCH. Actualizando..." >> "$LOGFILE"
    git reset --hard origin/"$BRANCH" >>"$LOGFILE" 2>>"$ERRFILE" || true

    # activar venv e instalar dependencias si existen cambios en requirements
    if [ -f "venv/bin/activate" ]; then
      source /app/back/venv/bin/activate
      pip install -r requirements.txt >>"$LOGFILE" 2>>"$ERRFILE" || true
    fi

    # ejecutar migraciones y recolectar estáticos
    python manage.py migrate --noinput >>"$LOGFILE" 2>>"$ERRFILE" || true
    python manage.py collectstatic --noinput >>"$LOGFILE" 2>>"$ERRFILE" || true

    # reiniciar proceso django en supervisor (nombre: django)
    supervisorctl restart django >>"$LOGFILE" 2>>"$ERRFILE" || true
    echo "$(date '+%F %T') - Actualización completa." >> "$LOGFILE"
  fi

  sleep 10
done
