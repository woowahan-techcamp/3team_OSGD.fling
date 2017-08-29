window.Fling = window.Fling || {};
window.Fling.RecipePage = {
    async EventHandler() {
        let url = Fling.Utils.getParameterByName('query_url');
        let jsonData;
        try {
            jsonData = await Fling.API.post2(Fling.Data.apiRecipes, `url=${url}`);
        }
        catch(e) {
            window.location.replace("./no_page.html");
        }

        let recipeDesc = new Fling.View.CardView({
            data: jsonData,
            template: Fling.Template.recipePageRecipeDetailSource
        }, Fling.$('fling-recipe-desc'));

        let missedMaterial = new Fling.View.CardView({
            data: jsonData,
            template: Fling.Template.missedMaterialSource
        }, Fling.$('fling-missed-material'));

        let productListView = new Fling.View.ListView({
            data: await Fling.API.get2(Fling.Data.apiGetProducts, `/${jsonData.id}`),
            title: jsonData.title
        }, Fling.$('.recipe_cart'));
        
        Fling.RecipePage.uncheckMyRefrigeItem();
        Fling.RecipePage.calcTotalPrice();

        Fling.onEvent('.cart_template', 'click', Fling.RecipePage.cartListEventHandler);
        Fling.onEvent('.cart_template', 'keydown', Fling.RecipePage.volumeKeyDownHandler);
        Fling.onEvent('.cart_template', 'keyup', Fling.RecipePage.volumeKeyUpHandler);
        Fling.onEvent('.search_text', 'keyup', Fling.RecipePage.searchHandler);
        Fling.onEvent('.search_bar', 'click', Fling.RecipePage.addProductHandler);
        Fling.onEvent('.btn_cart', 'click', Fling.RecipePage.storeUserCartData);
        Fling.onEvent('.refrige_popup', 'click', Fling.onRefrigePopupHandler);
        Fling.onEvent('.search_text', 'keydown', Fling.RecipePage.searchBarUpDownHandler);

        document.body.style = '';
    },
    
    cartListEventHandler(e) {
        if (e.target.className == "up_button") {
            if (e.target.parentElement.parentElement.children[0].value < 999)
                e.target.parentElement.parentElement.children[0].value++;
        } else if (e.target.className == "down_button") {
            if (e.target.parentElement.parentElement.children[0].value > 1)
                e.target.parentElement.parentElement.children[0].value--;
        } else if (e.target.className == "recipe_checkbox") {
            let parent_element = e.target.parentElement.parentElement;
            if (!e.target.checked)
                parent_element.classList.add('unchecked');
            else
                parent_element.classList.remove('unchecked');
        } else {
            return;
        }

        let item_tp = e.target.parentElement.parentElement.parentElement.querySelector('.total_price');
        let item_volume = e.target.parentElement.parentElement.parentElement.querySelector('#volume').value;
        let item_unit_price = e.target.parentElement.parentElement.parentElement.querySelector('#per_price').value.replace(/,/g, '');

        item_tp.innerText = Fling.Utils.numberWithComma(item_volume * item_unit_price) + '원';

        Fling.RecipePage.calcTotalPrice();
    },

    volumeKeyDownHandler(e) {
        if (e.target.id == 'volume') {
            // 숫자와 특수키만 받는다
            if (e.key >= '0' && e.key <= '9' || e.keyCode < 48) {
                return;
            }
            e.preventDefault();
            e.stopPropagation();
            return false;
        }
    },

    volumeKeyUpHandler(e) {
        let item_tp = e.target.parentElement.parentElement.parentElement.querySelector('.total_price');
        let item_volume = e.target.parentElement.parentElement.parentElement.querySelector('#volume').value;
        console.info(item_volume);
        let item_unit_price = e.target.parentElement.parentElement.parentElement.querySelector('#per_price').value.replace(/,/g, '');

        item_tp.innerText = Fling.Utils.numberWithComma(item_volume * item_unit_price) + '원';

        Fling.RecipePage.calcTotalPrice();
    },

    uncheckMyRefrigeItem() {
        const cartList = Array.from(Fling.$$(".cart_list"));
        let myRefrige;
        try {
            myRefrige = Fling.Storage.myRefrige;
        }
        catch(e) {
            return;
        }

        cartList.forEach((e) => {
            const materialId = e.getAttribute("value") * 1;
            
            if (myRefrige === null)
                return;
                
            for (let i = 0; i < myRefrige.length; i++) {
                if (materialId == myRefrige[i].id) {
                    e.classList.add("unchecked");
                    e.querySelector(".recipe_checkbox").checked = false;
                    break;
                }
            }
        })
    },

    calcTotalPrice() {
        const cartListsArr = document.getElementsByClassName("total_price");
        
        let sumNum = 0;
        let sum = 0;
        let i = 0;
        let len = cartListsArr.length;

        for (i=0; i < len - 1; i++) {
            let price = cartListsArr[i].innerHTML;
            price = price.replace("원", "");
            price = price.replace(/,/g, "");

            price = parseInt(price);

            if (Fling.RecipePage.isAvaliableItem(cartListsArr[i])) {
                sum += price;
            }
        }
        
        sumNum = sum;
        sum = Fling.Utils.numberWithComma(sum);
        cartListsArr[len-1].children[0].innerHTML = sum;

        const subPrice = Fling.$(".pi_prd");
        subPrice.innerHTML = sum;

        const flingCash = Fling.$(".pi_point");        
        flingCash.innerHTML = Fling.Utils.numberWithComma(parseInt(sumNum * 0.01));

    },

    isAvaliableItem(el) {
        return el.parentElement.parentElement.parentElement.querySelector('#check1').checked;
    },

    async searchHandler(e) {
        const searchQuery = e.target.value;
        const searchBar = Fling.$(".search_bar");
        const selected = Fling.$('.selected');
        let productInfo = [];

        if(searchQuery == "" || e.code == "Escape") {
            Fling.$(".search_bar").style.display = "none";
            searchBar.innerHTML = "";
            return;
        }
        else if (e.code == 'ArrowLeft' || e.code == 'ArrowRight') {
            return;
        }
        else if(e.code == 'ArrowUp') {
            return; 
        }
        else if (e.code == 'ArrowDown') {
            return;
        } 
        else if (e.code == 'Enter') {
            Fling.RecipePage.addProductHandler(e);
        }
        else {
            let searchData = await Fling.API.post2(Fling.Data.apiSearchProducts, `keyword=${searchQuery}`);
            Fling.$(".search_bar").style.display = "block";  
            searchData.forEach(async (e) => {
                let data = await Fling.API.get2(Fling.Data.apiProducts, `/${e.id}`);
                // productInfo 갯수 제한. 50개까지만 상품을 찾는다
                if (productInfo.length < 50) {
                    productInfo.push(data);
                    const theTemplate = Handlebars.compile(Fling.Template.recipePageSearchBarSource);
                    productInfo.forEach(item => {
                        item._name = item.name.replace(new RegExp(searchQuery, 'g'), `<span class="search_word">${searchQuery}</span>`);
                    });
                    const theCompiledHtml = theTemplate(productInfo);
                    searchBar.innerHTML = theCompiledHtml;
                    if (searchBar.children[0].classList.length == 1){
                        searchBar.children[0].classList.add('selected');
                    }
                }
            })
        }
    },

    flag: true,

    searchBarUpDownHandler(e) {
        const searchBar = Fling.$(".search_bar");
        const selected = Fling.$('.selected');
        if (Fling.RecipePage.flag == false)
            return;
        window.setTimeout((e) => { Fling.RecipePage.flag = true; }, 80); 
        if(e.code == 'ArrowUp') {
            let index = Fling.RecipePage.findSelectedTab();
            if (index == 0)
                return;
            searchBar.children[index].classList.remove('selected');
            searchBar.children[index - 1].classList.add('selected');
            if (selected.offsetTop - selected.clientHeight < searchBar.scrollTop) {
                searchBar.scrollTop = selected.offsetTop - selected.clientHeight;
            } 
        }
        else if (e.code == 'ArrowDown') {
            let index = Fling.RecipePage.findSelectedTab();
            if (index == searchBar.children.length - 1) 
                return;
            searchBar.children[index].classList.remove('selected');
            searchBar.children[index + 1].classList.add('selected');
            if (selected.offsetTop >= searchBar.scrollTop + (4 * selected.clientHeight)) {
                //searchBar.scrollTop = selected.offsetTop - 400 + selected.clientHeight * 2;
                searchBar.scrollTop += selected.clientHeight + 1;
            }
        }
        Fling.RecipePage.flag = false;
    },

    findSelectedTab() {
        const selected = Fling.$('.selected');
        const searchBarArr = Fling.$$('.search_bar_list');
        let indexOfArr = -1;
        searchBarArr.forEach((value, index) => {
            if (value == selected)
                indexOfArr = index;
        })
        return indexOfArr;
    },

    async addProductHandler(e) {
        if(e.target.className == "search_bar_button") {
            let product = await Fling.API.get2(Fling.Data.apiProducts, `/${e.target.value}`);
            const theTemplate = Handlebars.compile(Fling.Template.cartListSoloSource);
            const theCompiledHtml = theTemplate(product);
            Fling.$(".cart_template").insertAdjacentHTML("beforeend", theCompiledHtml);
            Fling.$(".search_bar").style.display = "none";
            Fling.$(".search_text").value = "";
            Fling.RecipePage.calcTotalPrice();
        }
        else if (e.code == 'Enter') {
            let product = await Fling.API.get2(Fling.Data.apiProducts, `/${Fling.$('.selected').getAttribute('value')}`);
            const theTemplate = Handlebars.compile(Fling.Template.cartListSoloSource);
            const theCompiledHtml = theTemplate(product);
            Fling.$(".cart_template").insertAdjacentHTML("beforeend", theCompiledHtml);
            Fling.$(".search_bar").style.display = "none";
            Fling.$(".search_text").value = "";
            Fling.RecipePage.calcTotalPrice();
        }
    },

    storeUserCartData() {
        let cartListObj = {};
        
        cartListObj.recipeId = Fling.$(".recipe_detail").dataId;
        cartListObj.recipeTitle = Fling.$(".description > .title").innerHTML;
        cartListObj.recipeImg = Fling.$(".circle_img").style.backgroundImage;
        cartListObj.recipeSubtitle = Fling.$(".description > .subtitle").innerHTML;
        cartListObj.recipeUrl = Fling.$(".detail_link a").href;
        cartListObj.recipePrice = Fling.$(".recipe_additional_info .total_price > span").innerHTML;
        cartListObj.productApiUrl = "http://52.79.119.41/get_products?products=[";
        cartListObj.productList = [];

        let productArr = document.getElementsByClassName("cart_list");
        productArr = Array.from(productArr);

        productArr.forEach((e) => {
            let productList = {};
            productList.id = e.dataset.id * 1;
            productList.volume = e.children[1].children[0].children[0].value;
            
            if (e.className.includes("unchecked")) {
                productList.isChecked = false;
            }
            else {
                productList.isChecked = true;
            }

            if (e.className.includes("added")) {
                productList.isAdded = true;
            }
            else {
                productList.isAdded = false;
            }

            cartListObj.productApiUrl += productList.id + ",";
                
            cartListObj.productList.push(productList);
        })
        //make api url
        cartListObj.productApiUrl = cartListObj.productApiUrl.substring(0, cartListObj.productApiUrl.length - 1);
        cartListObj.productApiUrl += "]";
        
        Fling.Storage.addUserCart(cartListObj);

        //to the next page.
        window.location.href = "./cart_page.html";
    }
}