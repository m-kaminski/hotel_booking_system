require([
    'dojo/dom',
    
    'dojo/domReady!'
], function (dom) {
    var greeting = dom.byId('mainheader');
    greeting.innerHTML += ' the Overlook Hotel!';
});




