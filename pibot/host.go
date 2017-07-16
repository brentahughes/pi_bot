package pibot

import (
	"encoding/json"
	"log"
	"time"

	"github.com/shirou/gopsutil/cpu"
	"github.com/shirou/gopsutil/host"
	"github.com/shirou/gopsutil/load"
	"github.com/shirou/gopsutil/mem"
)

// HostInfo is a collection of information about the host and it's resources
var HostInfo Info

// Info contains all host resource information
type Info struct {
	Host       *host.InfoStat         `json:"host"`
	Processors []cpu.InfoStat         `json:"processors"`
	Memory     *mem.VirtualMemoryStat `json:"memory"`
	Load       *load.AvgStat          `json:"load"`
}

// Metric represents a single instance in time of system info
type Metric struct {
	Created       time.Time
	Load          float64
	MemoryUsed    uint64
	MemoryPercent float64
}

// GetInfo will return the pre populated Info struct.
// If refresh True is sent it will refresh the cache first.
func GetInfo(refresh bool) Info {
	if refresh {
		return GetHostInfo()
	}

	return HostInfo
}

// StartHostPoller will refresh the cache for host details
func StartHostPoller() {
	ticker := time.NewTicker(time.Second * 10)
	go func() {
		GetHostInfo()
		for range ticker.C {
			GetHostInfo()
		}
	}()
}

// GetHostInfo returns a struct of host information
func GetHostInfo() Info {
	hostDetails, err := host.Info()
	if err != nil {
		log.Fatalf("Error getting host details: %s", err.Error())
	}

	memory, err := mem.VirtualMemory()
	if err != nil {
		log.Fatalf("Error getting host memory details. %s", err.Error())
	}

	cpuDetails, err := cpu.Info()
	if err != nil {
		log.Fatalf("Error getting cpu details. %s", err.Error())
	}

	// Flags is a large list of strings that is not needed. Remove them
	for i := range cpuDetails {
		cpuDetails[i].Flags = nil
	}

	loadDetails, err := load.Avg()
	if err != nil {
		log.Fatalf("Error getting system load details. %s", err.Error())
	}

	HostInfo = Info{
		Host:       hostDetails,
		Processors: cpuDetails,
		Memory:     memory,
		Load:       loadDetails,
	}

	// Update the database
	HostInfo.saveHostMetrics()

	return HostInfo
}

func (i Info) saveHostMetrics() {
	db := GetDatabaseClient()
	db.Open("metrics")
	defer db.Close()

	m := Metric{
		Created:       time.Now(),
		Load:          i.Load.Load1,
		MemoryPercent: i.Memory.UsedPercent,
		MemoryUsed:    i.Memory.Used,
	}

	encoded, err := json.Marshal(m)
	if err != nil {
		log.Fatalf("Error saving metrics. %s", err)
	}

	err = db.Put(m.Created.Format(time.RFC3339), encoded)
	if err != nil {
		log.Printf("Error saving metrics, %s", err)
	}
}

// GetHostMetricsByTime return slice of metrics based on given start and end time
func GetHostMetricsByTime(startTime interface{}, endTime interface{}) (m []Metric) {
	db := GetDatabaseClient()
	db.Open("metrics")
	defer db.Close()

	for _, v := range db.GetTimeSeriesList(startTime, endTime) {
		var metric Metric
		json.Unmarshal([]byte(v), &metric)
		m = append(m, metric)
	}

	return m
}

// GetHostMetrics return slice of metrics based on given start and end time
func GetHostMetrics(count int, direction string) (m []Metric) {
	db := GetDatabaseClient()
	db.Open("metrics")
	defer db.Close()

	for _, v := range db.GetList(count, direction) {
		var metric Metric
		json.Unmarshal([]byte(v), &metric)
		m = append(m, metric)
	}

	return m
}
