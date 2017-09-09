package database

import (
	"bytes"
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

// GetDatabaseClient returns a open bolt connection and client instance
func GetDatabaseClient() *Client {
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
func (c *Client) Get(key string) (result string) {
	c.connection.View(func(tx *bolt.Tx) error {
		result = string(tx.Bucket([]byte(c.bucket)).Get([]byte(key)))
		return nil
	})

	return result
}

// GetTimeSeriesList returns the cursor for iterating over all values of a bucket
func (c *Client) GetTimeSeriesList(startTime, endTime interface{}) (results []string) {
	c.connection.View(func(tx *bolt.Tx) error {
		cursor := tx.Bucket([]byte(c.bucket)).Cursor()

		var min, max []byte

		if startTime == nil {
			min = []byte("1900-01-01T00:00:00Z")
		} else {
			min = []byte(startTime.(string))
		}

		if endTime == nil {
			max = []byte("2200-01-01T00:00:00Z")
		} else {
			max = []byte(endTime.(string))
		}

		for k, v := cursor.Seek(min); k != nil && bytes.Compare(k, max) <= 0; k, v = cursor.Next() {
			results = append(results, string(v))
		}

		return nil
	})

	return results
}

// GetList returns the cursor for iterating over all values of a bucket
func (c *Client) GetList(count int, direction string) (results []string) {
	c.connection.View(func(tx *bolt.Tx) error {
		cursor := tx.Bucket([]byte(c.bucket)).Cursor()

		var i = 0
		if direction == "asc" {
			for k, v := cursor.First(); k != nil && i < count; k, v = cursor.Next() {
				results = append(results, string(v))
				i++
			}
		} else if direction == "desc" {
			for k, v := cursor.Last(); k != nil && i < count; k, v = cursor.Prev() {
				results = append(results, string(v))
				i++
			}
		}

		return nil
	})

	return results
}

// DeleteBefore delete all keys before a specified key in an ordered list
func (c *Client) DeleteBefore(key string) (err error) {
	c.connection.Update(func(tx *bolt.Tx) error {
		counter := 0
		cursor := tx.Bucket([]byte(c.bucket)).Cursor()
		for k, _ := cursor.Seek([]byte(key)); k != nil; k, _ = cursor.Prev() {
			if counter != 0 {
				err = tx.Bucket([]byte(c.bucket)).Delete(k)
			}

			counter++
		}

		return err
	})

	return err
}
