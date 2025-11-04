document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("signupForm");

  form.addEventListener("submit", function (event) {
    event.preventDefault(); // stop form submission for now
    let valid = true;

    // Reset all errors
    form.querySelectorAll("p.text-red-500").forEach(p => p.classList.add("hidden"));
    form.querySelectorAll("input").forEach(input => {
      input.classList.remove("border-red-500", "focus:ring-red-500");
    });

    // === Validate required fields ===
    form.querySelectorAll("input[required]").forEach(input => {
      if (!input.value.trim()) {
        valid = false;
        const error = input.parentElement.querySelector("p.text-red-500");
        if (error) error.classList.remove("hidden");
        input.classList.add("border-red-500", "focus:ring-red-500");
      }
    });

    // === Email validation ===
    const email = form.querySelector("input[name='email']");
    const emailError =
      email.parentElement.querySelector("p.text-red-500") ||
      document.createElement("p");

    if (!emailError.classList.contains("text-red-500")) {
      emailError.classList.add("text-red-500", "text-sm", "mt-1", "hidden");
      email.parentElement.appendChild(emailError);
    }

    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!email.value.trim()) {
      valid = false;
      emailError.textContent = "Email is required.";
      emailError.classList.remove("hidden");
      email.classList.add("border-red-500", "focus:ring-red-500");
    } else if (!emailPattern.test(email.value.trim())) {
      valid = false;
      emailError.textContent = "Please enter a valid email (e.g. user@example.com)";
      emailError.classList.remove("hidden");
      email.classList.add("border-red-500", "focus:ring-red-500");
    }

    const password = form.querySelector("input[name='password']");
    const confirm = form.querySelector("input[name='confirmPassword']");
    const passwordError = password.parentElement.querySelector("p.text-red-500");

    const strongPasswordPattern =
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;

    if (!password.value.trim()) {
      valid = false;
      passwordError.textContent = "Password is required.";
      passwordError.classList.remove("hidden");
      password.classList.add("border-red-500", "focus:ring-red-500");
    } else if (!strongPasswordPattern.test(password.value)) {
      valid = false;
      passwordError.textContent =
        "Password must be at least 8 characters and include uppercase, lowercase, number, and special character.";
      passwordError.classList.remove("hidden");
      password.classList.add("border-red-500", "focus:ring-red-500");
    }

    // === Confirm password ===
    const confirmError = confirm.parentElement.querySelector("p.text-red-500");
    if (!confirm.value.trim()) {
      valid = false;
      confirmError.textContent = "Please confirm your password.";
      confirmError.classList.remove("hidden");
      confirm.classList.add("border-red-500", "focus:ring-red-500");
    } else if (password.value !== confirm.value) {
      valid = false;
      confirmError.textContent = "Passwords do not match.";
      confirmError.classList.remove("hidden");
      confirm.classList.add("border-red-500", "focus:ring-red-500");
    }

    // === Submit if valid ===
    if (valid) {
      form.submit();
    }
  });

  // === Hide error as user types ===
  form.querySelectorAll("input").forEach(input => {
    input.addEventListener("input", () => {
      input.classList.remove("border-red-500", "focus:ring-red-500");
      const error = input.parentElement.querySelector("p.text-red-500");
      if (error) error.classList.add("hidden");
    });
  });
});

