const loginForm = document.getElementById("loginForm");
const loginError = document.getElementById("loginError");
const emailInput = loginForm.email;
const passwordInput = loginForm.password;

// Hide error when user starts typing
[emailInput, passwordInput].forEach(input => {
  input.addEventListener("input", () => {
    loginError.classList.add("hidden");
  });
});

loginForm.addEventListener("submit", function (e) {
  e.preventDefault();

  const email = emailInput.value;
  const password = passwordInput.value;

  fetch('loginForm', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `email=${encodeURIComponent(email)}&password=${encodeURIComponent(password)}`
  })
    .then(res => res.text())
    .then(result => {
      if (result === "success") {
        window.location.href = "profile.jsp";
      } else {
        loginError.classList.remove("hidden");
      }
    });
});

