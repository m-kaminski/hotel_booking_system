require([
    'dojo/dom',
    
    'dojo/domReady!'
], function (dom) {
    var greeting = dom.byId('greeting');
    greeting.innerHTML += ' from Dojo (AMD)!';


});

/*
require(["dijit/ConfirmDialog", "dojo/domReady!"], function(ConfirmDialog){
    myDialog = new ConfirmDialog({
        title: "My ConfirmDialog",
        content: "<div id='ConfirmDialog'>Test content.</div>",
        style: "width: 300px"
    });
});
*/

//require(["dijit/ConfirmDialog", "dijit/form/TextBox", "dijit/form/Button"]);

