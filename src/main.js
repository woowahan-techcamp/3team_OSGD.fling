document.addEventListener("DOMContentLoaded", (e) => {
    _.ajaxFunc("http://52.79.119.41/recipes", fillContentRecommendSection, ".recommend_content_list");
    _.ajaxFunc("http://52.79.119.41/season", fillContentRecommendSection, ".main_section.season_event .recommend_content_list");
    const interval = window.setInterval(fadeInOutMain.bind(this,".main_header_fade_in", ".main_header_fade_out", ".main_header_fade_middle"),6000);

    setTimeout(() => {
        document.querySelector('.search_body').style="transition: 1s;transform:translateY(10px);";
        document.querySelector('.search_desc').style="transition: 2s;transition-delay: .5s;transform:translateY(20px);";
    }, 500);
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
function fadeInOutMain(selector1, selector2, selector3) {
    const fadeIn = document.querySelector(selector1);
    const fadeOut = document.querySelector(selector2);
    const fadeMid = document.querySelector(selector3);
    
    if (fadeIn.style.opacity == "1") {
        fadeIn.style.opacity = "0";
        fadeOut.style.opacity = "1";
        fadeMid.style.opacity = "0";
    }
    else if (fadeOut.style.opacity == "1") {
        fadeIn.style.opacity = "0";
        fadeOut.style.opacity = "0";
        fadeMid.style.opacity = "1";
    }
    else {
        fadeIn.style.opacity = "1";
        fadeOut.style.opacity = "0";
        fadeMid.style.opacity = "0";
    }
}



////////////////////////////////////////////////////////////////////////////////////////
function fillContentRecommendSection(data, selector) {
    const li =document.querySelector(selector).children;

    const liArr = Array.from(li);
    let i = 0;
    
    liArr.forEach((e) => {
        e.children[0].href = `./recipe_page.html?query_url=${data[i].url}`;
        e.children[0].children[0].style.backgroundImage = "url('" + data[i].image  + "')";

        e.children[1].children[0].href = `./recipe_page.html?query_url=${data[i].url}`;
        e.children[1].children[0].innerHTML = data[i].subtitle;
        e.children[2].innerHTML = data[i].title + "  |  " + data[i].writer;
        
        i++;
    })
}


/////////////////////////////////////////////////////////////////////////////화살표//////////

document.querySelector(".slide_arrow.prev").addEventListener("click", (e) => {
    const a = document.querySelector(".list_wrap").firstElementChild;
    let slide_num = a.style.getPropertyValue('--slide-number') * 1;
    a.style.setProperty('transition', '1s');
    if (slide_num !== 0)
        a.style.setProperty('--slide-number', --slide_num);
    
    // //맨 뒤 떼서 앞에 붙이고 제자리
    // a.addEventListener("transitionend", avs, false);

    // function avs() {
    //     a.removeEventListener("transitionend", avs);
    //     console.log(a);
    //     //const lastNode = a.children[2].cloneNode(true);
    //     //a.removeChild(a.children[2]);
    //     //a.insertBefore(lastNode, a.children[0]);

    //     a.removeEventListener("transitionend", avs);
    //     if (slide_num == 0) {
    //         a.style.setProperty('transition', 'none');
    //         let li_arr = Array.from(a.querySelectorAll('li'));
    //         let sli_lst = li_arr.slice(0, 3);
            
    //         for (let i = 2; i >= 0; i--) {
    //             a.removeChild(sli_lst[i]);
    //             a.appendChild(sli_lst[i]);
    //         }

    //         a.style.setProperty('--slide-number', ++slide_num);
    //     }
        
    // }
    
})


document.querySelector(".slide_arrow.next").addEventListener("click", (e) => {
    const a = document.querySelector(".list_wrap").firstElementChild;
    let slide_num = a.style.getPropertyValue('--slide-number') * 1;
    a.style.setProperty('transition', '1s');
    let slide_count;
    if (window.innerWidth > 1100) {
        slide_count = 3;
    }
    else {
        slide_count = 9;
    }
    if (slide_num + 1 < slide_count)
        a.style.setProperty('--slide-number', ++slide_num);
    // a.addEventListener("transitionend", avs, false);

    // function avs() {
    //     a.style.removeProperty('transition');
    //     a.removeEventListener("transitionend", avs);
    //     if (slide_num == 2) {
    //         a.style.setProperty('transition', 'none');
    //         let li_arr = Array.from(a.querySelectorAll('li'));
    //         let firstNode = li_arr[0].cloneNode(true);
    //         let sli_lst = li_arr.slice(0,3);
            
    //         for (let item of sli_lst) {
    //             a.removeChild(item);
    //             console.info(li_arr[0]);
    //             a.insertBefore(item, a.querySelectorAll('li').lastNode);
    //         }
    //         a.style.setProperty('--slide-number', --slide_num);
    //     }
        

    //     return;
    //     //const firstNode = a.children[0].cloneNode(true);
    //     a.removeChild(a.children[0]);
    //     a.insertBefore(firstNode, a.children[2]);
    //     a.style.transition = "none";
    //     a.style.transform = "translateX(0px)";
    //     a.removeEventListener("transitionend", avs);
    // }

})

