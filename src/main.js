var Fling = {};
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
    'tileViewSource': '<div class="recommend_content_wrap"><ul class="recommend_content_list"> {{#each this}}<li> <a href="./recipe_page.html?query_url={{url}}"><div class="recommend_content_list_node" style="background-image: url({{image}})"><div class="recommend_number"><p>{{inc @index}}</p></div></div> </a><dt><a href="./recipe_page.html?query_url={{url}}">{{subtitle}}</a></dt><dd>{{title}} | {{writer}}</dd></li> {{/each}}</ul></div>',
    'sectionSource': '<section class="main_section content {{id}}" id="{{id}}"><div class="section_title">{{title}}</div>{{{view.render}}}</section>'
}
Fling.View = class {
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
Fling.TileView = class extends Fling.View {
    constructor(params) {
        super();
        this.data = params;
        console.info(this.data);
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
Fling.SlideView = class extends Fling.View {
    constructor() {
        super(params);
    }
}
Fling.Section = class {
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

document.addEventListener("DOMContentLoaded", e => {
    Fling.API.get(Fling.data.apiRecipes, data => {
        var rankSection = new Fling.Section({
            title: '플링 인기 차트1234',
            id: 'recommended'
        }, new Fling.TileView(data));

        document.querySelector('fling-main-recipe').innerHTML = rankSection.render;
    });

    XHR.get(Fling.data.apiSeason, (e) => {
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

