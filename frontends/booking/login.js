function login() {
    document.getElementById("loggedIn").style.display = 'block';
    document.getElementById("loggedOut").style.display = 'none';
}

function logout() {
    document.getElementById("loggedIn").style.display = 'none';
    document.getElementById("loggedOut").style.display = 'block';

}

function checkLogin() {
    logout() ;
}