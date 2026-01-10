package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/joho/godotenv"
)

// Config holds all application configuration
type Config struct {
	// MongoDB configuration
	MongoURI string

	// Redis configuration
	RedisAddr               string
	RedisPassword           string
	RedisDB                 int
	RedisCacheExpiration    time.Duration
	RedisCacheExpirationMin int // for logging

	// Server configuration
	Port           string
	GinMode        string
	AllowedOrigins []string
}

// LoadConfig loads configuration from environment variables
func LoadConfig() (*Config, error) {
	// Load .env file if it exists
	if err := godotenv.Load(); err != nil {
		// Not fatal - can use system environment variables
		fmt.Println("Warning: .env file not found, using system environment variables")
	}

	config := &Config{}

	// MongoDB URI
	config.MongoURI = os.Getenv("MONGODB_URI")
	if config.MongoURI == "" {
		return nil, fmt.Errorf("MONGODB_URI environment variable not set")
	}

	// Redis address
	config.RedisAddr = os.Getenv("REDIS_ADDR")
	if config.RedisAddr == "" {
		return nil, fmt.Errorf("REDIS_ADDR environment variable not set")
	}

	// Redis password (optional)
	config.RedisPassword = os.Getenv("REDIS_PASSWORD")

	// Redis DB
	redisDBStr := os.Getenv("REDIS_DB")
	if redisDBStr == "" {
		return nil, fmt.Errorf("REDIS_DB environment variable not set")
	}
	redisDB, err := strconv.Atoi(redisDBStr)
	if err != nil {
		return nil, fmt.Errorf("invalid REDIS_DB value: %w", err)
	}
	config.RedisDB = redisDB

	// Redis cache expiration
	cacheMinutesStr := os.Getenv("REDIS_CACHE_EXPIRATION_MINUTES")
	if cacheMinutesStr == "" {
		return nil, fmt.Errorf("REDIS_CACHE_EXPIRATION_MINUTES environment variable not set")
	}
	cacheMinutes, err := strconv.Atoi(cacheMinutesStr)
	if err != nil {
		return nil, fmt.Errorf("invalid REDIS_CACHE_EXPIRATION_MINUTES value: %w", err)
	}
	config.RedisCacheExpirationMin = cacheMinutes
	config.RedisCacheExpiration = time.Duration(cacheMinutes) * time.Minute

	// Server port
	config.Port = os.Getenv("PORT")
	if config.Port == "" {
		return nil, fmt.Errorf("PORT environment variable not set")
	}

	// Gin mode (optional, defaults to release in production)
	config.GinMode = os.Getenv("GIN_MODE")
	if config.GinMode == "" {
		config.GinMode = "release"
	}

	// CORS allowed origins
	allowedOriginsStr := os.Getenv("CORS_ALLOWED_ORIGINS")
	if allowedOriginsStr == "" {
		return nil, fmt.Errorf("CORS_ALLOWED_ORIGINS environment variable not set")
	}
	origins := strings.Split(allowedOriginsStr, ",")
	for i, origin := range origins {
		origins[i] = strings.TrimSpace(origin)
	}
	config.AllowedOrigins = origins

	return config, nil
}
