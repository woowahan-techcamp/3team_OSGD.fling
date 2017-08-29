window.Fling = window.Fling || {};
window.Fling.NoPage = {
    EventHandler() {
        window.setTimeout((e) => {
            window.location.replace("./main.html");
        }, 1500);
    }
}