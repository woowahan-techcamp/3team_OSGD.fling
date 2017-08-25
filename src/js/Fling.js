const Fling = {};
Fling.Data = {
    apiBaseURL: 'http://52.79.119.41/',
    get apiRecipes() {
        return Fling.Data.apiBaseURL + 'recipes'
    },
    get apiSeason() {
        return Fling.Data.apiBaseURL + 'season'
    }
}
Fling.Storage = {};

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

Fling.Template = {
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
