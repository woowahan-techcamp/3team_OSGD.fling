var GetRecipeInfo = function() {};

GetRecipeInfo.prototype = {
    run: function(arguments) {
        var title = document.getElementsByTagName("strong")[0].textContent
        var writer = document.getElementsByTagName("em")[0].textContent

        arguments.completionFunction(
                                     {"URL": document.URL
                                     ,"title": title
                                     ,"writer": writer
                                     });
    }
};

var ExtensionPreprocessingJS = new GetRecipeInfo;
