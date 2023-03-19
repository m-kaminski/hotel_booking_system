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
        url: "http://localhost:8080/login",
        content: {
            email: document.getElementById("email").value,
            password: document.getElementById("password").value
        },
        withCredentials: true,
        load: function (result) {
            login_info = JSON.parse(result);

            console.log(result);
            if (login_info == null) {
                alert("Bad login or password or other info : " + data);
            } else {
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
    console.log("logging out");

    dojo.xhr.get({
        url: "http://localhost:8080/logout",
        content: {},
        withCredentials: true,
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
        url: "http://localhost:8080/getlogin",
        content: {},
        withCredentials: true,
        load: function (result) {
            login_info = JSON.parse(result);

            console.log(result);
            if (login_info == null) {
                console.log("logged out");
                showLoggedOut();
            } else {
                console.log("logged in");
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