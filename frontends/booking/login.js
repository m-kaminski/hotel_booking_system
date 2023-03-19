function showLoggedIn() {
    document.getElementById("loggedIn").style.display = 'block';
    document.getElementById("loggedOut").style.display = 'none';
}

function showLoggedOut() {
    document.getElementById("loggedIn").style.display = 'none';
    document.getElementById("loggedOut").style.display = 'block';

}
function login() {
    dojo.xhr.get({
        // The URL to request
        url: "http://localhost:8080/login",
        // The method that handles the request's successful result
        // Handle the response any way you'd like!
        content: {email:document.getElementById("email").value,
                  password: document.getElementById("password").value},
        load: function (result) {
            login_info = JSON.parse(result);

            console.log(result);
            if (login_info == null) {
                alert("Bad login or password or other info : " + data);
            } else {
                console.log("LOGIN");
                showLoggedIn();
                document.getElementById("usernameGreeting").innerHTML = login_info.legal_first_name;
                console.log(login_info);
            }
        },
        
        error: function (data) {
            alert("FCGI call failed with: : " + data);
        }

    });

}

function logout() {
    dojo.xhr.get({
        // The URL to request
        url: "http://localhost:8080/logout",
        content: { },


        load: function (result) {
                showLoggedOut();
        },
        error: function (data) {
            alert("FCGI call failed with: : " + data);
        }

    });
}

function checkLogin() {


    dojo.xhr.get({
        // The URL to request
        url: "http://localhost:8080/getlogin",
        content: { },

        load: function (result) {
            login_info = JSON.parse(result);

            console.log(result);
            if (login_info == null) {
                console.log("LOGOUT");
                showLoggedOut();
            } else {
                console.log("LOGIN");
                showLoggedIn();
                document.getElementById("usernameGreeting").innerHTML = login_info.legal_first_name;
                console.log(login_info);
            }
        },

        error: function (data) {
            alert("FCGI call failed with: : " + data);
        }

    });

}