document.addEventListener('DOMContentLoaded', (e) => {
    templateList();
    const searchTarget = document.querySelector(".search_text");
    searchTarget.addEventListener("keyup", refrigeSearchHandler);
    addRemoveHandler();
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
        const theCompiledHtml = theTemplate(searchData);
        searchBar.innerHTML = theCompiledHtml;

    });
}


function addRemoveHandler() {
    document.querySelector(".search_bar").addEventListener("click", (e) => {
        if (e.target.className == "add_material_btn") {
            let myRefrige = JSON.parse(window.localStorage.getItem("myRefrige"));
            const id = e.target.parentElement.getAttribute("value") * 1;
            const name = e.target.previousElementSibling.innerHTML;
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
            const theTemplateScript = document.querySelector("#refrige_template_solo").innerHTML;
            const theTemplate = Handlebars.compile(theTemplateScript);
            const theCompiledHtml = theTemplate(obj);
            document.querySelector(".refrige_list").insertAdjacentHTML("beforeend", theCompiledHtml);
        }
        else if (e.target.className == "remove_material_btn") {
            
        }
    })
}