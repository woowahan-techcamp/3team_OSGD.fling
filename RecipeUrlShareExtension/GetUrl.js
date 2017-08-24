var GetUrl = function() {};

GetUrl.prototype = {
    run: function(arguments) {
        arguments.completionFunction({"URL": document.URL});
    }
};

var ExtensionPreprocessingJS = new GetUrl;
