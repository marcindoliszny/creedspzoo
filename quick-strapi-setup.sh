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