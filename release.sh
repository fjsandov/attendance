echo "Running release.sh"
# RAILS_ENV=production rails db:migrate
if [ "$APP_ENVIRONMENT" == "production" ]; then
  echo "Deploy to production not available"
  exit 1
fi

echo "Deploy to staging"