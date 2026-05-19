NGINX_CONF=./nginx/nginx.conf

  if grep -q "api-blue" "$NGINX_CONF"; then
    CURRENT=blue
    TARGET=green
  else
    CURRENT=green
    TARGET=blue
  fi

  echo "Current: $CURRENT → Target: $TARGET"

  if ! docker-compose exec "api-$TARGET" wget -qO- http://localhost:3000/todos > /dev/null 2>&1; then
    echo "Health check failed on api-$TARGET. Aborting."
    exit 1
  fi

  echo "Health check passed on api-$TARGET"

  sed -i "s/server api-$CURRENT:3000/server api-$TARGET:3000/" "$NGINX_CONF"

  docker-compose exec nginx nginx -s reload

  echo "Switched from $CURRENT to $TARGET"

