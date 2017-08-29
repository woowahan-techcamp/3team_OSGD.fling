document.addEventListener('DOMContentLoaded', recipePageEventHandler);

async function recipePageEventHandler() {
    let url = Utils.getParameterByName('query_url');
        
    let jsonData = await Fling.API.post2(Fling.Data.apiRecipes, `url=${url}`);

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
    
    uncheckMyRefrigeItem();
    calcTotalPrice();

    Fling.onEvent('.cart_template', 'click', cartListEventHandler);
    Fling.onEvent('.cart_template', 'keydown', volumeKeyDownHandler);
    Fling.onEvent('.cart_template', 'keyup', volumeKeyUpHandler);
    Fling.onEvent('.search_text', 'keyup', searchHandler);
    Fling.onEvent('.search_bar', 'click', addProductHandler);
    Fling.onEvent('.btn_cart', 'click', storeUserCartData);
    Fling.onEvent('.refrige_popup', 'click', refrigePopUpHandler);
}

function refrigePopUpHandler(e) {
    e.target.href = 'javascript:void(0)';
    const popup = window.open("./refrige_popup.html", "refrigeWindow", "width=700,height=800,toolbar=no,menubar=no");
}

function cartListEventHandler(e) {
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

    item_tp.innerText = Utils.numberWithComma(item_volume * item_unit_price) + '원';

    calcTotalPrice();
}

function volumeKeyDownHandler(e) {
    if (e.target.id == 'volume') {
        // 숫자와 특수키만 받는다
        if (e.key >= '0' && e.key <= '9' || e.keyCode < 48) {
            return;
        }
        e.preventDefault();
        e.stopPropagation();
        return false;
    }
}

function volumeKeyUpHandler(e) {
    let item_tp = e.target.parentElement.parentElement.parentElement.querySelector('.total_price');
    let item_volume = e.target.parentElement.parentElement.parentElement.querySelector('#volume').value;
    console.info(item_volume);
    let item_unit_price = e.target.parentElement.parentElement.parentElement.querySelector('#per_price').value.replace(/,/g, '');

    item_tp.innerText = Utils.numberWithComma(item_volume * item_unit_price) + '원';

    calcTotalPrice();
}

function uncheckMyRefrigeItem() {
    const cartList = Array.from(document.querySelectorAll(".cart_list"));
    const myRefrige = JSON.parse(window.localStorage.getItem("myRefrige"));

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
}


function calcTotalPrice() {
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

        if (isAvaliableItem(cartListsArr[i])) {
            sum += price;
        }
    }
    
    sumNum = sum;
    sum = Utils.numberWithComma(sum);
    cartListsArr[len-1].children[0].innerHTML = sum;

    const subPrice = document.querySelector(".pi_prd");
    subPrice.innerHTML = sum;

    const flingCash = document.querySelector(".pi_point");
    flingCash.innerHTML = Utils.numberWithComma(parseInt(sumNum * 0.01));
}

function isAvaliableItem(el) {
    return el.parentElement.parentElement.parentElement.querySelector('#check1').checked;
}

function searchHandler(e) {
    const searchQuery = e.target.value;
    const searchBar = document.querySelector(".search_bar");
    let productInfo = [];
    

    if(searchQuery == "" || e.code == "Escape") {
        document.querySelector(".search_bar").style.display = "none";
        searchBar.innerHTML = "";
        return;
    }

    Fling.API.post(Fling.Data.apiSearchProducts, `keyword=${searchQuery}`, (searchData) => {
        document.querySelector(".search_bar").style.display = "block";  

        searchData.forEach((e) => {
            Fling.API.get(Fling.Data.apiProducts, `/${e.id}`, (data) => {
                // productInfo 갯수 제한. 50개까지만 상품을 찾는다
                if (productInfo.length < 50) {
                    productInfo.push(data);
                    const theTemplate = Handlebars.compile(Fling.Template.recipePageSearchBarSource);
                    productInfo.forEach(item => {
                        item._name = item.name.replace(new RegExp(searchQuery, 'g'), `<span class="search_word">${searchQuery}</span>`);
                    });
                    const theCompiledHtml = theTemplate(productInfo);
                    searchBar.innerHTML = theCompiledHtml;
                }
            })
        })
    });
} 

function addProductHandler(e) {
    if(e.target.className == "search_bar_button") {
        Fling.API.get(Fling.Data.apiProducts, `/${e.target.value}`, (product) => {
            const theTemplateScript = document.querySelector("#cart_list_template_solo").innerHTML;
            const theTemplate = Handlebars.compile(theTemplateScript);
            const theCompiledHtml = theTemplate(product);

            document.querySelector(".cart_template").insertAdjacentHTML("beforeend", theCompiledHtml);
            document.querySelector(".search_bar").style.display = "none";
            document.querySelector(".search_text").value = "";
            calcTotalPrice();
        })
    }    
}


function storeUserCartData() {
    let cartListObj = {};
    
    cartListObj.recipeId = document.querySelector(".recipe_detail").dataId;
    cartListObj.recipeTitle = document.querySelector(".description > .title").innerHTML;
    cartListObj.recipeImg = document.querySelector(".circle_img").style.backgroundImage;
    cartListObj.recipeSubtitle = document.querySelector(".description > .subtitle").innerHTML;
    cartListObj.recipeUrl = document.querySelector(".detail_link a").href;
    cartListObj.recipePrice = document.querySelector(".recipe_additional_info .total_price > span").innerHTML;
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
