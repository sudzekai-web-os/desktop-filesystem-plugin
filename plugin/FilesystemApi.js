.pragma library

function route(resource, action) {
    return "/filesystem/" + resource + (action ? "/" + action : "")
}

function query(resource, action, path) {
    return route(resource, action) + "?path=" + encodeURIComponent(path)
}
