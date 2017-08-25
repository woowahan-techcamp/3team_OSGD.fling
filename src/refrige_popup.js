document.addEventListener('DOMContentLoaded', (e) => {
    templateList();
    const searchTarget = document.querySelector(".search_text");
    searchTarget.addEventListener("keyup", refrigeSearchHandler);
    document.querySelector(".search_bar").addEventListener("click", addRemoveHandler);
    document.querySelector(".refrige_list").addEventListener("click", removeBtnHanler);
});


function templateList() {
    const myRefrige = JSON.parse(window.localStorage.getItem("myRefrige"));
    if (myRefrige == null)
        return;
    const target = document.querySelector(".refrige_list");
    const theTemplateScript = document.querySelector("#refrige_template").innerHTML;
    const theTemplate = Handlebars.compile(theTemplateScript);
    const theCompiledHtml = theTemplate(myRefrige);
    target.innerHTML = theCompiledHtml;
}


function refrigeSearchHandler(e) {
    const searchQuery = e.target.value;
    const searchBar = document.querySelector(".search_bar");
    let productInfo = [];
    
    
    if(searchQuery == "" || e.code == "Escape") {
        document.querySelector(".search_bar").style.display = "none";
        return;
    }

    XHR.post(`http://52.79.119.41/search_material?keyword=${searchQuery}`, (e) => {
        let searchData = JSON.parse(e.target.responseText);
        const searchDataLength = searchData.length;
        let myRefrige = JSON.parse(window.localStorage.getItem("myRefrige"));
        const searchBar = document.querySelector(".search_bar");
        searchBar.style.display = "block";  
        
        if (myRefrige != null) {
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
        else {
            for (let i = 0; i < searchDataLength; i++) {
                searchData[i].isHavingMaterial = false;
            }
        }

        const theTemplateScript = document.querySelector("#search_item_template").innerHTML;
        const theTemplate = Handlebars.compile(theTemplateScript);

        searchData.forEach(item => {
            item.name = item.name.replace(new RegExp(searchQuery, 'g'), `<span class="search_word">${searchQuery}</span>`);
        });

        const theCompiledHtml = theTemplate(searchData);
        searchBar.innerHTML = theCompiledHtml;

    });
}


function addRemoveHandler(e) {   
    let myRefrige = JSON.parse(window.localStorage.getItem("myRefrige"));
    const id = e.target.parentElement.getAttribute("value") * 1;
    const name = e.target.previousElementSibling.innerHTML;

    if (e.target.className == "add_material_btn") {
        let obj = {};
        obj.id = id;
        obj.name = name;

        if (myRefrige == null) {
            myRefrige = [];
            myRefrige.push(obj);
            window.localStorage.setItem("myRefrige", JSON.stringify(myRefrige));
        }
        else {
            myRefrige.push(obj);
            window.localStorage.setItem("myRefrige", JSON.stringify(myRefrige));
        }
        document.querySelector(".search_bar").style.display = "none";
        document.querySelector(".search_text").value = "";

        const theTemplateScript = document.querySelector("#refrige_template_solo").innerHTML;
        const theTemplate = Handlebars.compile(theTemplateScript);
        const theCompiledHtml = theTemplate(obj);
        document.querySelector(".refrige_list").insertAdjacentHTML("beforeend", theCompiledHtml);
    }
    else if (e.target.className == "remove_material_btn") {
        for (let i = 0; i < myRefrige.length; i++) {
            if (myRefrige[i].name == name) {
                myRefrige.splice(i, 1);
                window.localStorage.setItem("myRefrige", JSON.stringify(myRefrige));

                //remove list
                document.querySelector(".refrige_list").children[i].remove();

                //reset searchbar
                document.querySelector(".search_bar").style.display = "none";
                document.querySelector(".search_text").value = "";
                break;
            }
        }
    }   
}

function removeBtnHanler(e) {
    let myRefrige = JSON.parse(window.localStorage.getItem("myRefrige"));
    if (e.target.className == "material_remove_btn") {
        const refrigeListItem = Array.from(document.querySelectorAll(".refrige_list_item"));

        for (let i = 0; i < refrigeListItem.length; i++) {
            if (refrigeListItem[i].querySelector(".material_remove_btn") == e.target) {
                myRefrige.splice(i, 1);
                window.localStorage.setItem("myRefrige", JSON.stringify(myRefrige));
                refrigeListItem[i].remove();
                break;                
            }
        }
    }
}