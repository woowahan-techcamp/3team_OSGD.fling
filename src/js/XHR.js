class XHR {
    static request(method, requestURL, callback) {
        const xhrObj = new XMLHttpRequest();
        xhrObj.addEventListener('load', callback);
        xhrObj.open(method, requestURL);
        xhrObj.send();
    }
    static get(requestURL, callback) {
        this.request.call(this, 'GET', requestURL, callback);
    }
    static post(requestURL, callback) {
        this.request.call(this, 'POST', requestURL, callback);
    }
}