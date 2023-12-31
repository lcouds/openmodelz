## mdz server start

Start the server

### Synopsis

Start the server with the public IP of the machine. If not provided, the internal IP will be used automatically.

```
mdz server start [flags]
```

### Examples

```
  mdz server start
  mdz server start -v
  mdz server start 1.2.3.4
```

### Options

```
  -g, --force-gpu                          Start the server with GPU support (ignore the GPU detection)
  -h, --help                               help for start
      --mirror-endpoints https://quay.io   Mirror URL endpoints of the registry like https://quay.io
      --mirror-name string                 Mirror domain name of the registry (default "docker.io")
```

### Options inherited from parent commands

```
      --debug               Enable debug logging
      --disable-telemetry   Disable anonymous telemetry
  -u, --url string          URL to use for the server (MDZ_URL) (default http://localhost:80)
  -v, --verbose             Verbose output
```

### SEE ALSO

* [mdz server](mdz_server.md)	 - Manage the servers

###### Auto generated by spf13/cobra on 11-Aug-2023
