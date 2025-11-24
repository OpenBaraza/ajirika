// DOM Elements
const registerBtn = document.getElementById("registerBtn");
const registerModal = document.getElementById("registrationModal");
const registerCloseBtn = document.getElementById("registrationCloseModal");
const registerForm = document.getElementById("registrationForm");
const launchToast = document.getElementById("toast");

// Show modal when Register button is clicked
if (registerBtn) {
  registerBtn.addEventListener("click", () => {
    registerModal.classList.remove("hidden");
    // Initialize country codes when modal opens
    setTimeout(initializeCountryCodes, 100);
  });
}

// Close modal when X button is clicked
if (registerCloseBtn) {
  registerCloseBtn.addEventListener("click", () => {
    registerModal.classList.add("hidden");
  });
}

// Close modal when clicking outside the content
if (registerModal) {
  registerModal.addEventListener("click", (e) => {
    if (e.target === registerModal) {
      registerModal.classList.add("hidden");
    }
  });
}

// Form submission with toast
if (registerForm) {
  registerForm.addEventListener("submit", (e) => {
    e.preventDefault();

    // Get form values
    const fullName = document.getElementById("fullName").value;
    const email = document.getElementById("email").value;
    const countryCode = document.getElementById("countryCode").value;
    const phone = document.getElementById("phone").value;

    fetch(registerForm.getAttribute("action"), {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        full_name: fullName,
        email_address: email,
        country_code: countryCode,
        phone_number: phone,
      }),
    })
      .then((response) => response.text())
      .then(() => {
        // Show toast
        if (launchToast) {
          launchToast.classList.remove("opacity-0", "-translate-y-4");
          launchToast.classList.add("opacity-100", "translate-y-0");

          // Auto-hide toast after 3 seconds
          setTimeout(() => {
            launchToast.classList.remove("opacity-100", "translate-y-0");
            launchToast.classList.add("opacity-0", "-translate-y-4");
          }, 3000);
        }

        // Reset form and close modal
        registerForm.reset();
        registerModal.classList.add("hidden");
      })
      .catch((error) => {
        console.error("Form submission error:", error);
      });
  });
}

// Country codes initialization function
function initializeCountryCodes() {
  const countrySelect = document.getElementById("countryCode");
  if (!countrySelect || countrySelect.options.length > 1) return; // Already loaded

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
      countrySelect.value = "+254"; // Default to Kenya

      // Full text on open
      countrySelect.addEventListener("mousedown", () => {
        Array.from(countrySelect.options).forEach((opt) => {
          opt.textContent = opt.getAttribute("data-full-text");
        });
      });

      // Revert to short format on change/blur
      const revertShort = () => {
        const selected = data.find((c) => c.dial_code === countrySelect.value);
        if (!selected) return;
        Array.from(countrySelect.options).forEach((opt) => {
          const optionText =
            opt.value === selected.dial_code
              ? selected.code
              : opt.getAttribute("data-full-text").split(" ")[0];
          opt.textContent = `${optionText} (${opt.value})`;
        });
      };
      countrySelect.addEventListener("change", revertShort);
      countrySelect.addEventListener("blur", revertShort);
    })
    .catch((err) => console.error("Error loading country codes:", err));
}
