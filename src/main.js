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

    document.querySelector(".refrige_popup").addEventListener("click", (e) => {
        e.target.href = 'javascript:void(0)';
        const popup = window.open("./refrige_popup.html", "refrigeWindow", "width=700,height=800,toolbar=no,menubar=no");
    })
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

    Fling.API.post(Fling.Data.apiSearchRecipes, `keyword=${searchQuery}`, (searchData) => {
        document.querySelector(".search_bar").style.display = "block";  

        const theTemplate = Handlebars.compile(Fling.Template.mainSearchBarSource);
        searchData.forEach(item => {
            item._title = item.title.replace(new RegExp(searchQuery, 'g'), `<span class="search_word">${searchQuery}</span>`);
            item._subtitle = item.subtitle.replace(new RegExp(searchQuery, 'g'), `<span class="search_word">${searchQuery}</span>`);
        });
        const theCompiledHtml = theTemplate(searchData);
        searchBar.innerHTML = theCompiledHtml;
    });
} 

document.addEventListener("DOMContentLoaded", mainEventHandler);