function fillContentRecommendSection(data, selector) {
    const li =document.querySelector(selector).children;

    const liArr = Array.from(li);
    let i = 0;
    
    liArr.forEach((e) => {
        e.children[0].href = data[i].url;
        e.children[0].children[0].style.backgroundImage = "url('" + data[i].image  + "')";

        e.children[1].children[0].href = data[i].url;
        e.children[1].children[0].innerHTML = data[i].subtitle;
        e.children[2].innerHTML = data[i].title + "  |  " + data[i].writer;
        
        i++;
    })
}

export default fillContentRecommendSection;


