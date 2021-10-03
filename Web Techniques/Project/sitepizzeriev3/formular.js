window.onload = function () {
  const form = document.getElementById('form');
  const username = document.getElementById('username');
  const email = document.getElementById('email');
  const password = document.getElementById('password');
  const password2 = document.getElementById('password2');

  form.addEventListener('submit', e => {
    e.preventDefault();
    checkInputs();
  });

  function checkInputs() {
    // trim to remove the whitespaces
    const usernameValue = username.value.trim();
    const emailValue = email.value.trim();
    const passwordValue = password.value.trim();
    const password2Value = password2.value.trim();

    if (usernameValue === '') {
      setErrorFor(username, 'Completati cu un username!');
    } else {
      setSuccessFor(username);
    }

    if (emailValue === '') {
      setErrorFor(email, 'Completati cu un email!');
    } else if (!isEmail(emailValue)) {
      setErrorFor(email, 'Email-ul nu este valid!');
    } else {
      setSuccessFor(email);
    }

    if (passwordValue === '') {
      setErrorFor(password, 'Completati cu o parola!');
    } else {
      setSuccessFor(password);
    }

    if (password2Value === '') {
      setErrorFor(password2, 'Completati cu o parola!');
    } else if (passwordValue !== password2Value) {
      setErrorFor(password2, 'Parolele nu corespund!');
    } else {
      setSuccessFor(password2);
    }
  }
  function setErrorFor(input, message) {
    const formControl = input.parentElement;
    const small = formControl.querySelector('small');
    formControl.className = 'form-control error';
    small.innerText = message;
  }
  function setSuccessFor(input) {
    const formControl = input.parentElement;
    formControl.className = 'form-control success';
  }
  function isEmail(email) {
    return /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email);
  }
}