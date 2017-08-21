document.addEventListener('DOMContentLoaded', (e) => {
    getUserCart();

});


function getUserCart() {
    let userCart = window.localStorage.userCart;
    userCart = JSON.parse(userCart);

    userCart.forEach((el) => {
        el.productList.forEach((el2) => {
            XHR.get(`http://52.79.119.41/products/${el2.id}`, (e) => {
                let detailInfo = JSON.parse(e.target.responseText);
                
                if (!el.hasOwnProperty("productDetail")) {
                    el.productDetail = [];
                }
                
                el.productDetail.push(detailInfo);
            })
        })
    })

    //상품데이터 userCart에 다 박아둿다.
    //이제 템플릿에 박아넣기만 하면 된다.
    console.log(userCart);
}