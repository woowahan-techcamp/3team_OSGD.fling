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
    /////////////////////////////////////
    document.querySelector(".product_img").addEventListener("click", modalHandler);
    document.querySelector(".modal_close").addEventListener("click", closeModal);
});


function modalHandler() {
    const dimmed = document.querySelector(".dimmed");
    const modal = document.querySelector(".recipe_modal");
    const dimmed_black = document.querySelector(".dimmed_black");

    modal.classList.remove("display_none");
    dimmed.classList.add("apply_dimmed");
    dimmed_black.classList.add("apply_dimmed_black");
}

function closeModal() {
    const dimmed = document.querySelector(".dimmed");
    const modal = document.querySelector(".recipe_modal");
    const dimmed_black = document.querySelector(".dimmed_black");

    modal.classList.add("display_none");
    dimmed.classList.remove("apply_dimmed");
    dimmed_black.classList.remove("apply_dimmed_black");
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function template(data) {
    const theTemplateScript = document.querySelector("#cart_list_template").innerHTML;
    const theTemplate = Handlebars.compile(theTemplateScript);
    const theCompiledHtml = theTemplate(data);
    
    document.querySelector(".cart_template").innerHTML = theCompiledHtml;
    document.querySelector(".cart_template").addEventListener('click', (e) => {
        console.info(e);
        if (e.target.className == "up_button") {
            if (e.target.parentElement.parentElement.children[0].value < 999)
                e.target.parentElement.parentElement.children[0].value++;
        } else {
            if (e.target.parentElement.parentElement.children[0].value > 1)
                e.target.parentElement.parentElement.children[0].value--;
        }

        let item_tp = e.target.parentElement.parentElement.parentElement.querySelector('.total_price');
        let item_volume = e.target.parentElement.parentElement.parentElement.querySelector('#volume').value;
        let item_unit_price = e.target.parentElement.parentElement.parentElement.querySelector('#per_price').value.replace(/,/g, '');

        item_tp.innerText = numberWithCommas(item_volume * item_unit_price) + '원';

        console.error(item_tp);
        console.error(item_unit_price);
    });
}