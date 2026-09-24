<%@ Page Title="Quiz History - knead. Culinary LMS" Language="C#" MasterPageFile="~/Profile.Master" AutoEventWireup="true" CodeBehind="QuizHistory.aspx.cs" Inherits="KneadLMS.QuizHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/quiz-history.css" />
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

        <a href="QuizHistory.aspx" class="menu-item active">
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
        <h1 style="margin: 0;">Quiz Attempt History</h1>
        <p style="margin-top: 4px;">Track your score achievements, test attempts, and certificate qualifications.</p>
      </div>

      <!-- Quiz History Data Table Card -->
      <div class="member-card-panel" style="background: white; border: 1px solid var(--border-light); border-radius: 18px; padding: 24px; margin-bottom: 24px;">
        <div class="history-table-wrapper">
          <asp:GridView ID="gvQuizHistory" runat="server" AutoGenerateColumns="False" CssClass="history-table">
            <Columns>
              <asp:TemplateField HeaderText="QUIZ ASSESSMENT">
                <ItemTemplate>
                  <strong><%# Eval("QuizTitle") %></strong>
                </ItemTemplate>
              </asp:TemplateField>

              <asp:BoundField DataField="RecipeTitle" HeaderText="RECIPE" />
              
              <asp:TemplateField HeaderText="SCORE (%)">
                <ItemTemplate>
                  <span style="font-weight: 800; color: <%# Convert.ToBoolean(Eval("Passed")) ? "#2D4C2A" : "#C26300" %>;">
                    <%# Eval("Score") %>%
                  </span>
                </ItemTemplate>
              </asp:TemplateField>

              <asp:TemplateField HeaderText="STATUS">
                <ItemTemplate>
                  <span class='<%# Convert.ToBoolean(Eval("Passed")) ? "status-pill passed" : "status-pill retry" %>'>
                    <%# Convert.ToBoolean(Eval("Passed")) ? "PASSED ✓" : "RETRY" %>
                  </span>
                </ItemTemplate>
              </asp:TemplateField>

              <asp:BoundField DataField="AttemptDate" HeaderText="DATE TAKEN" DataFormatString="{0:yyyy-MM-dd HH:mm}" />

              <asp:TemplateField HeaderText="ACTION">
                <ItemTemplate>
                  <%# Convert.ToBoolean(Eval("Passed")) ? 
                      "<button class=\"btn-action-outline\" style=\"padding: 4px 12px; font-size: 12px;\" onclick=\"alert('Certificate verified: " + Server.HtmlEncode(Eval("QuizTitle").ToString()) + " Completed!'); return false;\">🎓 Certificate</button>" : 
                      "<a href=\"QuizDetail.aspx?quizId=" + Eval("QuizID") + "\" class=\"btn-dark\" style=\"padding: 6px 14px; font-size: 12px; text-decoration: none;\">Retake Quiz</a>" %>
                </ItemTemplate>
              </asp:TemplateField>
            </Columns>
          </asp:GridView>

          <asp:Panel ID="pnlNoAttempts" runat="server" Visible="false" Style="padding: 30px; text-align: center; color: var(--text-muted);">
            You haven't taken any quizzes yet. <a href="Quizzes.aspx" style="color: var(--primary-orange); font-weight: 700;">Take a Quiz</a>
          </asp:Panel>
        </div>
      </div>

      <!-- Quick Start Quiz Banner -->
      <div style="background-color: #FAF0E4; border: 1.5px dashed var(--primary-orange); border-radius: 18px; padding: 24px; display: flex; align-items: center; justify-content: space-between; gap: 20px; flex-wrap: wrap;">
        <div>
          <h4 style="font-size: 18px; font-weight: 800; margin-bottom: 4px;">Ready to test your culinary skills?</h4>
          <p style="font-size: 14px; color: var(--text-muted);">Choose from available course assessments and earn verified culinary credentials.</p>
        </div>
        <a href="Quizzes.aspx" class="btn-primary">Start New Quiz →</a>
      </div>

    </main>

  </div>
</asp:Content>
