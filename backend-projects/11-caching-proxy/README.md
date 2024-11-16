# Caching Proxy
CLI app solution for the [caching-proxy](https://roadmap.sh/projects/caching-server) challenge on [roadmap.sh](https://roadmap.sh)

### Setup
**Clone the repo**

```
git clone https://github.com/emmaakachukwu/roadmapsh-projects.git
```

**cd into the task tracker directory**
```
cd backend-projects/11-caching-proxy
```

### How to use
**Start the server**
```
./bin/caching_proxy --port 8080 --origin https://example.com
# Proxy server started on port: 8080 and forwarding requests to server: https://example.com
```

**Goto http://127.0.0.1:8080**

**Clear cache**
```
./bin/caching_proxy --clear-cache
# Cache cleared
```

### Notes
**Helpful links**
- https://www.rubyguides.com/2016/08/build-your-own-web-server
