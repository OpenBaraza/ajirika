const navbar = document.getElementById("navbar");
const mobileMenuBtn = document.getElementById("mobileMenuBtn");
const mobileMenu = document.getElementById("mobileMenu");
const heroGetInvolvedBtn = document.getElementById("heroGetInvolvedBtn");
const ctaJoinBtn = document.getElementById("ctaJoinBtn");
const hrModal = document.getElementById("hrModal");
const hrToast = document.getElementById("toast");
const menuIcon = mobileMenuBtn.querySelector("#menuIcon");
const closeIcon = mobileMenuBtn.querySelector("#closeIcon");
const mobileLinks = mobileMenu.querySelectorAll("a");
const observerOptions = {
  threshold: 0.1,
  rootMargin: "0px 0px -50px 0px",
};

const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add("revealed");
    }
  });
}, observerOptions);

document.querySelectorAll(".scroll-reveal").forEach((el) => {
  observer.observe(el);
});

window.addEventListener("scroll", () => {
  const currentScroll = window.pageYOffset;

  if (currentScroll > 50) {
    navbar.classList.add("navbar-scrolled");
  } else {
    navbar.classList.remove("navbar-scrolled");
  }
});

if (mobileMenuBtn && mobileMenu) {
  mobileMenuBtn.addEventListener("click", (e) => {
    e.preventDefault();
    e.stopPropagation();
    mobileMenu.classList.toggle("hidden");
  });

  // Close mobile menu when clicking on links
  mobileLinks.forEach((link) => {
    link.addEventListener("click", () => {
      mobileMenu.classList.add("hidden");
    });
  });

  // Close mobile menu when clicking outside
  document.addEventListener("click", (e) => {
    if (!mobileMenu.contains(e.target) && !mobileMenuBtn.contains(e.target)) {
      mobileMenu.classList.add("hidden");
    }
  });
}

// Modal functionality
if (heroGetInvolvedBtn) {
  heroGetInvolvedBtn.addEventListener("click", () => {
    hrModal.classList.remove("hidden");
  });
}

if (ctaJoinBtn) {
  ctaJoinBtn.addEventListener("click", () => {
    hrModal.classList.remove("hidden");
  });
}

const hrCloseBtn = document.getElementById("hrCloseBtn");
if (hrCloseBtn) {
  hrCloseBtn.addEventListener("click", () => {
    hrModal.classList.add("hidden");
  });
}

window.addEventListener("click", (e) => {
  if (e.target === hrModal) {
    hrModal.classList.add("hidden");
  }
});

// Toast handling (auto-hide after 3s)
if (hrToast && hrToast.classList.contains("opacity-100")) {
  setTimeout(() => {
    hrToast.classList.remove("opacity-100", "translate-y-0");
    hrToast.classList.add("opacity-0", "-translate-y-4");

    // After fade animation completes, hide it completely
    setTimeout(() => {
      hrToast.classList.add("hidden");
      hrToast.style.pointerEvents = "none";
    }, 500);
  }, 3000);
}

if (hrToast && !hrToast.classList.contains("opacity-100")) {
  hrToast.classList.add("hidden");
  hrToast.style.pointerEvents = "none";
}

// Remove ?success=true from URL after showing toast
window.addEventListener("DOMContentLoaded", () => {
  const url = new URL(window.location);
  if (url.searchParams.get("success") === "true") {
    url.searchParams.delete("success");
    window.history.replaceState({}, document.title, url.pathname);
  }
});
