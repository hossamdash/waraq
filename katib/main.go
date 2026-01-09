package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type note struct {
	ID      string `json:"id"`
	Title   string `json:"title"`
	Content string `json:"content"`
	Date    string `json:"date"`
}

func getNotes(c *gin.Context) {
	c.JSON(http.StatusOK, notes)
}

func postNote(c *gin.Context) {
	var newNote note

	// Call BindJSON to bind the received JSON to
	// newNote.
	if err := c.BindJSON(&newNote); err != nil {
		return
	}

	// Add the new note to the slice.
	notes = append(notes, newNote)
	c.IndentedJSON(http.StatusCreated, newNote)
}

func getNoteByID(c *gin.Context) {
	id := c.Param("id")

	// Loop over the list of notes, looking for
	// an note whose ID value matches the parameter.
	for _, a := range notes {
		if a.ID == id {
			c.JSON(http.StatusOK, a)
			return
		}
	}
	c.IndentedJSON(http.StatusNotFound, gin.H{"message": "note not found"})
}

var notes = []note{
	{ID: "1", Title: "Grocery List", Content: "Buy milk, eggs, bread, and vegetables for the week", Date: "2025-01-09"},
	{ID: "2", Title: "Project Deadline", Content: "Complete API documentation and submit pull request by Friday", Date: "2025-01-05"},
	{ID: "3", Title: "Book Recommendations", Content: "The Pragmatic Programmer, Clean Code, Designing Data-Intensive Applications", Date: "2025-01-03"},
}

func main() {
	router := gin.Default()
	router.SetTrustedProxies(nil)
	router.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
	router.GET("/notes", getNotes)
	router.GET("/note/:id", getNoteByID)
	router.POST("/note", postNote)
	router.Run() // listens on 0.0.0.0:8080 by default
}
