document.addEventListener("DOMContentLoaded", (e) => {
    _.ajaxFunc("http://52.78.41.124/recipes", fillContentRecommendSection, ".recommend_content_list");
    const interval = window.setInterval(fadeInOutMain.bind(this,".main_header_fade_in", ".main_header_fade_out"),7000);

})




///////////////////////////////////////////// util
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


//////////////////////////////////////////////////
function fadeInOutMain(selector1, selector2) {
    const fadeIn = document.querySelector(selector1);
    const fadeOut = document.querySelector(selector2);
    
    if (fadeIn.style.opacity == "1") {
        fadeIn.style.opacity = "0";
        fadeOut.style.opacity = "1";
    }
    else {
        fadeIn.style.opacity = "1";
        fadeOut.style.opacity = "0";
    }
}



////////////////////////////////////////////////////////////////////////////////////////
function fillContentRecommendSection(data, selector) {
    const li =document.querySelector(selector).children;

    const liArr = Array.from(li);
    let i = 0;
    
    liArr.forEach((e) => {
        e.children[0].href = data[i].url;
        e.children[0].children[0].style.backgroundImage = "url('" + data[i].image  + "')";

        e.children[1].children[0].href = data[i].url;
        e.children[1].children[0].innerHTML = data[i].subtitle;
        e.children[2].innerHTML = data[i].title + "  |  " + data[i].writer;
        
        i++;
    })
}




/////////////////////////////////////////////////////////////////////////////화살표//////////

document.querySelector(".slide_arrow.prev").addEventListener("click", (e) => {
    const a = document.querySelector(".list_wrap").firstElementChild;
    let slide_num = a.style.getPropertyValue('--slide-number') * 1;
    a.style.setProperty('--slide-number', --slide_num);
    
    //맨 뒤 떼서 앞에 붙이고 제자리
    a.addEventListener("transitionend", avs, false);

    function avs() {
        a.removeEventListener("transitionend", avs);
        console.log(a);
        //const lastNode = a.children[2].cloneNode(true);
        //a.removeChild(a.children[2]);
        //a.insertBefore(lastNode, a.children[0]);
    }
    
})


document.querySelector(".slide_arrow.next").addEventListener("click", (e) => {
    const a = document.querySelector(".list_wrap").firstElementChild;
    let slide_num = a.style.getPropertyValue('--slide-number') * 1;
    a.style.setProperty('--slide-number', ++slide_num);
    a.addEventListener("transitionend", avs, false);

    function avs() {
        a.removeEventListener("transitionend", avs);
        let slide_list = Array.from(a.querySelectorAll('li'));
        console.info(slide_list.slice(0, 3));
        return;
        const firstNode = a.children[0].cloneNode(true);
        a.removeChild(a.children[0]);
        a.insertBefore(firstNode, a.children[2]);
        a.style.transition = "none";
        a.style.transform = "translateX(0px)";
        a.removeEventListener("transitionend", avs);
    }

})

