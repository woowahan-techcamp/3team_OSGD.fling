class searchWindowClass {
    constructor(caretSelector, searchTextSelector, clickIconSelector, searchWindowSelector) {
        this.caret();
        this.caretIcon = document.querySelector(caretSelector);
        this.searchText = document.querySelector(searchTextSelector);
        this.clickIcon = document.querySelector(clickIconSelector);
        this.searchWindow = document.querySelector(searchWindowSelector);
        this.interval;
        this.eventInit();
    }

    eventInit() {
        this.clickIcon.addEventListener("click", )

        this.searchText.addEventListener("keydown", (e) => {
            window.clearInterval(this.interval);
            this.caretIcon.style.opacity = 0;
        });
    }

    dropDownInit() {
        
    }

    caret() {
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

/**
 *  필요한 기능
 * 1. 캐럿 깜박
 * 2. 플레이스홀더 클리어
 * 3. send handler (돋보기 아이콘 클릭, 엔터키 누르기)
 */