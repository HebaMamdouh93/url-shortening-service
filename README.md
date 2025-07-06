# URL Shortener Service

A simple, secure URL shortening service built with **Ruby on Rails 8.0.2**, **Ruby 3.2.8**, and **Redis 7.0.15** for caching.

---

## Features

✅ Encode long URLs to short, unique Base62 short codes  
✅ Decode short codes back to original URLs  
✅ Token-based API authentication (`Authorization: Bearer <api_token>`)  
✅ Redis caching for fast lookups  
✅ Automatic persistence in the database  
✅ Fully documented API with Swagger (`rswag`)  
✅ RSpec tests for units, requests, and edge cases

---

## Requirements

- **Ruby** `3.2.8`
- **Rails** `8.0.2`
- **Redis server** `7.0.15`
- **RSpec** for testing
- **PostgreSQL** for database

---

## Setup

```bash
# Clone the repo
git clone https://github.com/HebaMamdouh93/url-shortening-service.git
cd url-shortening-service

# Install gems
bundle install

# Setup database
rails db:create db:migrate
```
---

## API Token for Testing

Running the seed will create an `ApiClient` with a valid `api_token`.

```bash
rails db:seed
```

✅ Check the console output or run:

```bash
rails c
ApiClient.first.api_token
```

Use this token as a **Bearer token** in your requests:

```
Authorization: Bearer YOUR_API_TOKEN
```

---

## Run the Server

```bash
rails s
```

By default, the API will be available at `http://localhost:3000`.

---

## API Endpoints

### **Encode**

* `POST /api/v1/encode`

  * Body: `{ "url": "https://example.com" }`
  * Returns: `{ "short_url": "http://localhost:3000/abc123" }`

### **Decode**

* `POST /api/v1/decode`

  * Body: `{ "short_url": "abc123" }`
  * Returns: `{ "original_url": "https://example.com" }`

> **Note:** All requests must include `Authorization: Bearer <api_token>`.

---

## API Documentation (Swagger)

**Swagger UI** is auto-generated with `rswag`.

1. Run specs to generate Swagger JSON:

   ```bash
   bundle exec rails rswag
   ```

2. Visit:

   ```
   http://localhost:3000/api-docs
   ```

3. Authorize by clicking **Authorize** and providing:

   ```
   Authorization: Bearer YOUR_API_TOKEN
   ```

---

## Run Tests

Run all RSpec specs, including unit, request, and integration tests:

```bash
bundle exec rspec
```

Generate and update Swagger docs:

```bash
bundle exec rails rswag
```

---

## Environment Variables

```bash
touch .env
cp .env.example .env
```

## Security Considerations & Potential Attack Vectors

This service has the following potential security concerns:

### 1. Short Code Brute Forcing
- **Risk:** Attackers may guess valid short codes to discover URLs.
- **Mitigation:** Codes are based on unique IDs, but longer or randomized codes could further reduce guessability. Rate limiting and monitoring can be added.

### 2. Short Code Collisions
- **Risk:** Two URLs produce the same short code.
- **Mitigation:** Primary keys and uniqueness constraints prevent this. Short code generation is deterministic and wrapped in a transaction.

### 3. Cache Poisoning
- **Risk:** Manipulating cached mappings.
- **Mitigation:** Cache keys are scoped and DB is always the source of truth.

### 4. API Abuse / DoS
- **Risk:** Excessive requests overwhelm the system.
- **Mitigation:** Rate limiting, API token usage, and activity monitoring.

### 5. Token Security
- **Risk:** API tokens could be leaked or misused.
- **Mitigation:** Use Bearer tokens securely over HTTPS and allow token revocation.

### 6. Input Validation
- **Risk:** Malformed input could break the app.
- **Mitigation:** Strong param validation, regex URL checks, and consistent error handling.

