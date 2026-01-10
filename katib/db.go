package main

import (
	"context"
	"log"

	"github.com/redis/go-redis/v9"
	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
	"go.mongodb.org/mongo-driver/v2/mongo/writeconcern"
)

var (
	mongoClient     *mongo.Client
	redisClient     *redis.Client
	notesCollection *mongo.Collection
	ctx             = context.Background()
)

func initMongoDB(config *Config) error {
	clientOptions := options.Client().
		ApplyURI(config.MongoURI).
		// retry on transient network
		SetRetryWrites(true).
		// wait for majority of replicas to acknowledge
		SetWriteConcern(writeconcern.Majority())

	client, err := mongo.Connect(clientOptions)
	if err != nil {
		return err
	}

	if err := client.Ping(ctx, nil); err != nil {
		return err
	}

	mongoClient = client
	notesCollection = client.Database("waraq").Collection("notes")
	log.Println("✓ Connected to MongoDB Atlas")
	return nil
}

func initRedis(config *Config) error {
	redisClient = redis.NewClient(&redis.Options{
		Addr:     config.RedisAddr,
		Password: config.RedisPassword,
		DB:       config.RedisDB,
	})

	if err := redisClient.Ping(ctx).Err(); err != nil {
		return err
	}

	log.Printf("✓ Connected to Redis (cache TTL: %d minutes)", config.RedisCacheExpirationMin)
	return nil
}
