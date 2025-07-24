#!/bin/bash

echo "🚀 Quick Strapi Setup for Render..."

# Create project directory
mkdir caregiving-jobs-strapi
cd caregiving-jobs-strapi

# Create package.json
cat > package.json << 'EOF'
{
  "name": "caregiving-jobs-strapi",
  "private": true,
  "version": "0.1.0",
  "description": "Strapi CMS for caregiving jobs",
  "scripts": {
    "build": "strapi build",
    "develop": "strapi develop",
    "start": "strapi start",
    "strapi": "strapi"
  },
  "dependencies": {
    "@strapi/strapi": "4.15.5",
    "@strapi/plugin-users-permissions": "4.15.5",
    "@strapi/plugin-i18n": "4.15.5",
    "pg": "8.8.0"
  },
  "engines": {
    "node": "18.x",
    "npm": ">=6.0.0"
  }
}
EOF

# Create directories
mkdir -p config
mkdir -p src/api/job-offer/content-types/job-offer
mkdir -p src/api/application/content-types/application

# Create database config
cat > config/database.js << 'EOF'
const path = require("path");

module.exports = ({ env }) => {
  const client = env("DATABASE_CLIENT", "sqlite");

  const connections = {
    postgres: {
      connection: {
        connectionString: env("DATABASE_URL"),
        ssl: env.bool("DATABASE_SSL", false) && {
          rejectUnauthorized: env.bool("DATABASE_SSL_REJECT_UNAUTHORIZED", true),
        },
      },
      pool: { 
        min: env.int("DATABASE_POOL_MIN", 2), 
        max: env.int("DATABASE_POOL_MAX", 10) 
      },
    },
    sqlite: {
      connection: {
        filename: path.join(__dirname, "..", "..", env("DATABASE_FILENAME", "data.db")),
      },
      useNullAsDefault: true,
    },
  };

  return {
    connection: {
      client,
      ...connections[client],
      acquireConnectionTimeout: env.int("DATABASE_CONNECTION_TIMEOUT", 60000),
    },
  };
};
EOF

# Create server config
cat > config/server.js << 'EOF'
module.exports = ({ env }) => ({
  host: env("HOST", "0.0.0.0"),
  port: env.int("PORT", 1337),
  app: {
    keys: env.array("APP_KEYS"),
  },
  webhooks: {
    populateRelations: env.bool("WEBHOOKS_POPULATE_RELATIONS", false),
  },
});
EOF

# Create admin config
cat > config/admin.js << 'EOF'
module.exports = ({ env }) => ({
  auth: {
    secret: env("ADMIN_JWT_SECRET"),
  },
  apiToken: {
    salt: env("API_TOKEN_SALT"),
  },
  transfer: {
    token: {
      salt: env("TRANSFER_TOKEN_SALT"),
    },
  },
});
EOF

# Create job offer content type
cat > src/api/job-offer/content-types/job-offer/schema.json << 'EOF'
{
  "kind": "collectionType",
  "collectionName": "job_offers",
  "info": {
    "singularName": "job-offer",
    "pluralName": "job-offers",
    "displayName": "Job Offer",
    "description": "Caregiving job offers in Germany"
  },
  "options": {
    "draftAndPublish": true
  },
  "attributes": {
    "title": {
      "type": "string",
      "required": true,
      "maxLength": 255
    },
    "city": {
      "type": "string",
      "required": true,
      "maxLength": 255
    },
    "languageRequired": {
      "type": "enumeration",
      "enum": ["Basic German", "Good German", "Fluent German", "Native German", "English", "Polish"],
      "default": "Good German"
    },
    "offerType": {
      "type": "enumeration",
      "enum": ["Permanent", "Temporary", "Part-time", "Full-time", "Live-in"],
      "default": "Permanent"
    },
    "salary": {
      "type": "string",
      "required": true,
      "maxLength": 100
    },
    "deadline": {
      "type": "string",
      "required": true,
      "maxLength": 100
    },
    "description": {
      "type": "text",
      "required": true
    },
    "featured": {
      "type": "boolean",
      "default": false
    },
    "applications": {
      "type": "relation",
      "relation": "oneToMany",
      "target": "api::application.application",
      "mappedBy": "jobOffer"
    }
  }
}
EOF

# Create application content type
cat > src/api/application/content-types/application/schema.json << 'EOF'
{
  "kind": "collectionType",
  "collectionName": "applications",
  "info": {
    "singularName": "application",
    "pluralName": "applications",
    "displayName": "Application",
    "description": "Job applications from candidates"
  },
  "options": {
    "draftAndPublish": false
  },
  "attributes": {
    "name": {
      "type": "string",
      "required": true,
      "maxLength": 255
    },
    "email": {
      "type": "email",
      "required": true
    },
    "phone": {
      "type": "string",
      "maxLength": 50
    },
    "message": {
      "type": "text"
    },
    "status": {
      "type": "enumeration",
      "enum": ["pending", "reviewed", "contacted", "rejected", "hired"],
      "default": "pending"
    },
    "jobOffer": {
      "type": "relation",
      "relation": "manyToOne",
      "target": "api::job-offer.job-offer",
      "inversedBy": "applications"
    }
  }
}
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/

# Environment variables
.env

# Logs
*.log

# Database
*.db
*.sqlite

# Build
dist/
build/
.strapi-updater.json

# OS
.DS_Store
Thumbs.db
EOF

echo "✅ Strapi project created!"
echo ""
echo "📋 Next steps:"
echo "1. Push this to GitHub"
echo "2. Deploy on Render"
echo "3. Configure environment variables"