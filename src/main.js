(function(){
    async function mainEventHandler() {
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
    
        mainHeaderFade(Fling.$$('.main_header_img'), 6000);
        
        const target = document.querySelector(".search_text");
        target.addEventListener("keyup", searchHandler);
    
        document.querySelector(".refrige_popup").addEventListener("click", (e) => {
            e.target.href = 'javascript:void(0)';
            const popup = window.open("./refrige_popup.html", "refrigeWindow", "width=700,height=800,toolbar=no,menubar=no");
        })
    }
    
    function mainHeaderFade(elementArray, delayTime) {
        let sequence = 0;
        return setInterval(() => {
            elementArray.forEach((el, i) => {
                el.style.opacity = 0;
            });
    
            sequence = (sequence + 1) % elementArray.length;
            elementArray[sequence].style.opacity = '1';
        }, delayTime);
    }
    
    function searchHandler(e) {
        const searchQuery = e.target.value;
        const searchBar = document.querySelector(".search_bar");
        
        if(searchQuery == "" || e.code == "Escape") {
            document.querySelector(".search_bar").style.display = "none";
            searchBar.innerHTML = "";
            return;
        }
    
        Fling.API.post(Fling.Data.apiSearchRecipes, `keyword=${searchQuery}`, (searchData) => {
            document.querySelector(".search_bar").style.display = "block";  
    
            const theTemplate = Handlebars.compile(Fling.Template.mainSearchBarSource);
            searchData.forEach(item => {
                item._title = item.title.replace(new RegExp(searchQuery, 'g'), `<span class="search_word">${searchQuery}</span>`);
                item._subtitle = item.subtitle.replace(new RegExp(searchQuery, 'g'), `<span class="search_word">${searchQuery}</span>`);
            });
            const theCompiledHtml = theTemplate(searchData);
            searchBar.innerHTML = theCompiledHtml;
        });
    } 
    
    document.addEventListener("DOMContentLoaded", mainEventHandler);
})();