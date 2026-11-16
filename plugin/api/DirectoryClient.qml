import linctrl
import "../FilesystemApi.js" as Api

PluginRequest {
    function list(path, completed) {
        return send("GET", Api.query("directories", "directories", path), {}, completed)
    }

    function listFiles(path, completed) {
        return send("GET", Api.query("directories", "files", path), {}, completed)
    }

    function inspect(action, path, completed) {
        return send("GET", Api.query("directories", action, path), {}, completed)
    }

    function change(action, body, completed) {
        const target = Api.route("directories", action === "copy" || action === "move" ? action : "")
        return send(action === "delete" ? "DELETE" : "POST", target, body, completed)
    }
}
