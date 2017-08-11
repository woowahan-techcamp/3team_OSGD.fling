import fillContentRecommendSection from './lib/main_fill_contents.js';
import fadeInOutMain from './lib/main_header_fade_inout.js';
import _ from './lib/util.js';

document.addEventListener("DOMContentLoaded", (e) => {
    _.ajaxFunc("http://52.78.41.124/recipes", fillContentRecommendSection, ".recommend_content_list");
    const interval = window.setInterval(fadeInOutMain.bind(this,".main_header_fade_in", ".main_header_fade_out"),7000);

})




document.querySelector(".slide_arrow.prev").addEventListener("click", (e) => {
    const a = document.querySelector(".list_wrap");
    a.style.transition = "1s";
    a.style.transform = "translateX(990px)";
    
    //맨 뒤 떼서 앞에 붙이고 제자리
    a.addEventListener("transitionend", avs, false);

    function avs() {
        a.removeEventListener("transitionend", avs);
        const lastNode = a.children[2].cloneNode(true);
        a.removeChild(a.children[2]);
        a.insertBefore(lastNode, a.children[0]);
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
        const firstNode = a.children[0].cloneNode(true);
        a.removeChild(a.children[0]);
        a.insertBefore(firstNode, a.children[2]);
        a.style.transition = "none";
        a.style.transform = "translateX(0px)";
        a.removeEventListener("transitionend", avs);
    }

})

