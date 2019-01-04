package main

import (
    "context"
    "fmt"
    "time"
    "github.com/docker/docker/api/types"
    "github.com/docker/docker/client"
)

func main() {
    // Make will patch the version    
    fmt.Println("container_age for API v%VERSION%")
    ctx := context.Background()
    cli, err := client.NewClientWithOpts(client.WithVersion("%VERSION%"))
    errCheck(err)
    containers, err := cli.ContainerList(ctx, types.ContainerListOptions{})
    errCheck(err)
    init := true
    for _, container := range containers {
        info, err := cli.ContainerInspect(ctx, container.ID)
        errCheck(err)
        startd, err := time.Parse(time.RFC3339, info.State.StartedAt)
        errCheck(err)
        dur := time.Since(startd)
        if init {
            fmt.Println("DURATION ID         NAME")
            init = false
        }
        fmt.Printf("%.0fh\t %s %s\n", dur.Hours(), info.ID[:10], info.Name)
    }
}

func errCheck(e error) {
    if e != nil {
        panic(e)
    }
}
