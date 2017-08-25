document.addEventListener('DOMContentLoaded', (e) => {
    getUserCart();
    
    document.querySelector(".btn_fling").addEventListener("click", (e) => {
        window.location.href = "./main.html";
    });

    document.querySelector(".refrige_popup").addEventListener("click", (e) => {
        e.target.href = 'javascript:void(0)';
        const popup = window.open("./refrige_popup.html", "refrigeWindow", "width=700,height=800,toolbar=no,menubar=no");
    });
});

let templateCount = 0;

function getUserCart() {
    const template = document.querySelector(".cart_list");
    let userCart = window.localStorage.userCart;
    userCart = JSON.parse(userCart);
    
    userCart.forEach((el, index) => {
        
        XHR.post(el.productApiUrl, (e) => {
            el.productDetail = JSON.parse(e.target.responseText);
            
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

                addEvent();
                setTotalPrice();
            }
        })
    })
}

function addEvent() {
    document.querySelector(".cart_list").addEventListener("click", Handler);
}


function Handler(e) {
    if (e.target.tagName == "A") {
        sendDataToPopUp(e);
    }
    else if (e.target.tagName == "BUTTON") {
        removeCartList(e);
    }
}

function sendDataToPopUp(e) {
    const recipeTitle = e.target.innerHTML;
    let index = 0;
    const data = JSON.parse(sessionStorage.getItem("userCart"));
    
    const target = e.target.parentNode.parentNode.parentNode.parentNode;
    
    let divArr = document.getElementsByClassName("cart_list_item");
    divArr = Array.from(divArr);

    divArr.forEach((el, index) => {
        if (el == target) {
            
            e.target.href = 'javascript:void(0)';
            
            const popup = window.open(`./recipe_popup.html?data=${Utils.encodeBase64(JSON.stringify(data[index]))}`, "recipeWindow", "width=700,height=800,toolbar=no,menubar=no");

        }
    });
}

function removeCartList(e) {
    let bAfter = false;
    let cart_list = document.querySelector('.cart_list');
    if (cart_list.getAttribute('animate') !== null)
        return false;
    else
        cart_list.setAttribute('animate', '');

    let cart_item = Array.from(document.querySelectorAll('.cart_list_item'));
    let localStorageTemp = JSON.parse(localStorage.getItem("userCart"));
    let sessionStorageTemp = JSON.parse(sessionStorage.getItem("userCart"));

    for (let i = 0; i < cart_item.length; i++) {
        if (cart_item[i].querySelector('.prd_del') === e.target) {
            cart_item[i].style.transition = '1s';
            cart_item[i].style.transform = 'translateX(-100vw)'

            localStorageTemp.splice(i, 1);
            sessionStorageTemp.splice(i,1);
            window.localStorage.setItem("userCart", JSON.stringify(localStorageTemp));
            window.sessionStorage.setItem("userCart", JSON.stringify(sessionStorageTemp));
            setTotalPrice();

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
}


function setTotalPrice() {
    const data = JSON.parse(window.localStorage.getItem("userCart"));
    const target = document.querySelector(".section_body");
    let totalPrice = 0;

    data.forEach((e) => {
        totalPrice +=  e.recipePrice.replace(/,/g, "") * 1;
    })

    target.innerHTML = Utils.numberWithComma(totalPrice) + "원";

}