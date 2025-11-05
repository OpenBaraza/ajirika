document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("signupForm");
  const emailInput = form.querySelector("input[name='email']");
  const password = form.querySelector("input[name='password']");
  const confirm = form.querySelector("input[name='confirmPassword']");

  // Locate or create the email error paragraph
  const emailError =
    emailInput.parentElement.querySelector("p.text-red-500") ||
    (() => {
      const p = document.createElement("p");
      p.className = "text-red-500 text-sm mt-1 hidden";
      emailInput.parentElement.appendChild(p);
      return p;
    })();

  // Check if email exists ===
  async function checkEmailAvailability(value) {
    value = value.trim();
    if (!value) return false;

    try {
      const res = await fetch(
        `${window.CTX}/checkEmail?email=${encodeURIComponent(value)}`
      );
      const text = await res.text();
      return text.trim() === "exists";
    } catch (err) {
      console.error("Email check error:", err);
      // If the service fails, assume email is available to avoid blocking signup
      return false;
    }
  }

  // Email live check with debounce
  let debounceTimer;
  emailInput.addEventListener("input", () => {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(async () => {
      const isTaken = await checkEmailAvailability(emailInput.value);
      if (isTaken) {
        emailError.textContent = "This email is already registered.";
        emailError.classList.remove("hidden");
        emailInput.classList.add("border-red-500", "focus:ring-red-500");
      } else {
        emailError.classList.add("hidden");
        emailInput.classList.remove("border-red-500", "focus:ring-red-500");
      }
    }, 600);
  });

  fetch("/ajirika/javascript/CountryCodes.json") // adjust path if needed
    .then((response) => response.json())
    .then((data) => {
      const select = document.getElementById("countryCode");
      data.forEach((country) => {
        const option = document.createElement("option");
        option.value = country.dial_code;
        option.textContent = `${country.name} (${country.dial_code})`;
        select.appendChild(option);
      });
      // Optional: set default to Kenya
      select.value = "+254";
    })
    .catch((error) => console.error("Error loading country codes:", error));

  // Form Submit Handler
  form.addEventListener("submit", async function (event) {
    event.preventDefault();
    let valid = true;

    // Reset all error messages and styles
    form
      .querySelectorAll("p.text-red-500")
      .forEach((p) => p.classList.add("hidden"));
    form.querySelectorAll("input").forEach((input) => {
      input.classList.remove("border-red-500", "focus:ring-red-500");
    });

    //Validate required fields
    form.querySelectorAll("input[required]").forEach((input) => {
      if (!input.value.trim()) {
        valid = false;
        const error = input.parentElement.querySelector("p.text-red-500");
        if (error) error.classList.remove("hidden");
        input.classList.add("border-red-500", "focus:ring-red-500");
      }
    });

    //Validate email format
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(emailInput.value.trim())) {
      valid = false;
      emailError.textContent = "Enter a valid email (example: user@mail.com)";
      emailError.classList.remove("hidden");
      emailInput.classList.add("border-red-500", "focus:ring-red-500");
    }

    //Validate password strength
    const strongPasswordPattern =
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
    const passwordError =
      password.parentElement.querySelector("p.text-red-500");
    if (!strongPasswordPattern.test(password.value)) {
      valid = false;
      passwordError.textContent =
        "Password must include uppercase, lowercase, number, special char, min 8 chars.";
      passwordError.classList.remove("hidden");
      password.classList.add("border-red-500", "focus:ring-red-500");
    }

    //Validate password match
    const confirmError = confirm.parentElement.querySelector("p.text-red-500");
    if (password.value !== confirm.value) {
      valid = false;
      confirmError.textContent = "Passwords do not match.";
      confirmError.classList.remove("hidden");
      confirm.classList.add("border-red-500", "focus:ring-red-500");
    }

    //Final email existence check
    if (valid) {
      const isEmailTaken = await checkEmailAvailability(
        emailInput.value.trim()
      );
      if (isEmailTaken) {
        valid = false;
        emailError.textContent = "This email is already registered.";
        emailError.classList.remove("hidden");
        emailInput.classList.add("border-red-500", "focus:ring-red-500");
        emailInput.focus();
      }
    }

    // Submit if all inputs are valid
    if (valid) {
      form.submit();
    }
  });
});
