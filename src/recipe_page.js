document.addEventListener('DOMContentLoaded', (e) => {
    let url = Utils.getParameterByName('query_url');
    XHR.post(`http://52.78.41.124/recipes?url=${url}`, (e) => {
        let jsonData;
        try {
            jsonData = JSON.parse(e.target.responseText);
            XHR.get(`http://52.78.41.124/get_products/${jsonData.id}`, (e) => {
                let data = JSON.parse(e.target.responseText);
                template(data);
            })
        }
        catch (e) {
            // exception
        }

        document.querySelector('.recipe_detail .title').innerText = jsonData.title;
        document.querySelector('.recipe_detail .subtitle').innerText = jsonData.subtitle;
        document.querySelector('.recipe_detail .circle_img').style.cssText = `background-image: url("${jsonData.image}")`;
        document.querySelector('.detail_link a').href = jsonData.url;
        document.querySelector('.missed_material .subtitle').innerText = jsonData.missed_material;
        document.querySelector('.recipe_cart .title_main').innerText = jsonData.title;
    });

    console.info(Utils.getParameterByName('query_url'));
});




function template(data) {
    const theTemplateScript = document.querySelector("#cart_list_template").innerHTML;
    const theTemplate = Handlebars.compile(theTemplateScript);
    const theCompiledHtml = theTemplate(data);
    
    document.querySelector(".cart_template").innerHTML = theCompiledHtml;
    calcTotalPrice();

    document.querySelector(".cart_template").addEventListener('click', (e) => {
        if (e.target.className == "up_button") {
            if (e.target.parentElement.parentElement.children[0].value < 999)
                e.target.parentElement.parentElement.children[0].value++;
        } else if (e.target.className == "down_button") {
            if (e.target.parentElement.parentElement.children[0].value > 1)
                e.target.parentElement.parentElement.children[0].value--;
        } else if (e.target.className == "recipe_checkbox") {
        } else {
            return;
        }

        let item_tp = e.target.parentElement.parentElement.parentElement.querySelector('.total_price');
        let item_volume = e.target.parentElement.parentElement.parentElement.querySelector('#volume').value;
        let item_unit_price = e.target.parentElement.parentElement.parentElement.querySelector('#per_price').value.replace(/,/g, '');

        item_tp.innerText = numberWithCommas(item_volume * item_unit_price) + '원';

        calcTotalPrice();
    });

    document.querySelector(".cart_template").addEventListener('keydown', (e) => {
        if (e.target.id == 'volume') {
            // 숫자와 특수키만 받는다
            if (e.key >= '0' && e.key <= '9' || e.keyCode < 48) {
                return;
            }
            e.preventDefault();
            e.stopPropagation();
            return false;
        }
    });

    document.querySelector(".cart_template").addEventListener('keyup', (e) => {
        
        let item_tp = e.target.parentElement.parentElement.parentElement.querySelector('.total_price');
        let item_volume = e.target.parentElement.parentElement.parentElement.querySelector('#volume').value;
        console.info(item_volume);
        let item_unit_price = e.target.parentElement.parentElement.parentElement.querySelector('#per_price').value.replace(/,/g, '');

        item_tp.innerText = numberWithCommas(item_volume * item_unit_price) + '원';

        calcTotalPrice();
    });
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
        price = price.replace(",", "");

        price = parseInt(price);

        if (isAvaliableItem(cartListsArr[i]))
            sum += price;
    }
    
    sumNum = sum;
    sum = numberWithCommas(sum);
    cartListsArr[len-1].children[0].innerHTML = sum;

    const subPrice = document.querySelector(".pi_prd");
    subPrice.innerHTML = sum;

    const flingCash = document.querySelector(".pi_point");
    flingCash.innerHTML = parseInt(sumNum * 0.01);
}


function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function isAvaliableItem(el) {
    return el.parentElement.parentElement.parentElement.querySelector('#check1').checked;
}