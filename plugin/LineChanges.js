.pragma library

function normalize(text) {
    return text.replace(/\r\n?|\n/g, "\n")
}

function plan(original, text, path) {
    const before = normalize(original)
    const after = normalize(text)
    if (before === after)
        return null

    const previous = before.split("\n")
    const current = after.split("\n")
    if (before.length && previous.length === current.length && before.endsWith("\n") === after.endsWith("\n")) {
        const lines = {}
        const limit = Math.min(32, Math.max(4, Math.floor(previous.length / 4)))
        let count = 0
        for (let index = 0; index < previous.length; index++) {
            if (previous[index] === current[index])
                continue
            if (++count > limit)
                return fullWrite(original, after, path)
            lines[index + 1] = current[index]
        }
        return { mode: "patch", body: { path, lines } }
    }

    return fullWrite(original, after, path)
}

function fullWrite(original, text, path) {
    const separator = /\r\n|\n|\r/.exec(original)
    const content = separator ? text.replace(/\n/g, separator[0]) : text
    return { mode: "write", body: { path, content } }
}
