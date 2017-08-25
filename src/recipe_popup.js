document.addEventListener('DOMContentLoaded', () => {
    
    // getParameterByName 함수가 공백을 +로 바꿈
    var data = Utils.getParameterByName('data').replace(/ /g, '+');
    data = JSON.parse(Utils.decodeBase64(data));
    modifyData(data);
    document.querySelector('.header_box .circle_img').style.backgroundImage = data.recipeImg;
    document.querySelector('.header_box .recipe_site_link a').href = data.recipeUrl;
    document.querySelector('.header_box .description').innerText = data.recipeSubtitle;
    document.querySelector('.header_box .title a').innerText = data.recipeTitle;
    const theTemplateScript = document.querySelector("#product_list_template").innerHTML;
    const theTemplate = Handlebars.compile(theTemplateScript);
    const theCompiledHtml = theTemplate(data);
    document.querySelector('.product_list_wrap').innerHTML = theCompiledHtml;

});

window.addEventListener("message", receiveMessage, false);

function receiveMessage(event)
{
    console.info(event);
}

function modifyData(data) {
    const regex = /(\d+)/g;

    data.productDetail.forEach((e) => {
        e.bundle = e.bundle || "1개";
        const number = e.bundle.match(regex); 
        //debugger;
        e.bundle =  ((number[0] * 1) * (e.volume * 1)) + e.bundle.replace(number, ""); 
        e.price = Utils.numberWithComma((e.price.replace(/,/g, "") * 1) * (e.volume * 1));
    })
}