exports.init = async function (app) {
    window.addEventListener("resize", function (e) {
        app.ports.resize.send(null);
    });
}