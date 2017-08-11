document.addEventListener("DOMContentLoaded", (e) => {
    _.ajaxFunc("http://52.78.41.124/recipes", fillContentRecommendSection, ".recommend_content_list");
})




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


function fillContentRecommendSection(data, selector) {
    const li =document.querySelector(selector).children;
    
    const liArr = Array.from(li);
    let i = 0;
    
    liArr.forEach((e) => {
        e.children[0].href = data[i].url;
        e.children[0].children[0].style.backgroundImage = "url('" + data[i].image  + "')";

        e.children[1].children[0].href = data[i].url;
        ////지울것
        e.children[1].children[0].innerHTML = data[i].title;
        /*추가할것
        e.children[1].children[0].innerHTML = data[i].subtitle;
        e.children[2].innerHTML = data[i].title + "  |  " + data[i].id;
        */
        i++;
    })
}



document.querySelector(".slide_arrow.prev").addEventListener("click", (e) => {
    const a = document.querySelector(".list_wrap");
    a.style.transition = "1s";
    a.style.transform = "translateX(990px)";
    
    //맨 뒤 떼서 앞에 붙이고 제자리
    a.addEventListener("transitionend", avs, false);

    function avs() {
        a.removeEventListener("transitionend", avs);
        console.log(a);
        //const lastNode = a.children[2].cloneNode(true);
        //a.removeChild(a.children[2]);
        //a.insertBefore(lastNode, a.children[0]);
        a.style.transition = "none";
        a.style.transform = "translateX(0px)";
    }
    
})


document.querySelector(".slide_arrow.next").addEventListener("click", (e) => {
    const a = document.querySelector(".list_wrap");
    a.style.transition = "1s";
    a.style.transform = "translateX(-990px)";
    a.addEventListener("transitionend", avs, false);

    function avs() {
        a.removeEventListener("transitionend", avs);
        let slide_list = Array.from(a.querySelectorAll('li'));
        console.info(slide_list.slice(0, 3));
        a.style.transition = "none";
        a.style.transform = "translateX(0px)";
        return;
        const firstNode = a.children[0].cloneNode(true);
        a.removeChild(a.children[0]);
        a.insertBefore(firstNode, a.children[2]);
        a.style.transition = "none";
        a.style.transform = "translateX(0px)";
        a.removeEventListener("transitionend", avs);
    }

})
