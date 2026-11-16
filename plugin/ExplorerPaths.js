.pragma library

function root() {
    return "root:\\"
}

function normalize(path) {
    if (typeof path !== "string" || !/^root:\\/i.test(path))
        return ""

    const segments = path.slice(root().length).split(/[\\/]+/).filter(segment => segment !== "")
    if (segments.some(segment => segment === "." || segment === ".."))
        return ""

    return root() + segments.join("\\")
}

function parent(path) {
    const separator = path.lastIndexOf("\\")
    return separator < root().length ? root() : path.slice(0, separator)
}

function child(path, name) {
    const directory = normalize(path)
    if (!directory || !name || /[\\/]/.test(name) || name === "." || name === "..")
        return ""
    return directory + (directory === root() ? "" : "\\") + name
}
