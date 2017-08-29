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
Fling.Storage = {
    get userCart() {
        const userCart = JSON.parse(window.localStorage.getItem('userCart'));
        if (userCart == null)
            throw 'Usercart localstorage is empty';
        else 
            return userCart;
    },
    get userCartSession() {
        const userCartS = JSON.parse(window.sessionStorage.getItem('userCart'));
        if (userCartS == null)
            throw 'Usercart sessionstorage is empty';
        else 
            return userCartS;
    },
    get myRefrige() {
        const myRefrige = JSON.parse(window.localStorage.getItem('myRefrige'));
        if (myRefrige == null)
            throw 'Myrefrige localstorage is empty';
        else 
            return myRefrige;
    },
    addUserCart: function(item) {
        let userCart =  JSON.parse(window.localStorage.getItem('userCart'));
        if (typeof item != 'object')
            throw 'Argument should be object.';
        if (userCart == null) {
            userCart =[];
            userCart.push(item);
        }
        else {
            userCart.push(item);
        }
        window.localStorage.setItem('userCart', JSON.stringify(userCart));
    },
    removeUserCart: function(index) {
        let userCart = JSON.parse(window.localStorage.getItem('userCart'));
        userCart.splice(index, 1);
        window.localStorage.setItem("userCart", JSON.stringify(userCart));
    },
    addUserCartSession: function(item) {
        let userCartS =  JSON.parse(window.sessionStorage.getItem('userCart'));
        if (typeof item != 'object')
            throw 'Argument should be object.';
        if (userCartS == null) {
            userCartS =[];
            userCartS.push(item);
        }
        else {
            userCartS.push(item);
        }
        window.sessionStorage.setItem('userCart', JSON.stringify(userCartS));
    },
    removeUserCartSession: function(index) {
        let userCartS = JSON.parse(window.sessionStorage.getItem('userCart'));
        userCartS.splice(index, 1);
        window.sessionStorage.setItem("userCart", JSON.stringify(userCartS));
    },
    addMyRefrige: function(item) {
        let myRefrige =  JSON.parse(window.localStorage.getItem('myRefrige'));
        if (typeof item != 'object')
            throw 'Argument should be object.';
        if (myRefrige == null) {
            myRefrige =[];
            myRefrige.push(item);
        }
        else {
            myRefrige.push(item);
        }
        window.localStorage.setItem('myRefrige', JSON.stringify(myRefrige));
    },
    removeMyRefrige: function(index) {
        let myRefrige = JSON.parse(window.localStorage.getItem('myRefrige'))
        myRefrige.splice(index, 1);
        window.localStorage.setItem("myRefrige", JSON.stringify(myRefrige));
    },
    get clear() {
        window.localStorage.clear();
    }
};


Fling.API = {
    request: function(method, url, params, callback) {
        // params를 생략 가능하게 함
        if (typeof params === 'function' && typeof callback === 'undefined')
            callback = params, params = '';

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
        console.error('Will be DEPRECATE Fling.API.request method');
    },
    request2: async function(method, url, data = {}) {
        var myHeaders = new Headers();
        var myInit = {
            method: method,
            headers: myHeaders,
            mode: 'cors',
            cache: 'default',
        };
        if (method == 'post')
            myInit.body = data;
        
        if (data.length > 0) {
            url = url + ((data[0] !== '/') ? '?' : '') + data;
        }
        var myRequest = new Request(url, myInit);
        let response = await fetch(myRequest);
        let resData = await response.text() || {};
        try {
            result = JSON.parse(resData);
        }
        catch(e) {
            throw 'FLING_API_NOT_SEEMS_JSON';
        }
        return result;
    },
    get: function(url, params, callback) {
        return this.request('get', url, params, callback);
    },
    post: function(url, params, callback) {
        return this.request('post', url, params, callback);
    },
    get2: function(url, data) {
        return this.request2('get', url, data);
    },
    post2: function(url, data) {
        return this.request2('post', url, data);
    },
}

Fling.Template = {
    tileViewSource: '<section class="main_section content {{id}}" id="{{id}}"><div class="section_title">{{{title}}}<div class="separate"></div></div><div class="recommend_content_wrap"><ul class="recommend_content_list"> {{#each this}}<li> <a href="./recipe_page.html?query_url={{url}}"><div class="recommend_content_list_node" style="background-image: url({{image}})"><div class="recommend_number"><p>{{inc @index}}</p></div></div> </a><dt><a href="./recipe_page.html?query_url={{url}}">{{subtitle}}</a></dt><dd>{{title}} | {{writer}}</dd></li> {{/each}}</ul></div></section>',
    slideViewSource: '<section class="main_section content {{id}}" id="{{id}}"><div class="section_title">{{{title}}}<div class="separate"></div></div><div class="recommend_content_wrap"><div class="slide_arrow prev"></div><div class="slide_arrow next"></div><div class="list_wrap"><ul class="recommend_content_list" style="--slide-number: 1"> {{#each this}}<li> <a href="./recipe_page.html?query_url={{url}}"><div class="recommend_content_list_node" style="background-image: url({{image}})"></div> </a><dt><a href="./recipe_page.html?query_url={{url}}">{{subtitle}}</a></dt><dd>{{title}} | {{writer}}</dd></li>{{/each}}</ul></div></section>',
    sectionSource: '<section class="main_section content {{id}}" id="{{id}}"><div class="section_title">{{{title}}}<div class="separate"></div></div>{{{view.render}}}</section>',
    cartListSource: '<div class="title">\'<span class="title_main">{{title}}</span>\' 레시피 재료 담기</div><div class="subtitle"> <div>상품</div><div>수량</div><div>가격</div></div><div class="cart_template">{{#each this}}<div class="cart_list" data-id="{{id}}" value="{{material_id}}"> <div class="left"> <input type="checkbox" class="recipe_checkbox" id="check1" checked> <label for="check1"></label> <div class="product_img" style="background-image: url({{image}})"></div><div class="product_info"> <div class="name">{{name}}</div><div class="origin">국내산</div></div></div><div class="right"> <div class="volume_box"> <input id="volume" type="text" value="1" maxlength="3" onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g,"");"> <div class="button"> <button class="up_button"></button> <button class="down_button"></button> </div></div><div class="price_info"> <div class="total_price">{{price}}원</div>{{#if weight}}<div class="per_price">{{weight}}당{{price}}원</div>{{/if}}<input type="hidden" id="per_price" value="{{price}}"> </div></div></div>{{/each}}</div>',
    cartListSoloSource: '<div class="cart_list added" data-id="{{id}}"><div class="left"> <input type="checkbox" class="recipe_checkbox" id="check1" checked> <label for="check1"></label><div class="product_img" style="background-image: url({{image}})"></div><div class="product_info"><div class="name">{{name}}</div><div class="origin">국내산</div></div></div><div class="right"><div class="volume_box"> <input id="volume" type="text" value="1" maxlength="3" onkeyup="this.value=this.value.replace(/[ㄱ-ㅎㅏ-ㅣ가-힣]/g,"");"><div class="button"> <button class="up_button"></button> <button class="down_button"></button></div></div><div class="price_info"><div class="total_price">{{price}}원</div> {{#if weight}}<div class="per_price">{{weight}}당 {{price}}원</div>{{/if}} <input type="hidden" id="per_price" value="{{price}}"></div></div></div>',
    mainSearchBarSource: '{{#each this}}<div class="search_bar_list"><div class="search_bar_img" style="background-image: url({{image}})"></div><div class="product_info"><div>{{{_subtitle}}}</div> <span>{{{_title}}}</span></div> <button class="search_bar_button" onclick="location.href=\'recipe_page.html?query_url={{url}}\'">장보기</button></div> {{/each}}',
    recipePageSearchBarSource: '{{#each this}}<div class="search_bar_list" value="{{id}}"><div class="search_bar_img" style="background-image: url({{image}})"></div><div class="product_info"><div>{{{_name}}}</div> {{#if weight}}<span>{{weight}}당</span>{{/if}} <span>{{price}}원</span></div> <button class="search_bar_button" value="{{id}}">물품추가</button></div> {{/each}}',
    recipePageRecipeDetailSource : '<div class="recipe_detail" data-id={{id}}> <div class="circle_wrap"> <div class="circle_img"style="background-image: url({{image}})"></div></div><div class="description"> <div class="title">{{title}}</div><div class="subtitle">{{subtitle}}</div><div class="detail_link"><a href="{{url}}" target="_blank">레시피 자세히 보기</a></div></div></div>',
    missedMaterialSource : '<div class="missed_material"> <div class="title">이 재료는 플링에 없네요...</div><div class="notation">※ 아래 재료는 배송이 불가능합니다.</div><div class="subtitle">{{missed_material}}</div></div>'
}

Fling.$ = function(target) {
    return document.querySelector(target);
}

Fling.$$ = function(target) {
    return document.querySelectorAll(target);
}

Fling.View = class View {
    constructor() {
        let params = arguments[0][0];
        let target = arguments[0][1];
        
        this.target = target;
        this.data = params.data || {};
        this.data.title = params.title || this.data.title;
        this.data.id = params.id || this.data.id;
        this.template = params.template;
        this.target.innerHTML = this.render;
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
    constructor(params, target) {
        super(arguments);
    }
    get render() {
        let data = this.data.slice(0, 3);
        data.title = this.data.title;
        data.id = this.data.id;
        Handlebars.registerHelper("inc", (value, options) => {
            return parseInt(value) + 1;
        });
        let template = Handlebars.compile(Fling.Template.tileViewSource);
        return template(data);
    }
}
Fling.View.SlideView = class SlideView extends Fling.View {
    constructor(params, target) {
        super(arguments);

        this.target.addEventListener('click', evt => {
            const firstElementChild = this.target.querySelector(".list_wrap").firstElementChild;
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
    }
    get render() {
        let data = this.data;
        let template = Handlebars.compile(Fling.Template.slideViewSource);
        return template(data);
    }
}

Fling.View.ListView = class ListView extends Fling.View {
    constructor(params, target) {
        super(arguments);
    }
    get render() {
        let data = this.data;
        let template = Handlebars.compile(Fling.Template.cartListSource);
        return template(data);
    }
}

Fling.View.CardView = class CardView extends Fling.View {
    constructor(params, target) {
        super(arguments);
    }
    get render() {
        let data = this.data;
        let template = Handlebars.compile(this.template);
        return template(data);
    }
}


Fling.onEvent = function(target, eventType, callBack) {
        document.querySelector(target).addEventListener(eventType, callBack);
}
