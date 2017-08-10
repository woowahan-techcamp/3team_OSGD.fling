class textBox {
    constructor(searchDivSelector) {
        this.searchDivSelector = document.querySelector(searchDivSelector);
        this.caretIcon = this.searchDivSelector.children[0];
        this.searchText = this.searchDivSelector.children[1].children[0];
        this.interval;
        this.blinkCaret();
        this.eventInit();
    }

    eventInit() {
        this.searchText.addEventListener("keydown", (e) => {
            window.clearInterval(this.interval);
            this.caretIcon.style.opacity = 0;
        });
    }


    blinkCaret() {
        let turn = 0;

        this.interval = window.setInterval(()=> { 
            if (turn == 0) {
                this.caretIcon.style.opacity = "0";
                turn = 1;
            }
            else {
                this.caretIcon.style.opacity = "1";
                turn = 0;
            }
        },500);
    }
}

//////////////////////////////////////////
class textBox {
    constructor(searchDivSelector, templateSelector, placeHolder) {
        this.templateSelector = document.querySelector(templateSelector);
        this.searchDivSelector = document.querySelector(searchDivSelector);
        this.searchDivSelector.innerHTML = this.templateSelector.innerHTML;
        this.searchBody = document.querySelector(".search_body");
        this.caretIcon = this.searchBody.children[0];
        this.searchText = this.searchBody.children[1].children[0];
        this.searchText.placeholder = placeHolder;
        this.interval;
        this.blinkCaret();
        this.eventInit();
    }

    eventInit() {
        this.searchText.addEventListener("keydown", (e) => {
            window.clearInterval(this.interval);
            this.caretIcon.style.opacity = 0;
        });
    }


    blinkCaret() {
        let turn = 0;

        this.interval = window.setInterval(()=> { 
            if (turn == 0) {
                this.caretIcon.style.opacity = "0";
                turn = 1;
            }
            else {
                this.caretIcon.style.opacity = "1";
                turn = 0;
            }
        },500);
    }
}
