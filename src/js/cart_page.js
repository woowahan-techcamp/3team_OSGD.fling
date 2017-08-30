window.Fling = window.Fling || {};
window.Fling.CartPage = {
    EventHandler() {
        Fling.CartPage.getUserCart();
        Fling.$('.refrige_popup').addEventListener('click', Fling.onRefrigePopupHandler);
        Fling.$('.btn_fling').addEventListener('click', e => (window.location.href = './main.html'));
    },

    getUserCart() {
        const template = document.querySelector(".cart_list");
        let userCart;
        
        try {
            userCart = Fling.Storage.userCart;
        }
        catch(e) {
            return;
        }
        let templateCount = 0;
        userCart.forEach(async (el, index) => {
            
            el.productDetail = await Fling.API.post2(el.productApiUrl);
            
            let i;
            for(i=0;i<el.productList.length;i++) {
                el.productList[i].material_name = el.productDetail[i].material_name;
                el.productDetail[i].volume = el.productList[i].volume;
                el.productDetail[i].isChecked = el.productList[i].isChecked;
            }
            templateCount++;

            if (templateCount == userCart.length) {
                const theTemplateScript = document.querySelector("#user_cart_list_template").innerHTML;
                const theTemplate = Handlebars.compile(theTemplateScript);
                const theCompiledHtml = theTemplate(userCart);
                template.innerHTML = theCompiledHtml;

                //세션에 저장
                sessionStorage.setItem("userCart", JSON.stringify(userCart));

                function Handler(e) {
                    if (e.target.tagName == "A") {
                        Fling.CartPage.sendDataToPopUp(e);
                    }
                    else if (e.target.tagName == "BUTTON") {
                        Fling.CartPage.removeCartList(e);
                    }
                }
                                    
                document.querySelector(".cart_list").addEventListener("click", Handler);                    
                Fling.CartPage.setTotalPrice();
            }
        })
    },

    sendDataToPopUp(e) {
        const recipeTitle = e.target.innerHTML;
        let index = 0;
        const data = JSON.parse(sessionStorage.getItem("userCart"));
        
        const target = e.target.parentNode.parentNode.parentNode.parentNode;
        
        let divArr = document.getElementsByClassName("cart_list_item");
        divArr = Array.from(divArr);

        divArr.forEach((el, index) => {
            if (el == target) {
                e.target.href = 'javascript:void(0)';
                let blob = new Blob([JSON.stringify(data[index], null, 2)], {type: 'application: json'});
                let blobUrl = URL.createObjectURL(blob);
                Fling.Utils.PopupCenter(`./recipe_popup.html?data=${Fling.Utils.encodeBase64(blobUrl)}`, 'recipeInfoWindow', 700, 800);
            }
        });
    },

    removeCartList(e) {
        let bAfter = false;
        let cart_list = document.querySelector('.cart_list');
        if (cart_list.getAttribute('animate') !== null)
            return false;
        else
            cart_list.setAttribute('animate', '');

        let cart_item = Array.from(document.querySelectorAll('.cart_list_item'));
        let localStorageTemp = Fling.Storage.userCart;
        let sessionStorageTemp = Fling.Storage.userCartSession

        for (let i = 0; i < cart_item.length; i++) {
            if (cart_item[i].querySelector('.prd_del') === e.target) {
                cart_item[i].style.transition = '1s';
                cart_item[i].style.transform = 'translateX(-100vw)'

                Fling.Storage.removeUserCart(i);
                Fling.Storage.removeUserCartSession(i);
                Fling.CartPage.setTotalPrice();

                cart_item[i].addEventListener('transitionend', (e) => {
                    document.querySelector('.cart_list').removeChild(e.target);
                    document.querySelector('.cart_list').removeAttribute('animate');
                })

                bAfter = true;
            }
            else if (bAfter === true) {
                cart_item[i].style.transition = '.5s';
                cart_item[i].style.transitionDelay = '.5s';
                cart_item[i].style.transform = "translateY(-166px)";
                cart_item[i].addEventListener('transitionend', (e) => {
                    e.target.style = '';
                })
            }
        }
    },

    setTotalPrice() {
        let data;
        try {
            data = Fling.Storage.userCart;
        }
        catch(e) {
            return;
        } 
        const target = document.querySelector(".section_body");
        let totalPrice = 0;

        data.forEach((e) => {
            totalPrice +=  e.recipePrice.replace(/,/g, "") * 1;
        })

        target.innerHTML = Fling.Utils.numberWithComma(totalPrice) + "원";

    }
}

