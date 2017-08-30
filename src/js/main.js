window.Fling = window.Fling || {};
window.Fling.Main = {
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

        Fling.Main.fadeMainHeaderImage(Fling.$$('.main_header_img'), 6000);
        
        Fling.$(".search_text").addEventListener("keyup", Fling.Main.searchHandler);    
        Fling.$(".refrige_popup").addEventListener("click", Fling.onRefrigePopupHandler);
        Fling.onEvent('.search_text', 'keydown', Fling.Main.searchBarUpDownHandler);
    },
    async searchHandler(e) {
        const text = Fling.$(".search_text").value;
        const searchQuery = e.target.value;
        let searchBar = Fling.$(".search_bar");
        if (text.includes("http"))
            return;

        if(searchQuery == "" || e.code == "Escape") {
            Fling.$(".search_bar").style.display = "none";
            searchBar.innerHTML = "";
            return;
        }
        else if (e.code === 'ArrowLeft' || e.code === 'ArrowRight') {
            return;
        }
        else if(e.code === 'ArrowUp') {
            return; 
        }
        else if (e.code === 'ArrowDown') {
            return;
        }
        else if (e.code === 'Enter') {
            Fling.Main.sendUrl();
        }
        else {
            searchBar.style.display = 'block';
            let searchData = await Fling.API.post2(Fling.Data.apiSearchRecipes, `keyword=${searchQuery}`);
            const theTemplate = Handlebars.compile(Fling.Template.mainSearchBarSource);
            searchData.forEach(item => {
                item._title = item.title.replace(new RegExp(searchQuery, 'g'), `<span class="search_word">${searchQuery}</span>`);
                item._subtitle = item.subtitle.replace(new RegExp(searchQuery, 'g'), `<span class="search_word">${searchQuery}</span>`);
            });
            const theCompiledHtml = theTemplate(searchData);
            searchBar.innerHTML = theCompiledHtml;
            if (searchBar.children[0].classList.length == 1){
                searchBar.children[0].classList.add('selected');
            }
        }
    },

    sendUrl() {
        Fling.$('.selected.search_bar_button').click();
    },

    flag: true,
    
    searchBarUpDownHandler(e) {
        const searchBar = Fling.$(".search_bar");
        const selected = Fling.$('.selected');
        if (Fling.Main.flag == false)
            return;
        window.setTimeout((e) => { Fling.Main.flag = true; }, 80); 
        if(e.code == 'ArrowUp') {
            let index = Fling.Main.findSelectedTab();
            if (index == 0)
                return;
            searchBar.children[index].classList.remove('selected');
            searchBar.children[index - 1].classList.add('selected');
            if (selected.offsetTop - selected.clientHeight < searchBar.scrollTop) {
                searchBar.scrollTop = selected.offsetTop - selected.clientHeight;
            } 
        }
        else if (e.code == 'ArrowDown') {
            let index = Fling.Main.findSelectedTab();
            if (index == searchBar.children.length - 1) 
                return;
            searchBar.children[index].classList.remove('selected');
            searchBar.children[index + 1].classList.add('selected');
            if (selected.offsetTop >= searchBar.scrollTop + (4 * selected.clientHeight)) {
                //searchBar.scrollTop = selected.offsetTop - 400 + selected.clientHeight * 2;
                searchBar.scrollTop += selected.clientHeight + 1;
            }
        }
        Fling.Main.flag = false;
    },

    findSelectedTab() {
        const selected = Fling.$('.selected');
        const searchBarArr = Fling.$$('.search_bar_list');
        let indexOfArr = -1;
        searchBarArr.forEach((value, index) => {
            if (value == selected)
                indexOfArr = index;
        })
        return indexOfArr;
    },

    fadeMainHeaderImage(elementArray, delayTime) {
        let sequence = 0;
        return setInterval(() => {
            elementArray.forEach(el => (el.style.opacity = 0));
            sequence = (sequence + 1) % elementArray.length;
            elementArray[sequence].style.opacity = '1';
        }, delayTime);
    }
}
module.exports = window.Fling.Main;