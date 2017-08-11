const _ = {
    ajaxFunc : function ajax(url, exeFunc, selector) {
    const oReq = new XMLHttpRequest(); 
        oReq.addEventListener("load", (e) => {
            const data = JSON.parse(oReq.responseText);
            exeFunc(data, selector);
        }); 
        oReq.open("GET", url); 
        oReq.send();
    }
}
export default _;
