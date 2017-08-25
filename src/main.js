function mainEventHandler() {
    Fling.API.get(Fling.Data.apiRecipes, data => {
        let rankSection = new Fling.Section({
            title: '플링 <em>인기 차트</em>',
            id: 'recommended'
        }, new Fling.View.TileView(data));

        document.querySelector('fling-main-recipe').innerHTML = rankSection.render;
    });

    Fling.API.get(Fling.Data.apiSeason, data => {
        let seasonSection = new Fling.Section({
            title: '여름엔 <em>플링</em>',
            id: 'season_event'
        }, new Fling.View.SlideView(data));

        let targetSource = document.querySelector('fling-season-recipe');
        targetSource.innerHTML = seasonSection.render;
        targetSource.addEventListener('click', evt => {
            const firstElementChild = targetSource.querySelector(".list_wrap").firstElementChild;
            let slide_num = firstElementChild.style.getPropertyValue('--slide-number') * 1;
            firstElementChild.style.setProperty('transition', '1s');

            switch(evt.target.className) {
                case 'slide_arrow prev': {
                    if (slide_num !== 0)
                        firstElementChild.style.setProperty('--slide-number', --slide_num);
                    break;
                }
                case 'slide_arrow next': {
                    if (slide_num + 1 < ((window.innerWidth > 1100) ? 3 : 9))
                        firstElementChild.style.setProperty('--slide-number', ++slide_num);
                    break;
                }
            }
        });
    });

    let elementArray = document.querySelectorAll('.main_header_img');
    new FadeInOutManager(elementArray, 6000);
    
    const target = document.querySelector(".search_text");
    target.addEventListener("keyup", searchHandler);
}

class FadeInOutManager {
    constructor(elementArray, delayTime) {
        this.sequence = 0;
        this.elementArray = elementArray;
        this.delayTime = delayTime;

        setInterval(() => {
            this.fade(this.elementArray, ++this.sequence % elementArray.length);
        }, this.delayTime);
    }

    fade(elementArray, sequence) {
        elementArray.forEach((el, i) => {
            el.style.opacity = 0;
        });

        let nextSequence = (sequence + 1) % elementArray.length;
        elementArray[nextSequence].style.opacity = '1';
    }
}

function searchHandler(e) {
    const searchQuery = e.target.value;
    const searchBar = document.querySelector(".search_bar");
    
    
    
    if(searchQuery == "" || e.code == "Escape") {
        document.querySelector(".search_bar").style.display = "none";
        searchBar.innerHTML = "";
        return;
    }

    XHR.post(`http://52.79.119.41/search_recipe?keyword=${searchQuery}`, (e) => {
        let searchData = JSON.parse(e.target.responseText);
        document.querySelector(".search_bar").style.display = "block";  

        const theTemplateScript = document.querySelector("#search_item_template").innerHTML;
        const theTemplate = Handlebars.compile(theTemplateScript);
        const theCompiledHtml = theTemplate(searchData);
        searchBar.innerHTML = theCompiledHtml;
               
    });
} 

document.addEventListener("DOMContentLoaded", mainEventHandler);