echo "Running release.sh"
# RAILS_ENV=production rails db:migrate
if [ "$APP_ENVIRONMENT" == "production" ]; then
  echo "deploy to production not available"
  exit 1
fi

echo "deploy to staging"