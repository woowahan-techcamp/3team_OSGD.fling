document.addEventListener("DOMContentLoaded", (e) => {
    XHR.get('http://52.79.119.41/recipes', (e) => {
        const data = JSON.parse(e.target.responseText);
        fillContentRecommendSection(data, ".recommend_content_list");
    });
    XHR.get('http://52.79.119.41/season', (e) => {
        const data = JSON.parse(e.target.responseText);
        fillContentRecommendSection(data, ".main_section.season_event .recommend_content_list");
    });
    
    const interval = window.setInterval(fadeInOutMain.bind(this,".main_header_fade_in", ".main_header_fade_out", ".main_header_fade_middle"),6000);

    document.querySelector(".slide_arrow.prev").addEventListener("click", (e) => {
        const a = document.querySelector(".list_wrap").firstElementChild;
        let slide_num = a.style.getPropertyValue('--slide-number') * 1;
        a.style.setProperty('transition', '1s');
        if (slide_num !== 0)
            a.style.setProperty('--slide-number', --slide_num);
        
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
       
    
    })
    
    
})


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

