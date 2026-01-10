package main

import (
	"encoding/json"
	"log"
	"time"

	"go.mongodb.org/mongo-driver/v2/bson"
)

func createNote(note *Note) (bson.ObjectID, error) {
	note.CreatedAt = time.Now()
	result, err := notesCollection.InsertOne(ctx, note)
	if err != nil {
		return bson.ObjectID{}, err
	}
	return result.InsertedID.(bson.ObjectID), nil
}

func getAllNotes() ([]Note, error) {
	cursor, err := notesCollection.Find(ctx, bson.M{})
	if err != nil {
		return nil, err
	}
	defer cursor.Close(ctx)

	var notes []Note
	if err := cursor.All(ctx, &notes); err != nil {
		return nil, err
	}

	if notes == nil {
		notes = []Note{}
	}

	return notes, nil
}

func getCachedNotes() ([]Note, error) {
	cached, err := redisClient.Get(ctx, "notes:all").Result()
	if err != nil {
		return nil, err
	}

	var notes []Note
	if err := json.Unmarshal([]byte(cached), &notes); err != nil {
		return nil, err
	}

	return notes, nil
}

func cacheNotes(notes []Note, config *Config) error {
	notesJSON, err := json.Marshal(notes)
	if err != nil {
		return err
	}
	return redisClient.Set(ctx, "notes:all", notesJSON, config.RedisCacheExpiration).Err()
}

func invalidateNotesCache() {
	if err := redisClient.Del(ctx, "notes:all").Err(); err != nil {
		log.Printf("Warning: Failed to invalidate cache: %v", err)
	}
}
