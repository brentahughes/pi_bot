package database

import (
	"fmt"
	"log"
	"strconv"

	"github.com/boltdb/bolt"
)

// Client hold information about current database operations
type Client struct {
	connection *bolt.DB
	bucket     string
}

// GetClient returns a open bolt connection and client instance
func GetClient() *Client {
	return &Client{}
}

// Open the database
func (c *Client) Open(bucket string) {
	db, err := bolt.Open("pi_bot.db", 0600, nil)
	if err != nil {
		log.Fatalf("Could not open database file. %s", err.Error())
	}

	c.connection = db
	c.SetBucket(bucket)
}

// Close ends the current connection
func (c *Client) Close() {
	c.connection.Close()
}

// SetBucket sets the current bucket
func (c *Client) SetBucket(bucket string) error {
	return c.connection.Update(func(tx *bolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte(bucket))
		if err != nil {
			return fmt.Errorf("Error setting up bucket: %s. %s", bucket, err)
		}

		c.bucket = bucket
		return nil
	})
}

// Put adds or updates a key pair in the currently set bucket
func (c *Client) Put(key string, value interface{}) error {
	var inputValue []byte
	switch value.(type) {
	case int:
		inputValue = []byte(strconv.Itoa(value.(int)))
	case string:
		inputValue = []byte(value.(string))
	case []byte:
		inputValue = value.([]byte)
	}

	return c.connection.Update(func(tx *bolt.Tx) error {
		err := tx.Bucket([]byte(c.bucket)).Put([]byte(key), inputValue)
		return err
	})
}

// Delete the value
func (c *Client) Delete(key string) error {
	return c.connection.Update(func(tx *bolt.Tx) error {
		return tx.Bucket([]byte(c.bucket)).Delete([]byte(key))
	})
}

// Get returns a value of the provided key in the currently set bucket
func (c *Client) Get(key string) string {
	var result string
	c.connection.View(func(tx *bolt.Tx) error {
		result = string(tx.Bucket([]byte(c.bucket)).Get([]byte(key)))
		return nil
	})

	return result
}
