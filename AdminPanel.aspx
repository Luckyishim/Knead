<%@ Page Title="Admin Control Panel - knead. Culinary LMS" Language="C#" MasterPageFile="~/Profile.Master" AutoEventWireup="true" CodeFile="AdminPanel.aspx.cs" Inherits="KneadLMS.AdminPanel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/admin-panel.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <div class="dashboard-layout">
    
    <!-- Sidebar Navigation -->
    <aside class="dashboard-sidebar">
      <div class="user-profile-badge">
        <div class="user-avatar" style="background-color: var(--primary-orange); color: white; font-weight: 800;"><asp:Literal ID="litAdminInitials" runat="server">SA</asp:Literal></div>
        <div class="user-info">
          <h5><asp:Literal ID="litAdminName" runat="server">System Admin</asp:Literal></h5>
          <p><asp:Literal ID="litAdminRole" runat="server">System Administrator</asp:Literal></p>
        </div>
      </div>

      <nav class="sidebar-menu">
        <asp:LinkButton ID="btnNavOverview" runat="server" OnClick="btnNavOverview_Click" CssClass="menu-item active">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="3" width="7" height="7" rx="1"></rect>
            <rect x="14" y="3" width="7" height="7" rx="1"></rect>
            <rect x="14" y="14" width="7" height="7" rx="1"></rect>
            <rect x="3" y="14" width="7" height="7" rx="1"></rect>
          </svg>
          Overview & Metrics
        </asp:LinkButton>

        <asp:LinkButton ID="btnNavCuisines" runat="server" OnClick="btnNavCuisines_Click" CssClass="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
          </svg>
          Manage Cuisines & Courses
        </asp:LinkButton>

        <asp:LinkButton ID="btnNavRecipes" runat="server" OnClick="btnNavRecipes_Click" CssClass="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
          </svg>
          Manage Recipes & Steps
        </asp:LinkButton>

        <asp:LinkButton ID="btnNavQuizzes" runat="server" OnClick="btnNavQuizzes_Click" CssClass="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10"></circle>
            <polyline points="12 6 12 12 16 14"></polyline>
          </svg>
          Manage Quizzes & Questions
        </asp:LinkButton>
      </nav>
    </aside>

    <!-- Admin Main Content -->
    <main class="dashboard-main">
      
      <div class="welcome-header" style="display: flex; align-items: center; gap: 16px;">
        <a href="Default.aspx" class="quiz-back-btn" title="Back to Home" style="display: inline-flex; align-items: center; justify-content: center; width: 44px; height: 44px; border-radius: 50%; background: #F5EFEB; color: #1C1917; text-decoration: none; flex-shrink: 0;">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <path d="M19 12H5M12 19l-7-7 7-7"/>
          </svg>
        </a>
        <div>
          <h1 style="margin: 0;">Admin Management Portal</h1>
          <p style="margin-top: 4px;">Manage platform cuisines, recipes, quiz questions, and monitor registered learners.</p>
        </div>
      </div>

      <asp:Panel ID="pnlAdminMsg" runat="server" Visible="false" Style="padding: 14px; border-radius: 10px; margin-bottom: 20px; font-weight: 600;">
        <asp:Literal ID="litAdminMsg" runat="server"></asp:Literal>
      </asp:Panel>

      <!-- OVERVIEW PANEL -->
      <asp:Panel ID="pnlOverview" runat="server">
        <div class="dashboard-stats-grid">
          <div class="dashboard-stat-card">
            <div class="stat-card-top">Total Learners</div>
            <div class="stat-card-value"><asp:Literal ID="litTotalUsers" runat="server">0</asp:Literal></div>
          </div>
          <div class="dashboard-stat-card">
            <div class="stat-card-top">Active Cuisines</div>
            <div class="stat-card-value"><asp:Literal ID="litTotalCuisines" runat="server">0</asp:Literal></div>
          </div>
          <div class="dashboard-stat-card">
            <div class="stat-card-top">Total Recipes</div>
            <div class="stat-card-value"><asp:Literal ID="litTotalRecipes" runat="server">0</asp:Literal></div>
          </div>
          <div class="dashboard-stat-card">
            <div class="stat-card-top">Quiz Assessments</div>
            <div class="stat-card-value"><asp:Literal ID="litTotalQuizzes" runat="server">0</asp:Literal></div>
          </div>
        </div>

        <div class="continue-learning-section" style="margin-top: 28px;">
          <h3>Registered Users List</h3>
          <div class="ingredients-box" style="background: #FFFFFF; border-radius: 16px; overflow-x: auto;">
            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table" Style="width: 100%; border-collapse: collapse;" CellPadding="10">
              <Columns>
                <asp:BoundField DataField="UserID" HeaderText="ID" />
                <asp:BoundField DataField="FullName" HeaderText="FULL NAME" />
                <asp:BoundField DataField="Email" HeaderText="EMAIL" />
                <asp:BoundField DataField="Role" HeaderText="ROLE" />
                <asp:BoundField DataField="CreatedAt" HeaderText="JOINED DATE" DataFormatString="{0:yyyy-MM-dd}" />
              </Columns>
            </asp:GridView>
          </div>
        </div>
      </asp:Panel>

      <!-- CUISINES & COURSES PANEL -->
      <asp:Panel ID="pnlCuisines" runat="server" Visible="false">
        <div style="background: white; padding: 24px; border-radius: 16px; border: 1px solid var(--border-light); margin-bottom: 24px;">
          <h3>Add New Cuisine</h3>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 16px;">
            <div>
              <label style="font-weight: 600; font-size: 13px;">Cuisine Name</label>
              <asp:TextBox ID="txtNewCuisineName" runat="server" CssClass="form-control" placeholder="e.g. Thai" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Image URL</label>
              <asp:TextBox ID="txtNewCuisineImg" runat="server" CssClass="form-control" placeholder="images/momo_dish.jpg" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div style="grid-column: 1 / -1;">
              <label style="font-weight: 600; font-size: 13px;">Description</label>
              <asp:TextBox ID="txtNewCuisineDesc" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
          </div>
          <asp:Button ID="btnAddCuisine" runat="server" Text="Add Cuisine" OnClick="btnAddCuisine_Click" CssClass="btn-primary" Style="margin-top: 16px; padding: 10px 20px; cursor: pointer;" />
        </div>

        <div style="background: white; padding: 24px; border-radius: 16px; border: 1px solid var(--border-light);">
          <h3>Add Course Type</h3>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 16px;">
            <div>
              <label style="font-weight: 600; font-size: 13px;">Select Cuisine</label>
              <asp:DropDownList ID="ddlCourseCuisine" runat="server" CssClass="form-control" Style="width: 100%; padding: 8px;"></asp:DropDownList>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Course Type Name</label>
              <asp:TextBox ID="txtCourseTypeName" runat="server" CssClass="form-control" placeholder="e.g. Appetizer" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
          </div>
          <asp:Button ID="btnAddCourseType" runat="server" Text="Add Course Type" OnClick="btnAddCourseType_Click" CssClass="btn-primary" Style="margin-top: 16px; padding: 10px 20px; cursor: pointer;" />
        </div>
      </asp:Panel>

      <!-- RECIPES & STEPS PANEL -->
      <asp:Panel ID="pnlRecipes" runat="server" Visible="false">
        <div style="background: white; padding: 24px; border-radius: 16px; border: 1px solid var(--border-light); margin-bottom: 24px;">
          <h3>Create New Recipe</h3>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 16px;">
            <div>
              <label style="font-weight: 600; font-size: 13px;">Course Type</label>
              <asp:DropDownList ID="ddlRecipeCourseType" runat="server" CssClass="form-control" Style="width: 100%; padding: 8px;"></asp:DropDownList>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Recipe Title</label>
              <asp:TextBox ID="txtRecipeTitle" runat="server" CssClass="form-control" placeholder="e.g. Spicy Pad Thai" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Duration (minutes)</label>
              <asp:TextBox ID="txtRecipeDuration" runat="server" TextMode="Number" CssClass="form-control" placeholder="30" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Difficulty</label>
              <asp:DropDownList ID="ddlRecipeDifficulty" runat="server" CssClass="form-control" Style="width: 100%; padding: 8px;">
                <asp:ListItem>Beginner</asp:ListItem>
                <asp:ListItem Selected="True">Intermediate</asp:ListItem>
                <asp:ListItem>Advanced</asp:ListItem>
              </asp:DropDownList>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Thumbnail URL</label>
              <asp:TextBox ID="txtRecipeThumb" runat="server" CssClass="form-control" placeholder="images/momo_dish.jpg" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Video URL</label>
              <asp:TextBox ID="txtRecipeVideo" runat="server" CssClass="form-control" placeholder="https://youtube.com/..." Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div style="grid-column: 1 / -1;">
              <label style="font-weight: 600; font-size: 13px;">Description</label>
              <asp:TextBox ID="txtRecipeDesc" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div style="grid-column: 1 / -1;">
              <label style="font-weight: 600; font-size: 13px;">Ingredients (Separated by | pipe symbol)</label>
              <asp:TextBox ID="txtRecipeIngredients" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" placeholder="2 cups Flour|1 tsp Salt|3 Eggs" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
          </div>
          <asp:Button ID="btnAddRecipe" runat="server" Text="Save Recipe" OnClick="btnAddRecipe_Click" CssClass="btn-primary" Style="margin-top: 16px; padding: 10px 20px; cursor: pointer;" />
        </div>

        <div style="background: white; padding: 24px; border-radius: 16px; border: 1px solid var(--border-light);">
          <h3>Add Recipe Step</h3>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 16px;">
            <div>
              <label style="font-weight: 600; font-size: 13px;">Select Recipe</label>
              <asp:DropDownList ID="ddlStepRecipe" runat="server" CssClass="form-control" Style="width: 100%; padding: 8px;"></asp:DropDownList>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Step Number</label>
              <asp:TextBox ID="txtStepNumber" runat="server" TextMode="Number" CssClass="form-control" placeholder="1" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div style="grid-column: 1 / -1;">
              <label style="font-weight: 600; font-size: 13px;">Instruction Text</label>
              <asp:TextBox ID="txtStepInstruction" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
          </div>
          <asp:Button ID="btnAddStep" runat="server" Text="Add Step" OnClick="btnAddStep_Click" CssClass="btn-primary" Style="margin-top: 16px; padding: 10px 20px; cursor: pointer;" />
        </div>
      </asp:Panel>

      <!-- QUIZZES & QUESTIONS PANEL -->
      <asp:Panel ID="pnlQuizzes" runat="server" Visible="false">
        <div style="background: white; padding: 24px; border-radius: 16px; border: 1px solid var(--border-light); margin-bottom: 24px;">
          <h3>Create Quiz</h3>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 16px;">
            <div>
              <label style="font-weight: 600; font-size: 13px;">Select Recipe</label>
              <asp:DropDownList ID="ddlQuizRecipe" runat="server" CssClass="form-control" Style="width: 100%; padding: 8px;"></asp:DropDownList>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Quiz Title</label>
              <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="form-control" placeholder="e.g. Pad Thai Technique Quiz" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Passing Score %</label>
              <asp:TextBox ID="txtPassingScore" runat="server" TextMode="Number" Text="70" CssClass="form-control" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
          </div>
          <asp:Button ID="btnAddQuiz" runat="server" Text="Create Quiz" OnClick="btnAddQuiz_Click" CssClass="btn-primary" Style="margin-top: 16px; padding: 10px 20px; cursor: pointer;" />
        </div>

        <div style="background: white; padding: 24px; border-radius: 16px; border: 1px solid var(--border-light);">
          <h3>Add Question to Quiz</h3>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 16px;">
            <div style="grid-column: 1 / -1;">
              <label style="font-weight: 600; font-size: 13px;">Select Quiz</label>
              <asp:DropDownList ID="ddlQuestionQuiz" runat="server" CssClass="form-control" Style="width: 100%; padding: 8px;"></asp:DropDownList>
            </div>
            <div style="grid-column: 1 / -1;">
              <label style="font-weight: 600; font-size: 13px;">Question Text</label>
              <asp:TextBox ID="txtQuestionText" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Option A</label>
              <asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Option B</label>
              <asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Option C</label>
              <asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Option D</label>
              <asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control" Style="width: 100%; padding: 8px; box-sizing: border-box;"></asp:TextBox>
            </div>
            <div>
              <label style="font-weight: 600; font-size: 13px;">Correct Answer Choice</label>
              <asp:DropDownList ID="ddlCorrectAns" runat="server" CssClass="form-control" Style="width: 100%; padding: 8px;">
                <asp:ListItem Value="A">Option A</asp:ListItem>
                <asp:ListItem Value="B">Option B</asp:ListItem>
                <asp:ListItem Value="C">Option C</asp:ListItem>
                <asp:ListItem Value="D">Option D</asp:ListItem>
              </asp:DropDownList>
            </div>
          </div>
          <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" OnClick="btnAddQuestion_Click" CssClass="btn-primary" Style="margin-top: 16px; padding: 10px 20px; cursor: pointer;" />
        </div>
      </asp:Panel>

    </main>

  </div>
</asp:Content>
