window.Fling = window.Fling || {};
window.Fling.NoPage = {
    EventHandler() {
        window.setTimeout((e) => {
            window.location.replace("./index.html");
        }, 1500);
    }
}