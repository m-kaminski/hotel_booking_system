require([
    'dojo/dom',
    
    'dojo/domReady!'
], function (dom) {
    var greeting = dom.byId('greeting');
    greeting.innerHTML += ' the Overlook Hotel!';
});




