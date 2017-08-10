document.addEventListener("DOMContentLoaded", (e) => {
    
})


const _ = {
    ajaxFunc : function ajax(url) {
    const oReq = new XMLHttpRequest(); 
        oReq.addEventListener("load", (e) => {
            const data = JSON.parse(oReq.responseText);
            exeFunc();
        }); 
        oReq.open("GET", url); 
        oReq.send();
    }
}



