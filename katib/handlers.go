package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

var appConfig *Config

func postNote(c *gin.Context) {
	var newNote Note
	if err := c.BindJSON(&newNote); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	id, err := createNote(&newNote)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save note"})
		return
	}
	newNote.ID = id
	invalidateNotesCache()

	c.JSON(http.StatusCreated, newNote)
	log.Printf("✓ Created note: %s", newNote.Title)
}

func getNotes(c *gin.Context) {
	// Try cache first
	notes, err := getCachedNotes()
	if err == nil {
		c.Header("X-Cache", "HIT")
		c.JSON(http.StatusOK, notes)
		log.Println("✓ Served notes from Redis cache")
		return
	}

	// Cache miss - fetch from MongoDB
	notes, err = getAllNotes()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve notes"})
		return
	}

	// Cache the result
	if err := cacheNotes(notes, appConfig); err != nil {
		log.Printf("Warning: Failed to cache notes: %v", err)
	}

	c.Header("X-Cache", "MISS")
	c.JSON(http.StatusOK, notes)
	log.Printf("✓ Served %d notes from MongoDB (cached for %d min)", len(notes), appConfig.RedisCacheExpirationMin)
}

func healthCheck(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "healthy",
	})
}
