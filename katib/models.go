package main

import (
	"time"

	"go.mongodb.org/mongo-driver/v2/bson"
)

type Note struct {
	ID        bson.ObjectID `json:"id" bson:"_id,omitempty"`
	Title     string        `json:"title" bson:"title"`
	Content   string        `json:"content" bson:"content"`
	CreatedAt time.Time     `json:"created_at" bson:"created_at"`
}
