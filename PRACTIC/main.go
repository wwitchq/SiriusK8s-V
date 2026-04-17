package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	_ "github.com/lib/pq"
)

var db *sql.DB

func init() {
	connStr := "postgres://postgres:postgres@postgres:5432/demo?sslmode=disable"
	var err error
	
	// Retry connection for 30 seconds
	for i := 0; i < 6; i++ {
		db, err = sql.Open("postgres", connStr)
		if err == nil {
			err = db.Ping()
			if err == nil {
				break
			}
		}
		time.Sleep(5 * time.Second)
	}
	
	if err != nil {
		log.Fatalf("Database connection failed: %v", err)
	}
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, `{"status":"healthy","timestamp":"%s"}`, time.Now().Format(time.RFC3339))
}

func apiHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	
	// Query database - this may fail if DB is broken
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM users").Scan(&count)
	
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, `{"error":"database error: %s"}`, err.Error())
		log.Printf("Database error: %v", err)
		return
	}
	
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, `{"message":"API working","user_count":%d,"timestamp":"%s"}`, 
		count, time.Now().Format(time.RFC3339))
}

func main() {
	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/api/status", apiHandler)
	
	port := ":8080"
	log.Printf("Server starting on %s", port)
	log.Fatal(http.ListenAndServe(port, nil))
}
