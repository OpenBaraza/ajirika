document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("signupForm");
  const emailInput = form.querySelector("input[name='email']");
  const password = form.querySelector("input[name='password']");
  const confirm = form.querySelector("input[name='confirmPassword']");

  // Email availability check
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
      return false;
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
        emailTakenError?.classList.remove("hidden");
        emailInput.classList.add("border-red-500", "focus:ring-red-500");
      } else {
        emailTakenError?.classList.add("hidden");
        emailInput.classList.remove("border-red-500", "focus:ring-red-500");
      }
    }, 600);
  });

  // Clear errors on input
  form.querySelectorAll("input").forEach((input) => {
    input.addEventListener("input", () => {
      const errors = form.querySelectorAll(`p[data-error-for="${input.name}"]`);
      errors.forEach((p) => p.classList.add("hidden"));
      input.classList.remove("border-red-500", "focus:ring-red-500");
    });
  });

  // Form validation
  form.addEventListener("submit", async function (event) {
    event.preventDefault();
    let valid = true;

    // Reset errors
    form
      .querySelectorAll("p.text-red-500")
      .forEach((p) => p.classList.add("hidden"));
    form.querySelectorAll("input").forEach((input) => {
      input.classList.remove("border-red-500", "focus:ring-red-500");
    });

    // Required fields: firstname, surname, email, password, confirmPassword
    ["firstname", "surname", "email", "password", "confirmPassword"].forEach(
      (name) => {
        const input = form.querySelector(`input[name="${name}"]`);
        if (!input.value.trim()) {
          valid = false;
          const error = form.querySelector(
            `p[data-error-for="${name}"][data-error-type="required"]`
          );
          error?.classList.remove("hidden");
          input.classList.add("border-red-500", "focus:ring-red-500");
        }
      }
    );

    // Email format
    if (emailInput.value.trim()) {
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailPattern.test(emailInput.value.trim())) {
        valid = false;
        const error = form.querySelector(
          `p[data-error-for="email"][data-error-type="format"]`
        );
        error?.classList.remove("hidden");
        emailInput.classList.add("border-red-500", "focus:ring-red-500");
      }
    }

    // Password strength
    if (password.value.trim()) {
      const strongPasswordPattern =
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
      if (!strongPasswordPattern.test(password.value)) {
        valid = false;
        const error = form.querySelector(
          `p[data-error-for="password"][data-error-type="strength"]`
        );
        error?.classList.remove("hidden");
        password.classList.add("border-red-500", "focus:ring-red-500");
      }
    }

    // Password match
    if (
      confirm.value.trim() &&
      password.value.trim() &&
      password.value !== confirm.value
    ) {
      valid = false;
      const error = form.querySelector(
        `p[data-error-for="confirmPassword"][data-error-type="mismatch"]`
      );
      error?.classList.remove("hidden");
      confirm.classList.add("border-red-500", "focus:ring-red-500");
    }

    // Final email check
    if (emailInput.value.trim()) {
      const isEmailTaken = await checkEmailAvailability(
        emailInput.value.trim()
      );
      if (isEmailTaken) {
        valid = false;
        const error = form.querySelector(
          `p[data-error-for="email"][data-error-type="taken"]`
        );
        error?.classList.remove("hidden");
        emailInput.classList.add("border-red-500", "focus:ring-red-500");
      }
    }

    if (valid) form.submit();
  });
});
