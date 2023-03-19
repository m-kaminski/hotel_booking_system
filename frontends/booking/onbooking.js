

function submitBookingSearch() {
    var m = document.getElementById("mainContent");
    m.innerHTML = "Searching for rooms";
    function addRoom(o) {
        res = "<div class='roomDesc'>";
        res += "<h3>" + o.name + "</h3>";
        res += "<p>" + o.description + "</p><ul>";
        res += "<li>" + (o.smoking ? "smoking" : "non-smoking") + "</li>";
        if (o.disability)
            res += "<li>accessible</li>";
        res += "<li>" + o.beds + " beds </li>";
        res += "</ul></div>";
        m.innerHTML += res;
    };

    console.log("onSubmit");

    isoCheckin = "";
    isoCheckout = "";

    if (bookingSearchForm.validate()) {
        isoCheckin = dojo.date.stamp.toISOString(dijit.byId("checkin").get("value"));
        isoCheckout = dojo.date.stamp.toISOString(dijit.byId("checkout").get("value"));
        if (isoCheckin >= isoCheckout) {
            alert('Checkout after checkin needeed.  Please correct first');
            return false;
        }
    } else {
        alert('Form contains invalid data or data is missing.  Please correct first');
        return false;
    }
    console.log(bookingSearchForm.getValues());

    dojo.xhr.get({
        // The URL to request
        url: "http://localhost:8080/findrooms",
        // The method that handles the request's successful result
        // Handle the response any way you'd like!
        content: {
            checkin: isoCheckin,
            checkout: isoCheckout
        },

        load: function (result) {

            console.log(result);

            JSON.parse(result).forEach(
                (data) => { addRoom(data); }
            )
        },
        error: function (data) {
            alert("FCGI call failed with: : " + data);
        }

    });

    return true;
}