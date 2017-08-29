Fling.Main = {
    async EventHandler() {
        let rankSection = new Fling.View.TileView({
            data: await Fling.API.get2(Fling.Data.apiRecipes),
            title: '플링 <em>인기 차트</em>',
            id: 'recommended'
        }, Fling.$('fling-main-recipe'));
    
        let seasonSection = new Fling.View.SlideView({
            data: await Fling.API.get2(Fling.Data.apiSeason),
            title: '여름엔 <em>플링</em>',
            id: 'season_event'
        }, Fling.$('fling-season-recipe'));
    
        Fling.Main.mainHeaderFade(Fling.$$('.main_header_img'), 6000);
        
        const target = Fling.$(".search_text");
        target.addEventListener("keyup", Fling.Main.searchHandler);
    
        Fling.$(".refrige_popup").addEventListener("click", (e) => {
            e.target.href = 'javascript:void(0)';
            const popup = window.open("./refrige_popup.html", "refrigeWindow", "width=700,height=800,toolbar=no,menubar=no");
        })
    },
    mainHeaderFade(elementArray, delayTime) {
        let sequence = 0;
        return setInterval(() => {
            elementArray.forEach(el => (el.style.opacity = 0));
            sequence = (sequence + 1) % elementArray.length;
            elementArray[sequence].style.opacity = '1';
        }, delayTime);
    },
    async searchHandler(e) {
        const searchQuery = e.target.value;
        const searchBar = Fling.$(".search_bar");
        
        if(searchQuery == "" || e.code == "Escape") {
            Fling.$(".search_bar").style.display = "none";
            searchBar.innerHTML = "";
            return;
        }
        Fling.$('.search_bar').style.display = 'block';
        let searchData = await Fling.API.post2(Fling.Data.apiSearchRecipes, `keyword=${searchQuery}`);
        const theTemplate = Handlebars.compile(Fling.Template.mainSearchBarSource);
        searchData.forEach(item => {
            item._title = item.title.replace(new RegExp(searchQuery, 'g'), `<span class="search_word">${searchQuery}</span>`);
            item._subtitle = item.subtitle.replace(new RegExp(searchQuery, 'g'), `<span class="search_word">${searchQuery}</span>`);
        });
        const theCompiledHtml = theTemplate(searchData);
        searchBar.innerHTML = theCompiledHtml;

    }
}
