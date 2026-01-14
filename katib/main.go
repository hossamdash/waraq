package main

import (
	"log"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func main() {
	// Load configuration
	config, err := LoadConfig()
	if err != nil {
		log.Fatal("Configuration failed:", err)
	}

	// Store config globally for handlers
	appConfig = config

	// Initialize connections
	if err := initMongoDB(config); err != nil {
		log.Fatal("MongoDB connection failed:", err)
	}
	defer mongoClient.Disconnect(ctx)

	if err := initRedis(config); err != nil {
		log.Fatal("Redis connection failed:", err)
	}
	defer redisClient.Close()

	// Setup Gin router
	router := gin.New()
	router.SetTrustedProxies(nil)

	// Custom logger to skip health check endpoint
	router.Use(gin.LoggerWithConfig(gin.LoggerConfig{
		SkipPaths: []string{"/health"},
	}))
	// Recovery middleware recovers from any panics and writes a 500 if there was one. it's included by default in gin.Default()
	router.Use(gin.Recovery())

	// CORS configuration
	router.Use(cors.New(cors.Config{
		AllowOrigins:     config.AllowedOrigins,
		AllowMethods:     []string{"GET", "POST", "OPTIONS"},
		AllowHeaders:     []string{"Content-Type", "Authorization"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))

	log.Printf("✓ CORS enabled for origins: %v", config.AllowedOrigins)

	// Health check
	router.GET("/health", healthCheck)

	// API routes
	api := router.Group("/api/v1")
	{
		api.POST("/notes", postNote)
		api.GET("/notes", getNotes)
	}

	log.Printf("🚀 Server starting on port %s", config.Port)
	if err := router.Run(":" + config.Port); err != nil {
		log.Fatal("Server failed to start:", err)
	}
}
