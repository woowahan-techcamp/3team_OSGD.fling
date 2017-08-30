window.Fling = window.Fling || {};
window.Fling.RecipePopup = {
    async EventHandler(e) {
        // getParameterByName 함수가 공백을 +로 바꿈
        var blobUrl_base64 = Fling.Utils.getParameterByName('data').replace(/ /g, '+');
        var blobUrl = Fling.Utils.decodeBase64(blobUrl_base64);
        //let data = await Fling.RecipePopup.getBlobData(blobUrl);
        let data = await Fling.API.get2(blobUrl);

        Fling.RecipePopup.modifyData(data);
        Fling.$('.header_box .circle_img').style.backgroundImage = data.recipeImg;
        Fling.$('.header_box .recipe_site_link a').href = data.recipeUrl;
        Fling.$('.header_box .description').innerText = data.recipeSubtitle;
        Fling.$('.header_box .title a').innerText = data.recipeTitle;
        const theTemplateScript = Fling.$("#product_list_template").innerHTML;
        const theTemplate = Handlebars.compile(theTemplateScript);
        const theCompiledHtml = theTemplate(data);
        Fling.$('.product_list_wrap').innerHTML = theCompiledHtml;        
    },

    modifyData(data) {
        const regex = /(\d+)/g;
        data.productDetail.forEach((e) => {
            e.bundle = e.bundle || "1개";
            const number = e.bundle.match(regex); 

            e.bundle =  ((number[0] * 1) * (e.volume * 1)) + e.bundle.replace(number, ""); 
            e.price = Fling.Utils.numberWithComma((e.price.replace(/,/g, "") * 1) * (e.volume * 1));
        })
    }
}

