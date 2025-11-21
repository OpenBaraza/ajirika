function initializeCountryCodes() {
  const countrySelect = document.getElementById("countryCode");
  fetch("/ajirika/javascript/CountryCodes.json")
    .then((res) => res.json())
    .then((data) => {
      data.forEach((country) => {
        const option = document.createElement("option");
        option.value = country.dial_code;
        option.textContent = country.code + " (" + country.dial_code + ")";
        option.setAttribute(
          "data-full-text",
          country.name + " (" + country.dial_code + ")"
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
          const optionText = opt.value === selected.dial_code
            ? selected.code
            : opt.getAttribute("data-full-text").split(" ")[0];
          opt.textContent = optionText + " (" + opt.value + ")";
        });
      };
      countrySelect.addEventListener("change", revertShort);
      countrySelect.addEventListener("blur", revertShort);
    })
    .catch((err) => console.error("Error loading country codes:", err));
}

// Get DOM elements
const registerBtn = document.getElementById("registerBtn");
const registerModal = document.getElementById("registrationModal");
const registerCloseBtn = document.getElementById("registrationCloseModal");
const registerForm = document.getElementById("registrationForm");

// Initialize when modal opens
document.getElementById("registerBtn").addEventListener("click", () => {
  setTimeout(initializeCountryCodes, 100); // Delay to ensure DOM is ready
});
// Show modal
registerBtn.addEventListener("click", () => {
  registerModal.classList.remove("hidden");
});

// Close modal (X button)
registerCloseBtn.addEventListener("click", () => {
  registerModal.classList.add("hidden");
});

// Close modal when clicking outside content
registerModal.addEventListener("click", (e) => {
  if (e.target === registerModal) {
    registerModal.classList.add("hidden");
  }
});

// Form submission
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
    body: new URLSearchParams({ full_name: fullName, email_address: email, country_code: countryCode, phone_number: phone }),
  })
    .then(res => res.text())
    .then(msg => {
      alert(`Thank you, ${fullName}! You're registered for the Ajirika launch event.`);
      registerForm.reset();
      registerModal.classList.add("hidden");
    })
});