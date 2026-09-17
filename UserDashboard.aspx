<%@ Page Title="User Dashboard - knead. Culinary LMS" Language="C#" MasterPageFile="~/Profile.Master" AutoEventWireup="true" CodeFile="UserDashboard.aspx.cs" Inherits="KneadLMS.UserDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/user-dashboard.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <div class="dashboard-layout">
    
    <!-- Sidebar Navigation -->
    <aside class="dashboard-sidebar">
      <div class="user-profile-badge">
        <div class="user-avatar" style="background: var(--primary-orange); color: white; border-radius: 50%; font-weight: 800; font-size: 16px;">
          <asp:Literal ID="litSidebarInitials" runat="server">PH</asp:Literal>
        </div>
        <div class="user-info">
          <h5><asp:Literal ID="litSidebarName" runat="server">Member Portal</asp:Literal></h5>
          <p><asp:Literal ID="litSidebarRole" runat="server">Culinary Student</asp:Literal></p>
        </div>
      </div>

      <nav class="sidebar-menu">
        <a href="UserDashboard.aspx" class="menu-item active">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="3" width="7" height="7" rx="1"></rect>
            <rect x="14" y="3" width="7" height="7" rx="1"></rect>
            <rect x="14" y="14" width="7" height="7" rx="1"></rect>
            <rect x="3" y="14" width="7" height="7" rx="1"></rect>
          </svg>
          Dashboard
        </a>

        <a href="MyProgress.aspx" class="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="18" y1="20" x2="18" y2="10"></line>
            <line x1="12" y1="20" x2="12" y2="4"></line>
            <line x1="6" y1="20" x2="6" y2="14"></line>
          </svg>
          My Progress
        </a>

        <a href="SavedRecipes.aspx" class="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
          </svg>
          Saved Recipes
        </a>

        <a href="QuizHistory.aspx" class="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10"></circle>
            <polyline points="12 6 12 12 16 14"></polyline>
          </svg>
          Quiz History
        </a>

        <a href="AccountSettings.aspx" class="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="3"></circle>
            <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
          </svg>
          Account Settings
        </a>
      </nav>
    </aside>

    <!-- Dashboard Main Area -->
    <main class="dashboard-main">
      
      <!-- Welcome Header -->
      <div class="welcome-header">
        <h1 style="margin: 0;">Welcome back, <span><asp:Literal ID="litHeaderFirstName" runat="server">Chef</asp:Literal></span></h1>
        <p style="margin-top: 4px;">Ready to master some new dishes today?</p>
      </div>

      <!-- Key Metrics Stats Row -->
      <div class="dashboard-stats-grid">
        <div class="dashboard-stat-card">
          <div class="stat-card-top">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
            </svg>
            Cuisines in Progress
          </div>
          <div class="stat-card-value"><asp:Literal ID="litCuisinesInProgress" runat="server">3</asp:Literal></div>
        </div>

        <div class="dashboard-stat-card">
          <div class="stat-card-top">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
              <polyline points="14 2 14 8 20 8"></polyline>
              <line x1="16" y1="13" x2="8" y2="13"></line>
              <line x1="16" y1="17" x2="8" y2="17"></line>
            </svg>
            Tutorials Completed
          </div>
          <div class="stat-card-value"><asp:Literal ID="litCompletedCount" runat="server">12</asp:Literal></div>
        </div>

        <div class="dashboard-stat-card">
          <div class="stat-card-top">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6"></path>
              <path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18"></path>
              <path d="M4 22h16"></path>
              <path d="M10 14.66V17c0 .55-.47.98-.97 1.21C7.85 18.75 7 20.24 7 22"></path>
              <path d="M14 14.66V17c0 .55.47.98.97 1.21C16.15 18.75 17 20.24 17 22"></path>
              <path d="M18 2H6v7a6 6 0 0 0 12 0V2z"></path>
            </svg>
            Quiz Avg Score
          </div>
          <div class="stat-card-value"><asp:Literal ID="litAvgQuizScore" runat="server">92%</asp:Literal></div>
        </div>

        <div class="dashboard-stat-card">
          <div class="stat-card-top">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
            </svg>
            Forum Posts
          </div>
          <div class="stat-card-value"><asp:Literal ID="litForumTopicCount" runat="server">8</asp:Literal></div>
        </div>
      </div>

      <!-- Main Split Content Area -->
      <div class="dashboard-content-split">
        
        <!-- Left: Continue Learning -->
        <div class="continue-learning-section">
          <h3>Continue Learning</h3>
          
          <div class="learning-cards-list">
            <asp:Repeater ID="rptUserProgress" runat="server">
              <ItemTemplate>
                <div class="course-progress-card">
                  <div class="course-thumb">
                    <img src='<%# string.IsNullOrEmpty(Eval("Thumbnail").ToString()) ? "images/momo_dish.jpg" : Eval("Thumbnail") %>' alt='<%# Eval("RecipeTitle") %>' />
                  </div>
                  <div class="course-info">
                    <span class="course-category"><%# Eval("CuisineName") %></span>
                    <h4 class="course-title"><%# Eval("RecipeTitle") %></h4>
                    <p class="course-module"><%# Convert.ToBoolean(Eval("IsCompleted")) ? "Status: Completed ✓" : "Status: In Progress" %></p>
                    <div class="progress-bar-container">
                      <div class="progress-track">
                        <div class="progress-fill" style='<%# Convert.ToBoolean(Eval("IsCompleted")) ? "width: 100%;" : "width: 65%;" %>'></div>
                      </div>
                      <a href='<%# "RecipeDetail.aspx?recipeId=" + Eval("RecipeID") %>' class="btn-dark">Resume</a>
                    </div>
                    <div class="progress-meta">
                      <span><%# Convert.ToBoolean(Eval("IsCompleted")) ? "100% Completed" : "65% Completed" %></span>
                      <span>15 mins left</span>
                    </div>
                  </div>
                </div>
              </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoProgress" runat="server" Visible="false" Style="padding: 20px; text-align: center; color: var(--text-muted);">
              You have not started any recipe lessons yet. <a href="ItemList.aspx" style="color: var(--primary-orange); font-weight: 700;">Explore Cuisines</a>
            </asp:Panel>
          </div>
        </div>

        <!-- Right: Progress by Cuisine Widget -->
        <div class="progress-by-cuisine-widget">
          <h4>Progress by Cuisine</h4>
          
          <div class="cuisine-progress-item">
            <div class="cuisine-progress-label">
              <span>Nepali</span>
              <span>80%</span>
            </div>
            <div class="cuisine-progress-track">
              <div class="cuisine-progress-fill" style="width: 80%;"></div>
            </div>
          </div>

          <div class="cuisine-progress-item">
            <div class="cuisine-progress-label">
              <span>Italian</span>
              <span>45%</span>
            </div>
            <div class="cuisine-progress-track">
              <div class="cuisine-progress-fill" style="width: 45%;"></div>
            </div>
          </div>

          <div class="cuisine-progress-item">
            <div class="cuisine-progress-label">
              <span>Asian</span>
              <span>15%</span>
            </div>
            <div class="cuisine-progress-track">
              <div class="cuisine-progress-fill" style="width: 15%;"></div>
            </div>
          </div>

          <div class="cuisine-progress-item">
            <div class="cuisine-progress-label">
              <span>Baking Essentials</span>
              <span>60%</span>
            </div>
            <div class="cuisine-progress-track">
              <div class="cuisine-progress-fill" style="width: 60%;"></div>
            </div>
          </div>

        </div>

      </div>

    </main>
  </div>
</asp:Content>
