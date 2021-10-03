window.onload = function () {
  function greet_user() {
    var elements = document.getElementsByClassName('name-field');
    for (var i = 0; i < elements.length; i++) {
      elements[i].style.display = 'none';
    }
    document.getElementById("welcome-text").innerHTML = "Bună " + localStorage.name + ", bine ai venit!";
    document.getElementById("welcome-area").style.display = "block";
  }
  document.getElementById("submit-name").onclick = function () {
    var name = document.getElementById("name-user").value;
    if (!name) {
      alert("Vă rog introduceți un nume");
    }
    else {
      localStorage.setItem("name", name);
      greet_user();
    }
    document.getElementById("name-user").value = ""; //curatam campul
  }
  //if(localStorage.name){
  //    greet_user();
  //}
}
