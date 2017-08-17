document.addEventListener('DOMContentLoaded', (e) => {
    let url = Utils.getParameterByName('query_url');
    XHR.post(`http://52.78.41.124/recipes?url=${url}`, (e) => {
        let jsonData;
        try {
            jsonData = JSON.parse(e.target.responseText);
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
