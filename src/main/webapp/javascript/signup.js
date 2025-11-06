document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("signupForm");
  const emailInput = form.querySelector("input[name='email']");
  const password = form.querySelector("input[name='password']");
  const confirm = form.querySelector("input[name='confirmPassword']");

  // Email live check debounce
  let debounceTimer;

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
      return false; // Assume available if error occurs
    }
  }

  emailInput.addEventListener("input", () => {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(async () => {
      const isTaken = await checkEmailAvailability(emailInput.value);
      const emailTakenError = form.querySelector(
        `p[data-error-for="email"][data-error-type="taken"]`
      );

      if (isTaken) {
        if (emailTakenError) emailTakenError.classList.remove("hidden");
        emailInput.classList.add("border-red-500", "focus:ring-red-500");
      } else {
        if (emailTakenError) emailTakenError.classList.add("hidden");
        emailInput.classList.remove("border-red-500", "focus:ring-red-500");
      }
    }, 600);
  });

  // Hide error messages when user types
  form.querySelectorAll("input").forEach((input) => {
    input.addEventListener("input", () => {
      const errors = form.querySelectorAll(
        `p[data-error-for="${input.name}"]`
      );
      errors.forEach((p) => p.classList.add("hidden"));
      input.classList.remove("border-red-500", "focus:ring-red-500");
    });
  });


  // Populate country codes
  const countrySelect = document.getElementById("countryCode");
  fetch("/ajirika/javascript/CountryCodes.json")
    .then((res) => res.json())
    .then((data) => {
      data.forEach((country) => {
        const option = document.createElement("option");
        option.value = country.dial_code;
        option.textContent = `${country.code} (${country.dial_code})`;
        option.setAttribute(
          "data-full-text",
          `${country.name} (${country.dial_code})`
        );
        countrySelect.appendChild(option);
      });
      countrySelect.value = "+254";

      // Full text on open
      countrySelect.addEventListener("mousedown", function () {
        Array.from(countrySelect.options).forEach((opt) => {
          opt.textContent = opt.getAttribute("data-full-text");
        });
      });

      // Revert to short format on change/blur
      const revertShort = () => {
        const selected = data.find((c) => c.dial_code === countrySelect.value);
        if (!selected) return;
        Array.from(countrySelect.options).forEach((opt) => {
          opt.textContent = `${opt.value === selected.dial_code
            ? selected.code
            : opt.getAttribute("data-full-text").split(" ")[0]
            } (${opt.value})`;
        });
      };
      countrySelect.addEventListener("change", revertShort);
      countrySelect.addEventListener("blur", revertShort);
    })
    .catch((err) => console.error("Error loading country codes:", err));

  // Form Submit Handler
  form.addEventListener("submit", async function (event) {
    event.preventDefault();
    let valid = true;

    // Reset all errors and input styles
    form.querySelectorAll("p.text-red-500").forEach((p) => p.classList.add("hidden"));
    form.querySelectorAll("input").forEach((input) => {
      input.classList.remove("border-red-500", "focus:ring-red-500");
    });

    // Required fields
    form.querySelectorAll("input[required]").forEach((input) => {
      if (!input.value.trim()) {
        valid = false;
        const requiredError = form.querySelector(
          `p[data-error-for="${input.name}"][data-error-type="required"]`
        );
        if (requiredError) requiredError.classList.remove("hidden");
        input.classList.add("border-red-500", "focus:ring-red-500");
      }
    });

    // Email format check (only if not empty)
    if (emailInput.value.trim()) {
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailPattern.test(emailInput.value.trim())) {
        valid = false;
        const emailFormatError = form.querySelector(
          `p[data-error-for="email"][data-error-type="format"]`
        );
        if (emailFormatError) emailFormatError.classList.remove("hidden");
        emailInput.classList.add("border-red-500", "focus:ring-red-500");
      }
    }

    // Password strength check (only if not empty)
    if (password.value.trim()) {
      const strongPasswordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
      if (!strongPasswordPattern.test(password.value)) {
        valid = false;
        const passwordStrengthError = form.querySelector(
          `p[data-error-for="password"][data-error-type="strength"]`
        );
        if (passwordStrengthError) passwordStrengthError.classList.remove("hidden");
        password.classList.add("border-red-500", "focus:ring-red-500");
      }
    }

    // Confirm password mismatch (only if both not empty)
    if (confirm.value.trim() && password.value.trim() && password.value !== confirm.value) {
      valid = false;
      const confirmMismatchError = form.querySelector(
        `p[data-error-for="confirmPassword"][data-error-type="mismatch"]`
      );
      if (confirmMismatchError) confirmMismatchError.classList.remove("hidden");
      confirm.classList.add("border-red-500", "focus:ring-red-500");
    }

    // Final email availability check (only if field not empty)
    if (emailInput.value.trim()) {
      const isEmailTaken = await checkEmailAvailability(emailInput.value.trim());
      if (isEmailTaken) {
        valid = false;
        const emailTakenError = form.querySelector(
          `p[data-error-for="email"][data-error-type="taken"]`
        );
        if (emailTakenError) emailTakenError.classList.remove("hidden");
        emailInput.classList.add("border-red-500", "focus:ring-red-500");
        emailInput.focus();
      }
    }

    if (valid) form.submit();
  });
});
