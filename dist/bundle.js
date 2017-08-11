/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/dist";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _main_fill_contents = __webpack_require__(1);

var _main_fill_contents2 = _interopRequireDefault(_main_fill_contents);

var _main_header_fade_inout = __webpack_require__(2);

var _main_header_fade_inout2 = _interopRequireDefault(_main_header_fade_inout);

var _util = __webpack_require__(3);

var _util2 = _interopRequireDefault(_util);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

document.addEventListener("DOMContentLoaded", function (e) {
    _util2.default.ajaxFunc("http://52.78.41.124/recipes", _main_fill_contents2.default, ".recommend_content_list");
    var interval = window.setInterval(_main_header_fade_inout2.default.bind(undefined, ".main_header_fade_in", ".main_header_fade_out"), 7000);
});

document.querySelector(".slide_arrow.prev").addEventListener("click", function (e) {
    var a = document.querySelector(".list_wrap");
    a.style.transition = "1s";
    a.style.transform = "translateX(990px)";

    //맨 뒤 떼서 앞에 붙이고 제자리
    a.addEventListener("transitionend", avs, false);

    function avs() {
        a.removeEventListener("transitionend", avs);
        var lastNode = a.children[2].cloneNode(true);
        a.removeChild(a.children[2]);
        a.insertBefore(lastNode, a.children[0]);
        a.style.transition = "none";
        a.style.transform = "translateX(0px)";
    }
});

document.querySelector(".slide_arrow.next").addEventListener("click", function (e) {
    var a = document.querySelector(".list_wrap");
    a.style.transition = "1s";
    a.style.transform = "translateX(-990px)";
    a.addEventListener("transitionend", avs, false);

    function avs() {
        a.removeEventListener("transitionend", avs);
        var firstNode = a.children[0].cloneNode(true);
        a.removeChild(a.children[0]);
        a.insertBefore(firstNode, a.children[2]);
        a.style.transition = "none";
        a.style.transform = "translateX(0px)";
        a.removeEventListener("transitionend", avs);
    }
});

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});
function fillContentRecommendSection(data, selector) {
    var li = document.querySelector(selector).children;

    var liArr = Array.from(li);
    var i = 0;

    liArr.forEach(function (e) {
        e.children[0].href = data[i].url;
        e.children[0].children[0].style.backgroundImage = "url('" + data[i].image + "')";

        e.children[1].children[0].href = data[i].url;
        e.children[1].children[0].innerHTML = data[i].subtitle;
        e.children[2].innerHTML = data[i].title + "  |  " + data[i].writer;

        i++;
    });
}

exports.default = fillContentRecommendSection;

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});
function fadeInOutMain(selector1, selector2) {
    var fadeIn = document.querySelector(selector1);
    var fadeOut = document.querySelector(selector2);

    if (fadeIn.style.opacity == "1") {
        fadeIn.style.opacity = "0";
        fadeOut.style.opacity = "1";
    } else {
        fadeIn.style.opacity = "1";
        fadeOut.style.opacity = "0";
    }
}

exports.default = fadeInOutMain;

/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});
var _ = {
    ajaxFunc: function ajax(url, exeFunc, selector) {
        var oReq = new XMLHttpRequest();
        oReq.addEventListener("load", function (e) {
            var data = JSON.parse(oReq.responseText);
            exeFunc(data, selector);
        });
        oReq.open("GET", url);
        oReq.send();
    }
};
exports.default = _;

/***/ })
/******/ ]);