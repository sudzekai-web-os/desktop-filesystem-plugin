import linctrl
import "../FilesystemApi.js" as Api

PluginRequest {
    function inspect(action, path, completed) {
        return send("GET", Api.query("files", action, path), {}, completed)
    }

    function changePath(action, body, completed) {
        return send(action === "delete" ? "DELETE" : "POST",
            Api.route("files", action === "delete" ? "" : action), body, completed)
    }

    function saveText(action, body, completed) {
        const method = action === "create" ? "POST" : action === "patch" ? "PATCH" : "PUT"
        return send(method, Api.route("files", action === "create" ? "" : "content"), body, completed)
    }
}
