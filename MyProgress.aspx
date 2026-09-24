<%@ Page Title="My Progress - knead. Culinary LMS" Language="C#" MasterPageFile="~/Profile.Master" AutoEventWireup="true" CodeBehind="MyProgress.aspx.cs" Inherits="KneadLMS.MyProgress" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/my-progress.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <div class="dashboard-layout">
    
    <!-- Sidebar Navigation -->
    <aside class="dashboard-sidebar">
      <div class="user-profile-badge">
        <div class="user-avatar" style="background: var(--primary-orange); color: white; border-radius: 50%; font-weight: 800; font-size: 16px;">
          <asp:Literal ID="litSidebarInitials" runat="server">U</asp:Literal>
        </div>
        <div class="user-info">
          <h5><asp:Literal ID="litSidebarName" runat="server">Member Portal</asp:Literal></h5>
          <p><asp:Literal ID="litSidebarRole" runat="server">Culinary Student</asp:Literal></p>
        </div>
      </div>

      <nav class="sidebar-menu">
        <a href="UserDashboard.aspx" class="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="3" width="7" height="7" rx="1"></rect>
            <rect x="14" y="3" width="7" height="7" rx="1"></rect>
            <rect x="14" y="14" width="7" height="7" rx="1"></rect>
            <rect x="3" y="14" width="7" height="7" rx="1"></rect>
          </svg>
          Dashboard
        </a>

        <a href="MyProgress.aspx" class="menu-item active">
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

    <!-- Main Content Area -->
    <main class="dashboard-main">
      <div class="welcome-header">
        <h1 style="margin: 0;">My Learning Progress</h1>
        <p style="margin-top: 4px;">Monitor your culinary learning milestones, completed masterclasses, and skill competencies.</p>
      </div>

      <div class="member-card-panel" style="background: white; border: 1px solid var(--border-light); border-radius: 18px; padding: 24px;">
        <h3 style="font-size: 20px; font-weight: 800; margin-bottom: 20px;">Enrolled Masterclasses & History</h3>
        <div class="learning-cards-list">
          <asp:Repeater ID="rptProgress" runat="server">
            <ItemTemplate>
              <div class="course-progress-card" style="margin-bottom: 16px;">
                <div class="course-thumb">
                  <img src='<%# GetImageUrl(Eval("Thumbnail")) %>' alt='<%# Eval("RecipeTitle") %>' />
                </div>
                <div class="course-info">
                  <span class="course-category"><%# Eval("CuisineName") %> • <%# Eval("CourseTypeName") %></span>
                  <h4 class="course-title"><%# Eval("RecipeTitle") %></h4>
                  <p class="course-module"><%# Convert.ToBoolean(Eval("IsCompleted")) ? (Eval("CompletedDate") != DBNull.Value && Eval("CompletedDate") != null ? "Completed on " + Convert.ToDateTime(Eval("CompletedDate")).ToString("MMM dd, yyyy") : "Completed ✓") : "In Progress" %></p>
                  <div class="progress-bar-container">
                    <div class="progress-track">
                      <div class="progress-fill" style='<%# Convert.ToBoolean(Eval("IsCompleted")) ? "width: 100%;" : "width: 50%;" %>'></div>
                    </div>
                    <a href='<%# "RecipeDetail.aspx?recipeId=" + Eval("RecipeID") %>' class="btn-dark"><%# Convert.ToBoolean(Eval("IsCompleted")) ? "Review" : "Resume" %></a>
                  </div>
                </div>
              </div>
            </ItemTemplate>
          </asp:Repeater>

          <asp:Panel ID="pnlNoProgress" runat="server" Visible="false" Style="padding: 40px; text-align: center; color: var(--text-muted); background: white; border-radius: 16px;">
            You have not started any lessons yet. <a href="ItemList.aspx" style="color: var(--primary-orange); font-weight: 700;">Explore Cuisines</a>
          </asp:Panel>
        </div>
      </div>
    </main>

  </div>
</asp:Content>
