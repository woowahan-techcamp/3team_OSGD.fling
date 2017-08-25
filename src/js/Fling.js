const Fling = {};
Fling.Data = {
    apiBaseURL: 'http://52.79.119.41/',
    get apiRecipes() {
        return Fling.Data.apiBaseURL + 'recipes';
    },
    get apiSearchRecipes() {
        return Fling.Data.apiBaseURL + 'search_recipe';
    },
    get apiSeason() {
        return Fling.Data.apiBaseURL + 'season';
    },
    get apiProducts() {
        return Fling.Data.apiBaseURL + 'products';
    },
    get apiGetProducts() {
        return Fling.Data.apiBaseURL + 'get_products';
    },
    get apiSearchProducts() {
        return Fling.Data.apiBaseURL + 'search_product';
    }
}
Fling.Storage = {};

Fling.API = {
    request: function(method, url, params, callback) {
        // params를 생략 가능하게 함
        if (typeof params === 'function' && typeof callback === 'undefined') {
            callback = params;
            params = '';
        }


        const xhrObj = new XMLHttpRequest();
        xhrObj.addEventListener('load', (e) => {
            let data = null;
            try {
                data = JSON.parse(e.target.responseText);
            }
            catch(e) {
                throw 'FLING_API_NOT_SEEMS_JSON';
            }
            callback(data);
        });
        if (params.length > 0) {
            url = url + ((params[0] !== '/') ? '?' : '') + params;
        }
        xhrObj.open(method, url);
        xhrObj.send();
    },
    get: function(url, params, callback) {
        return this.request('get', url, params, callback);
    },
    post: function(url, params, callback) {
        return this.request('post', url, params, callback);
    }
}

Fling.Template = {
    tileViewSource: '<div class="recommend_content_wrap"><ul class="recommend_content_list"> {{#each this}}<li> <a href="./recipe_page.html?query_url={{url}}"><div class="recommend_content_list_node" style="background-image: url({{image}})"><div class="recommend_number"><p>{{inc @index}}</p></div></div> </a><dt><a href="./recipe_page.html?query_url={{url}}">{{subtitle}}</a></dt><dd>{{title}} | {{writer}}</dd></li> {{/each}}</ul></div>',
    slideViewSource: '<div class="recommend_content_wrap"><div class="slide_arrow prev"></div><div class="slide_arrow next"></div><div class="list_wrap"><ul class="recommend_content_list" style="--slide-number: 1"> {{#each this}}<li> <a href="./recipe_page.html?query_url={{url}}"><div class="recommend_content_list_node" style="background-image: url({{image}})"></div> </a><dt><a href="./recipe_page.html?query_url={{url}}">{{subtitle}}</a></dt><dd>{{title}} | {{writer}}</dd></li>{{/each}}</ul></div>',
    sectionSource: '<section class="main_section content {{id}}" id="{{id}}"><div class="section_title">{{{title}}}<div class="separate"></div></div>{{{view.render}}}</section>',
    mainSearchBarSource: '{{#each this}}<div class="search_bar_list"><div class="search_bar_img" style="background-image: url({{image}})"></div><div class="product_info"><div>{{{subtitle}}}</div> <span>{{{title}}}</span></div> <button class="search_bar_button" onclick="location.href=\'recipe_page.html?query_url={{url}}\'">장보기</button></div> {{/each}}',
    recipePageSearchBarSource: '{{#each this}}<div class="search_bar_list"><div class="search_bar_img" style="background-image: url({{image}})"></div><div class="product_info"><div>{{{name}}}</div> {{#if weight}}<span>{{weight}}당</span>{{/if}} <span>{{price}}원</span></div> <button class="search_bar_button" value="{{id}}">물품추가</button></div> {{/each}}'
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
        let template = Handlebars.compile(Fling.Template.tileViewSource);
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
        let template = Handlebars.compile(Fling.Template.slideViewSource);
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
        let template = Handlebars.compile(Fling.Template.sectionSource);
        return template(this);
    }
}
Fling.EventHandler = {
    
};
