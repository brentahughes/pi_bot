package host

import (
	"log"
	"time"

	"github.com/shirou/gopsutil/cpu"
	botHost "github.com/shirou/gopsutil/host"
	"github.com/shirou/gopsutil/load"
	"github.com/shirou/gopsutil/mem"
)

// HostInfo is a collection of information about the host and it's resources
var HostInfo Info

// Info contains all host resource information
type Info struct {
	Host       *botHost.InfoStat      `json:"host"`
	Processors []cpu.InfoStat         `json:"processors"`
	Memory     *mem.VirtualMemoryStat `json:"memory"`
	Load       *load.AvgStat          `json:"load"`
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
	hostDetails, err := botHost.Info()
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

	return HostInfo
}
