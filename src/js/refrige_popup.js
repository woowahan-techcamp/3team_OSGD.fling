window.Fling = window.Fling || {};
window.Fling.RefrigePopup = {
    EventHandler(e) {
        Fling.RefrigePopup.templateList();
        const searchTarget = Fling.$(".search_text");
        searchTarget.addEventListener("keyup", Fling.RefrigePopup.refrigeSearchHandler);
        Fling.$(".search_bar").addEventListener("click", Fling.RefrigePopup.addRemoveHandler);
        Fling.$(".refrige_list").addEventListener("click", Fling.RefrigePopup.removeBtnHandler);
    },

    templateList() {
        let myRefrige;
        try {
            myRefrige = Fling.Storage.myRefrige;
        }
        catch(e) {
            return;
        }
        const target = Fling.$(".refrige_list");
        const theTemplateScript = Fling.$("#refrige_template").innerHTML;
        const theTemplate = Handlebars.compile(theTemplateScript);
        const theCompiledHtml = theTemplate(myRefrige.reverse());
        target.innerHTML = theCompiledHtml;
    },

    async refrigeSearchHandler(e) {
        const searchQuery = e.target.value;
        const searchBar = Fling.$(".search_bar");
        let productInfo = [];
        
        
        if(searchQuery == "" || e.code == "Escape") {
            Fling.$(".search_bar").style.display = "none";
            return;
        }
    
        let searchData = await Fling.API.post2(Fling.Data.apiSearchMaterials, `keyword=${searchQuery}`);
        const searchDataLength = searchData.length;
        searchBar.style.display = "block";
        let myRefrige;  
    
        try {
            myRefrige = Fling.Storage.myRefrige;
            const myRefrigeLength = myRefrige.length;
            for(let i = 0; i < searchDataLength; i++) {
                searchData[i].isHavingMaterial = false;
                for (let k = 0; k < myRefrigeLength; k++) {
                    if (searchData[i].name == myRefrige[k].name) {
                        searchData[i].isHavingMaterial = true;
                        break;
                    }
                }
            }
        }
        catch(e) {
            for (let i = 0; i < searchDataLength; i++) {
                searchData[i].isHavingMaterial = false;
            }
        }
    
        const theTemplateScript = Fling.$("#search_item_template").innerHTML;
        const theTemplate = Handlebars.compile(theTemplateScript);
    
        searchData.forEach(item => {
            item._name = item.name.replace(new RegExp(searchQuery, 'g'), `<span class="search_word">${searchQuery}</span>`);
        });
    
        const theCompiledHtml = theTemplate(searchData);
        searchBar.innerHTML = theCompiledHtml;
    },
    
    addRemoveHandler(e) {   
        let myRefrige = JSON.parse(window.localStorage.getItem("myRefrige"));
        const id = e.target.parentElement.getAttribute("value") * 1;
        const name = e.target.previousElementSibling.dataset.name;
    
        if (e.target.className == "add_material_btn") {
            let obj = {};
            obj.id = id;
            obj.name = name;
    
            Fling.Storage.addMyRefrige(obj);
            Fling.$(".search_bar").style.display = "none";
            Fling.$(".search_text").value = "";
    
            const theTemplateScript = Fling.$("#refrige_template_solo").innerHTML;
            const theTemplate = Handlebars.compile(theTemplateScript);
            const theCompiledHtml = theTemplate(obj);
            Fling.$(".refrige_list").insertAdjacentHTML("afterbegin", theCompiledHtml);
        }
        else if (e.target.className == "remove_material_btn") {
            for (let i = 0; i < myRefrige.length; i++) {
                if (myRefrige[i].name == name) {
                    Fling.Storage.removeMyRefrige(i);
                    //remove list
                    Fling.$(".refrige_list").children[i].remove();
                    //reset searchbar
                    Fling.$(".search_bar").style.display = "none";
                    Fling.$(".search_text").value = "";
                    break;
                }
            }
        }   
    },
    
    removeBtnHandler(e) {
        if (e.target.className == "material_remove_btn") {
            const refrigeListItem = Array.from(Fling.$$(".refrige_list_item"));
            let myRefrige = Fling.Storage.myRefrige;
    
            for (let i = 0; i < refrigeListItem.length; i++) {
                if (refrigeListItem[i].querySelector(".material_remove_btn") == e.target) {
                    Fling.Storage.removeMyRefrige(refrigeListItem.length - i - 1);
                    refrigeListItem[i].remove();
                    break;                
                }
            }
        }
    }
    
}