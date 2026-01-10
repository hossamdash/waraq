# Katib - Waraq Backend Service

Backend microservice for the Waraq note-taking system, built with Go, Gin, MongoDB Atlas, and Redis.

## Architecture

- **Framework**: Gin (Go web framework)
- **Database**: MongoDB Atlas (cloud-hosted MongoDB)
- **Cache**: Redis (configurable TTL)
- **Configuration**: Environment variables (loaded from `.env` file)

## Features

- ✅ RESTful API for note management
- ✅ MongoDB Atlas integration with retry writes and write concern
- ✅ Redis caching with configurable expiration
- ✅ Automatic cache invalidation
- ✅ CORS support with configurable origins
- ✅ Health check endpoint
- ✅ Cache hit/miss headers for debugging

## Configuration

All configuration is centralized in [`config.go`](config.go).

### Environment Variables

Create a `.env` file in the `katib` directory with the following variables:

```env
# MongoDB Atlas connection string (REQUIRED)
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/waraq

# Redis configuration (REQUIRED)
REDIS_ADDR=localhost:6379
REDIS_DB=0
REDIS_PASSWORD=

# Redis cache expiration in minutes (REQUIRED)
REDIS_CACHE_EXPIRATION_MINUTES=5

# Server configuration (REQUIRED)
PORT=8080
GIN_MODE=release

# CORS allowed origins (REQUIRED)
# Comma-separated list of allowed origins
CORS_ALLOWED_ORIGINS=http://localhost:1313,https://your-domain.com
```

See [`.env.example`](.env.example) for a template.

### Configuration Structure

The `Config` struct in [`config.go`](config.go) contains:

- **MongoDB**: Connection URI
- **Redis**: Address, password, DB, cache expiration
- **Server**: Port, Gin mode
- **CORS**: Allowed origins list

## Project Structure

```
katib/
├── config.go       # Centralized configuration loading
├── db.go           # Database connections (MongoDB & Redis)
├── handlers.go     # HTTP request handlers
├── main.go         # Application entry point
├── models.go       # Data models
├── repository.go   # Database operations
├── .env            # Environment variables (not in git)
└── .env.example    # Environment template
```

## API Endpoints

### POST `/api/v1/notes`

Create a new note.

**Request:**

```json
{
  "title": "Note Title",
  "content": "Note content"
}
```

**Response:**

```json
{
  "id": "507f1f77bcf86cd799439011",
  "title": "Note Title",
  "content": "Note content",
  "created_at": "2026-01-10T12:00:00Z"
}
```

### GET `/api/v1/notes`

Retrieve all notes (cached).

**Response Headers:**

- `X-Cache: HIT` - Served from Redis cache
- `X-Cache: MISS` - Fetched from MongoDB and cached

**Response:**

```json
[
  {
    "id": "507f1f77bcf86cd799439011",
    "title": "Note Title",
    "content": "Note content",
    "created_at": "2026-01-10T12:00:00Z"
  }
]
```

### GET `/health`

Health check endpoint.

**Response:**

```json
{
  "status": "healthy"
}
```

## Setup & Development

### Prerequisites

- Go 1.25+
- Redis (local or cloud)
- MongoDB Atlas account

### Installation

1. **Install dependencies:**

   ```bash
   go mod tidy
   ```

2. **Configure environment:**

   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

3. **Start Redis:**

   ```bash
   # Docker
   docker run -d -p 6379:6379 --name waraq-redis redis:7-alpine
   ```

4. **Run the service:**

   ```bash
   go run .
   ```

The server will start on the port specified in your `.env` file (default: 8080).

## Testing

### Create a note

```bash
curl -X POST http://localhost:8080/api/v1/notes \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Note","content":"This is a test"}'
```

### Get all notes

```bash
curl http://localhost:8080/api/v1/notes
```

### Check cache status

```bash
curl -i http://localhost:8080/api/v1/notes | grep X-Cache
```

### Health check

```bash
curl http://localhost:8080/health
```

## Production Deployment

1. **Set environment variables** on your hosting platform
2. **Set `GIN_MODE=release`** in production
3. **Configure CORS origins** to match your frontend domains
4. **Adjust cache expiration** based on your needs
5. **Use TLS/HTTPS** for all connections

## Cache Behavior

- **TTL**: Configurable via `REDIS_CACHE_EXPIRATION_MINUTES`
- **Invalidation**: Automatic on note creation
- **Miss**: Fetches from MongoDB and caches result
- **Hit**: Serves directly from Redis

## Error Handling

The service includes error handling for:

- Missing/invalid configuration
- MongoDB connection failures
- Redis connection failures
- Invalid request payloads
- Database operation failures

Check logs for detailed error messages.

## Contributing

When making changes:

1. Update [`config.go`](config.go) for new environment variables
2. Update [`.env.example`](.env.example) with new variables
3. Update this README documentation
4. Test all configuration scenarios
