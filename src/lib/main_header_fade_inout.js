function fadeInOutMain(selector1, selector2) {
    const fadeIn = document.querySelector(selector1);
    const fadeOut = document.querySelector(selector2);
    
    if (fadeIn.style.opacity == "1") {
        fadeIn.style.opacity = "0";
        fadeOut.style.opacity = "1";
    }
    else {
        fadeIn.style.opacity = "1";
        fadeOut.style.opacity = "0";
    }
}

export default fadeInOutMain;