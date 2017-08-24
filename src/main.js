const Fling = {};
Fling.data = {
    apiBaseURL: 'http://52.79.119.41/',
    get apiRecipes() {
        return Fling.data.apiBaseURL + 'recipes'
    },
    get apiSeason() {
        return Fling.data.apiBaseURL + 'season'
    }
}

Fling.API = {
    request: function(method, url, callback) {
        XHR.request(method, url, (e) => {
            let data = null;
            try {
                data = JSON.parse(e.target.responseText);
            }
            catch(e) {
                throw 'FLING_API_NOT_SEEMS_JSON';
            }
            callback(data);
        });
    },
    get: function(url, callback) {
        return this.request('get', url, callback);
    },
    post: function(url, callback) {
        return this.request('post', url, callback);
    }
}

Fling.template = {
    tileViewSource: '<div class="recommend_content_wrap"><ul class="recommend_content_list"> {{#each this}}<li> <a href="./recipe_page.html?query_url={{url}}"><div class="recommend_content_list_node" style="background-image: url({{image}})"><div class="recommend_number"><p>{{inc @index}}</p></div></div> </a><dt><a href="./recipe_page.html?query_url={{url}}">{{subtitle}}</a></dt><dd>{{title}} | {{writer}}</dd></li> {{/each}}</ul></div>',
    slideViewSource: '<div class="recommend_content_wrap"><div class="slide_arrow prev"></div><div class="slide_arrow next"></div><div class="list_wrap"><ul class="recommend_content_list" style="--slide-number: 1"> {{#each this}}<li> <a href="./recipe_page.html?query_url={{url}}"><div class="recommend_content_list_node" style="background-image: url({{image}})"></div> </a><dt><a href="./recipe_page.html?query_url={{url}}">{{subtitle}}</a></dt><dd>{{title}} | {{writer}}</dd></li>{{/each}}</ul></div>',
    sectionSource: '<section class="main_section content {{id}}" id="{{id}}"><div class="section_title">{{{title}}}<div class="separate"></div></div>{{{view.render}}}</section>',
}
Fling.View = class View {
    constructor() {
        this.dataObject = null;
    }
    get data() {
        return this.dataObject;
    }
    set data(obj) {
        this.dataObject = obj;
        return;
    }
    get render() {
        return '';
    }
}
Fling.View.TileView = class TileView extends Fling.View {
    constructor(params) {
        super();
        this.data = params;
    }
    get render() {
        let data = this.data.slice(0, 3);
        Handlebars.registerHelper("inc", (value, options) => {
            return parseInt(value) + 1;
        });
        let template = Handlebars.compile(Fling.template.tileViewSource);
        return template(data);
    }
}
Fling.View.SlideView = class SlideView extends Fling.View {
    constructor(params) {
        super();
        this.data = params;
    }
    get render() {
        let data = this.data;
        let template = Handlebars.compile(Fling.template.slideViewSource);
        return template(data);
    }
}
Fling.Section = class Section {
    constructor(params, viewObject) {
        this.title = params.title;
        this.id = params.id;
        this.view = viewObject;
    }

    get render() {
        let template = Handlebars.compile(Fling.template.sectionSource);
        return template(this);
    }
}

Fling.Main = function() {
    Fling.API.get(Fling.data.apiRecipes, data => {
        let rankSection = new Fling.Section({
            title: '플링 <em>인기 차트</em>',
            id: 'recommended'
        }, new Fling.View.TileView(data));

        document.querySelector('fling-main-recipe').innerHTML = rankSection.render;
    });

    Fling.API.get(Fling.data.apiSeason, data => {
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
    new Fling.Main.FadeInOutManager(elementArray, 6000);
    
    const target = document.querySelector(".search_text");
    target.addEventListener("keyup", searchHandler);
}

Fling.Main.FadeInOutManager = class FadeInOutManager {
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



document.addEventListener("DOMContentLoaded", Fling.Main);