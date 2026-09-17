/* ==========================================================================
   KNEAD CULINARY LMS - INTERACTIVE SCRIPT
   ========================================================================== */

document.addEventListener("DOMContentLoaded", () => {
  initNavigation();
  initHeaderScroll();
  initIngredientChecklist();
  initTabs();
  initQuizEngine();
  initForumFilters();
  initBookmarkToggle();
  initVideoPlayer();
});

/* Dynamic Navigation Bar Injector & Handler */
function initNavigation() {
  const headerContainer = document.querySelector(".site-header") || document.querySelector("nav.navBar");
  const currentPath = window.location.pathname.split("/").pop() || "Home.html";

  if (headerContainer && headerContainer.children.length === 0) {
    headerContainer.innerHTML = `
      <div class="navBar">
        <a href="Home.html" class="logo">
          <div class="logo-icon">k.</div>
          <div class="logo-text">
            <h4>knead<span>.</span></h4>
            <p>CULINARY LMS</p>
          </div>
        </a>

        <div class="nav-links">
          <a class="nav-link ${currentPath.includes("Home.html") || currentPath === "" || currentPath.includes("index.html") ? "active" : ""}" href="Home.html">Home</a>
          <a class="nav-link ${currentPath.includes("itemList.html") ? "active" : ""}" href="itemList.html">Cuisines</a>
          <a class="nav-link ${currentPath.includes("Forums.html") ? "active" : ""}" href="Forums.html">Forum</a>
          <a class="nav-link ${currentPath.includes("About.html") ? "active" : ""}" href="About.html">About</a>
        </div>

        <div class="nav-actions">
          <button class="icon-btn" title="Notifications" onclick="toggleNotifications()">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
              <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
            </svg>
            <span class="badge"></span>
          </button>
          <a href="login.html" class="login-btn">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
              <circle cx="12" cy="7" r="4"></circle>
            </svg>
            Login/Signup
          </a>
        </div>
      </div>
    `;
  }
}

/* Header sticky shadow effect */
function initHeaderScroll() {
  const header = document.querySelector(".site-header");
  if (!header) return;

  window.addEventListener("scroll", () => {
    if (window.scrollY > 20) {
      header.classList.add("scrolled");
    } else {
      header.classList.remove("scrolled");
    }
  });
}

/* Interactive Ingredient Checklist for Lesson Detail Page */
function initIngredientChecklist() {
  const checkboxes = document.querySelectorAll(".custom-checkbox");
  checkboxes.forEach(box => {
    box.addEventListener("click", () => {
      box.classList.toggle("checked");
      if (box.classList.contains("checked")) {
        box.innerHTML = `<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>`;
      } else {
        box.innerHTML = "";
      }
    });
  });
}

/* Detail Page Tabs Switching */
function initTabs() {
  const tabBtns = document.querySelectorAll(".tab-btn");
  const tabPanes = document.querySelectorAll(".tab-pane");

  tabBtns.forEach(btn => {
    btn.addEventListener("click", () => {
      tabBtns.forEach(b => b.classList.remove("active"));
      tabPanes.forEach(p => p.style.display = "none");

      btn.classList.add("active");
      const targetId = btn.getAttribute("data-tab");
      const targetPane = document.getElementById(targetId);
      if (targetPane) {
        targetPane.style.display = "block";
      }
    });
  });
}

/* Quiz Option Select & Interactive Counter */
function initQuizEngine() {
  const optionCards = document.querySelectorAll(".quiz-option-card");
  optionCards.forEach(card => {
    card.addEventListener("click", () => {
      optionCards.forEach(c => {
        c.classList.remove("selected");
        const radio = c.querySelector(".quiz-radio");
        if (radio) radio.innerHTML = "";
      });

      card.classList.add("selected");
      const radio = card.querySelector(".quiz-radio");
      if (radio) {
        radio.innerHTML = `<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>`;
      }
    });
  });
}

/* Forum Category Filtering & Modal Toggle */
function initForumFilters() {
  const categoryLinks = document.querySelectorAll(".category-link");
  const threadCards = document.querySelectorAll(".thread-card");

  categoryLinks.forEach(link => {
    link.addEventListener("click", (e) => {
      e.preventDefault();
      categoryLinks.forEach(l => l.classList.remove("active"));
      link.classList.add("active");

      const cat = link.getAttribute("data-category");
      threadCards.forEach(card => {
        if (cat === "all" || card.getAttribute("data-category") === cat) {
          card.style.display = "block";
        } else {
          card.style.display = "none";
        }
      });
    });
  });
}

/* Bookmark/Save button toggle */
function initBookmarkToggle() {
  const bookmarkBtns = document.querySelectorAll(".btn-save-recipe, .btn-action-outline");
  bookmarkBtns.forEach(btn => {
    if (btn.innerText.includes("Save")) {
      btn.addEventListener("click", () => {
        if (btn.classList.contains("saved")) {
          btn.classList.remove("saved");
          btn.style.color = "var(--text-main)";
          btn.style.borderColor = "var(--border-medium)";
        } else {
          btn.classList.add("saved");
          btn.style.color = "var(--primary-orange)";
          btn.style.borderColor = "var(--primary-orange)";
          btn.style.backgroundColor = "var(--primary-orange-light)";
        }
      });
    }
  });
}

/* Play button overlay trigger */
function initVideoPlayer() {
  const playBtn = document.querySelector(".play-button-center");
  if (playBtn) {
    playBtn.addEventListener("click", () => {
      alert("Tutorial Video Starting: Traditional Nepali Momos Masterclass!");
    });
  }
}

/* Notification Popup */
function toggleNotifications() {
  alert("🔔 Notifications:\n• You have 1 pending quiz: Knife Skills Mastery\n• ChefAnna replied to your forum post!");
}

/* Forum Modal Functions */
function openNewThreadModal() {
  const modal = document.getElementById("newThreadModal");
  if (modal) modal.classList.add("active");
}

function closeNewThreadModal() {
  const modal = document.getElementById("newThreadModal");
  if (modal) modal.classList.remove("active");
}