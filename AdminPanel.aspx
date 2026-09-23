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
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <rect x="3" y="3" width="7" height="7" rx="1"></rect>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <rect x="14" y="3" width="7" height="7" rx="1"></rect>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <rect x="14" y="14" width="7" height="7" rx="1"></rect>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <rect x="3" y="14" width="7" height="7" rx="1"></rect>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </svg>
          Overview &amp; Metrics
        </asp:LinkButton>

        <asp:LinkButton ID="btnNavCuisines" runat="server" OnClick="btnNavCuisines_Click" CssClass="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </svg>
          Manage Cuisines &amp; Courses
        </asp:LinkButton>

        <asp:LinkButton ID="btnNavRecipes" runat="server" OnClick="btnNavRecipes_Click" CssClass="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </svg>
          Manage Recipes &amp; Steps
        </asp:LinkButton>

        <asp:LinkButton ID="btnNavQuizzes" runat="server" OnClick="btnNavQuizzes_Click" CssClass="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <circle cx="12" cy="12" r="10"></circle>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <polyline points="12 6 12 12 16 14"></polyline>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </svg>
          Manage Quizzes &amp; Questions
        </asp:LinkButton>
      </nav>
    </aside>

    <!-- Admin Main Content -->
    <main class="dashboard-main">
      
      <div class="welcome-header" style="display: flex; align-items: center; gap: 16px;">
        <div>
          <h1 style="margin: 0;">Admin Management Portal</h1>
          <p style="margin-top: 6px;">Manage platform cuisines, recipes, quiz questions, and monitor registered learners.</p>
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
          <div class="table-card">
            <div class="table-responsive">
              <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table" CellPadding="0">
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
        </div>
      </asp:Panel>

      <!-- CUISINES & COURSES PANEL -->
      <asp:Panel ID="pnlCuisines" runat="server" Visible="false">
        <div class="admin-card">
          <div class="section-header">
            <h3>Add New Cuisine</h3>
            <p class="muted">Create a cuisine and attach a representative image.</p>
          </div>

          <div class="form-grid" style="margin-top: 12px;">
            <div class="admin-form-group">
              <label>Cuisine Name</label>
              <asp:TextBox ID="txtNewCuisineName" runat="server" CssClass="form-control" placeholder="e.g. Thai"></asp:TextBox>
            </div>

            <div class="admin-form-group">
              <label>Image URL</label>
              <asp:TextBox ID="txtNewCuisineImg" runat="server" CssClass="form-control" placeholder="images/momo_dish.jpg"></asp:TextBox>
            </div>

            <div class="admin-form-group" style="grid-column: 1 / -1;">
              <label>Description (optional)</label>
              <asp:TextBox ID="txtNewCuisineDesc" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control"></asp:TextBox>
            </div>
          </div>

          <asp:HiddenField ID="hfEditCuisineId" runat="server" />
          <asp:Button ID="btnAddCuisine" runat="server" Text="Add Cuisine" OnClick="btnAddCuisine_Click" CssClass="btn-primary" Style="margin-top: 16px;" />

          <hr style="margin: 22px 0; border:none; border-top:1px solid var(--border-light);" />

          <div class="section-header" style="margin-bottom:12px;">
            <h3>Add Course Type</h3>
            <p class="muted">Add course types tied to a cuisine (e.g., Appetizer, Main, Dessert).</p>
          </div>

          <div class="form-grid">
            <div class="admin-form-group">
              <label>Select Cuisine</label>
              <asp:DropDownList ID="ddlCourseCuisine" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            <div class="admin-form-group">
              <label>Course Type Name</label>
              <asp:TextBox ID="txtCourseTypeName" runat="server" CssClass="form-control" placeholder="e.g. Appetizer"></asp:TextBox>
            </div>
          </div>
          <asp:Button ID="btnAddCourseType" runat="server" Text="Add Course Type" OnClick="btnAddCourseType_Click" CssClass="btn-primary" Style="margin-top: 12px;" />

          <div class="continue-learning-section" style="margin-top: 28px;">
            <h3>Existing Cuisines</h3>
            <div class="table-card">
              <div class="table-responsive">
                <asp:GridView ID="gvAdminCuisines" runat="server" AutoGenerateColumns="False" CssClass="table" CellPadding="0" DataKeyNames="CuisineID"
                  OnRowCommand="gvAdminCuisines_RowCommand" OnRowDeleting="gvAdminCuisines_RowDeleting">
                  <Columns>
                    <asp:BoundField DataField="CuisineID" HeaderText="ID" ReadOnly="True" />
                    <asp:TemplateField HeaderText="CUISINE">
                      <ItemTemplate><%# Eval("CuisineName") %></ItemTemplate>
                      <EditItemTemplate>
                        <asp:TextBox ID="txtEditCuisineName" runat="server" Text='<%# Bind("CuisineName") %>' CssClass="form-control" />
                      </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="CourseCount" HeaderText="COURSES" ReadOnly="True" />
                    <asp:TemplateField HeaderText="DESCRIPTION">
                      <ItemTemplate><%# Eval("Description") %></ItemTemplate>
                      <EditItemTemplate>
                        <asp:TextBox ID="txtEditCuisineDesc" runat="server" Text='<%# Bind("Description") %>' CssClass="form-control" />
                      </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ACTIONS" HeaderStyle-CssClass="actions-header">
                      <ItemStyle CssClass="actions-col" />
                      <ItemTemplate>
                        <div class="grid-actions">
                          <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditCuisine" CommandArgument='<%# Eval("CuisineID") %>' CssClass="grid-btn edit">Edit</asp:LinkButton>
                          <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteCuisine" CommandArgument='<%# Eval("CuisineID") %>' OnClientClick="return confirm('Are you sure you want to delete this cuisine?');" CssClass="grid-btn delete">Delete</asp:LinkButton>
                        </div>
                      </ItemTemplate>
                    </asp:TemplateField>
                  </Columns>
                </asp:GridView>
              </div>
            </div>
          </div>
        </div>
      </asp:Panel>

      <!-- RECIPES & STEPS PANEL -->
      <asp:Panel ID="pnlRecipes" runat="server" Visible="false">
      <!-- Media Manager removed -->

        <div class="admin-card">
          <div class="section-header">
            <h3>Create New Recipe</h3>
            <p class="muted">Add recipes and link them to cuisines and course types.</p>
          </div>

          <div class="form-grid" style="margin-top: 12px;">
            <div class="admin-form-group">
              <label>Course Type</label>
              <asp:DropDownList ID="ddlRecipeCourseType" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>

            <div class="admin-form-group">
              <label>Recipe Title</label>
              <asp:TextBox ID="txtRecipeTitle" runat="server" CssClass="form-control" placeholder="e.g. Spicy Pad Thai"></asp:TextBox>
              <asp:Label ID="litRecipeEditHint" runat="server" EnableViewState="false" Visible="false" CssClass="muted" />
            </div>

            <div class="admin-form-group">
              <label>Duration (minutes)</label>
              <asp:TextBox ID="txtRecipeDuration" runat="server" TextMode="Number" CssClass="form-control" placeholder="30"></asp:TextBox>
            </div>

            <div class="admin-form-group">
              <label>Difficulty</label>
              <asp:DropDownList ID="ddlRecipeDifficulty" runat="server" CssClass="form-control">
                <asp:ListItem>Beginner</asp:ListItem>
                <asp:ListItem Selected="True">Intermediate</asp:ListItem>
                <asp:ListItem>Advanced</asp:ListItem>
              </asp:DropDownList>
            </div>

            <div class="admin-form-group">
              <label>Thumbnail URL</label>
              <asp:TextBox ID="txtRecipeThumb" runat="server" CssClass="form-control" placeholder="images/momo_dish.jpg"></asp:TextBox>
            </div>

            <div class="admin-form-group">
              <label>Upload Thumbnail (optional)</label>
              <asp:FileUpload ID="fuRecipeThumb" runat="server" CssClass="form-control" />
            </div>

            <div class="admin-form-group">
              <label>Video URL</label>
              <asp:TextBox ID="txtRecipeVideo" runat="server" CssClass="form-control" placeholder="https://youtube.com/..." ></asp:TextBox>
            </div>

            <div class="admin-form-group" style="grid-column: 1 / -1;">
              <label>Description</label>
              <asp:TextBox ID="txtRecipeDesc" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="admin-form-group" style="grid-column: 1 / -1;">
              <label>Ingredients (Separated by | pipe symbol)</label>
              <asp:TextBox ID="txtRecipeIngredients" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" placeholder="2 cups Flour|1 tsp Salt|3 Eggs"></asp:TextBox>
            </div>
          </div>

          <asp:HiddenField ID="hfEditRecipeId" runat="server" />
          <asp:Button ID="btnAddRecipe" runat="server" Text="Save Recipe" OnClick="btnAddRecipe_Click" CssClass="btn-primary" Style="margin-top: 16px;" />
        </div>

        <div class="admin-card" style="margin-top:18px;">
          <div class="section-header">
            <h3>Add Recipe Step</h3>
            <p class="muted">Add ordered instructions for a recipe.</p>
          </div>

          <div class="form-grid" style="margin-top:12px;">
            <div class="admin-form-group">
              <label>Select Recipe</label>
              <asp:DropDownList ID="ddlStepRecipe" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStepRecipe_SelectedIndexChanged" CssClass="form-control"></asp:DropDownList>
            </div>
            <div class="admin-form-group">
              <label>Step Number</label>
              <asp:TextBox ID="txtStepNumber" runat="server" TextMode="Number" CssClass="form-control" placeholder="1"></asp:TextBox>
            </div>
            <div class="admin-form-group" style="grid-column: 1 / -1;">
              <label>Instruction Text</label>
              <asp:TextBox ID="txtStepInstruction" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control"></asp:TextBox>
            </div>
          </div>
          <asp:Button ID="btnAddStep" runat="server" Text="Add Step" OnClick="btnAddStep_Click" CssClass="btn-primary" Style="margin-top: 12px;" />
        </div>

        <asp:HiddenField ID="hfEditStepId" runat="server" />

        <div class="continue-learning-section" style="margin-top: 18px;">
          <h4>Recipe Steps</h4>
          <div class="table-card">
            <div class="table-responsive">
              <asp:GridView ID="gvRecipeSteps" runat="server" AutoGenerateColumns="False" CssClass="table" CellPadding="0" DataKeyNames="StepID"
                OnRowCommand="gvRecipeSteps_RowCommand" OnRowDeleting="gvRecipeSteps_RowDeleting">
                <Columns>
                  <asp:BoundField DataField="StepNumber" HeaderText="#" />
                  <asp:BoundField DataField="Instruction" HeaderText="Instruction" />
                  <asp:TemplateField HeaderText="Actions" HeaderStyle-CssClass="actions-header">
                    <ItemStyle CssClass="actions-col" />
                    <ItemTemplate>
                      <div class="grid-actions">
                        <asp:LinkButton ID="lnkEditStep" runat="server" CommandName="EditStep" CommandArgument='<%# Eval("StepID") %>' CssClass="grid-btn edit">Edit</asp:LinkButton>
                        <asp:LinkButton ID="lnkUp" runat="server" CommandName="MoveUp" CommandArgument='<%# Eval("StepID") %>' CssClass="grid-btn">Up</asp:LinkButton>
                        <asp:LinkButton ID="lnkDown" runat="server" CommandName="MoveDown" CommandArgument='<%# Eval("StepID") %>' CssClass="grid-btn">Down</asp:LinkButton>
                        <asp:LinkButton ID="lnkDeleteStep" runat="server" CommandName="DeleteStep" CommandArgument='<%# Eval("StepID") %>' OnClientClick="return confirm('Delete this step?');" CssClass="grid-btn delete">Delete</asp:LinkButton>
                      </div>
                    </ItemTemplate>
                  </asp:TemplateField>
                </Columns>
              </asp:GridView>
            </div>
          </div>
        </div>

        <div class="continue-learning-section" style="margin-top: 28px;">
          <h3>Existing Recipes</h3>
          <div class="table-card">
            <div class="table-responsive">
              <asp:GridView ID="gvAdminRecipes" runat="server" AutoGenerateColumns="False" CssClass="table" CellPadding="0" DataKeyNames="RecipeID"
                OnRowCommand="gvAdminRecipes_RowCommand" OnRowEditing="gvAdminRecipes_RowEditing" OnRowCancelingEdit="gvAdminRecipes_RowCancelingEdit" OnRowUpdating="gvAdminRecipes_RowUpdating" OnRowDeleting="gvAdminRecipes_RowDeleting"
                OnRowDataBound="gvAdminRecipes_RowDataBound">
                <Columns>
                  <asp:BoundField DataField="RecipeID" HeaderText="ID" ReadOnly="True" />
                  <asp:TemplateField HeaderText="TITLE">
                    <ItemTemplate><%# Eval("RecipeTitle") %></ItemTemplate>
                    <EditItemTemplate>
                      <asp:TextBox ID="txtEditRecipeTitle" runat="server" Text='<%# Bind("RecipeTitle") %>' CssClass="form-control" />
                    </EditItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="CUISINE">
                    <ItemTemplate><%# Eval("CuisineName") %></ItemTemplate>
                    <EditItemTemplate>
                      <asp:Label ID="lblEditRecipeCuisine" runat="server" Text='<%# Eval("CuisineName") %>' CssClass="muted" />
                    </EditItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="COURSE">
                    <ItemTemplate><%# Eval("CourseTypeName") %></ItemTemplate>
                    <EditItemTemplate>
                      <asp:DropDownList ID="ddlEditRecipeCourseType" runat="server" CssClass="form-control" />
                    </EditItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="DURATION (MIN)">
                    <ItemTemplate><%# Eval("Duration") %></ItemTemplate>
                    <EditItemTemplate>
                      <asp:TextBox ID="txtEditRecipeDuration" runat="server" Text='<%# Bind("Duration") %>' CssClass="form-control" />
                    </EditItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="DIFFICULTY">
                    <ItemTemplate><%# Eval("Difficulty") %></ItemTemplate>
                    <EditItemTemplate>
                      <asp:DropDownList ID="ddlEditRecipeDifficulty" runat="server" CssClass="form-control">
                        <asp:ListItem>Beginner</asp:ListItem>
                        <asp:ListItem>Intermediate</asp:ListItem>
                        <asp:ListItem>Advanced</asp:ListItem>
                      </asp:DropDownList>
                    </EditItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="ACTIONS" HeaderStyle-CssClass="actions-header">
                    <ItemStyle CssClass="actions-col" />
                    <ItemTemplate>
                      <div class="grid-actions">
                        <asp:HyperLink ID="lnkEditR" runat="server" NavigateUrl='<%# "AdminPanel.aspx?editRecipe=" + Eval("RecipeID") %>' CssClass="grid-btn edit">Edit</asp:HyperLink>
                        <asp:LinkButton ID="lnkDeleteR" runat="server" CommandName="Delete" OnClientClick="return confirm('Delete this recipe?');" CssClass="grid-btn delete">Delete</asp:LinkButton>
                      </div>
                    </ItemTemplate>
                    <EditItemTemplate>
                      <div class="grid-actions">
                        <asp:LinkButton ID="lnkUpdateR" runat="server" CommandName="Update" CssClass="grid-btn save">Save</asp:LinkButton>
                        <asp:LinkButton ID="lnkCancelR" runat="server" CommandName="Cancel" CssClass="grid-btn cancel">Cancel</asp:LinkButton>
                      </div>
                    </EditItemTemplate>
                  </asp:TemplateField>
                </Columns>
              </asp:GridView>
            </div>
          </div>
        </div>
      </asp:Panel>

      <!-- QUIZZES & QUESTIONS PANEL -->
      <asp:Panel ID="pnlQuizzes" runat="server" Visible="false">
        <div class="admin-card">
          <div class="section-header">
            <h3>Create Quiz</h3>
            <p class="muted">Associate a quiz with a recipe and set passing criteria.</p>
          </div>

          <div class="form-grid" style="margin-top:12px;">
            <div class="admin-form-group">
              <label>Select Recipe</label>
              <asp:DropDownList ID="ddlQuizRecipe" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            <div class="admin-form-group">
              <label>Quiz Title</label>
              <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="form-control" placeholder="e.g. Pad Thai Technique Quiz"></asp:TextBox>
            </div>
            <div class="admin-form-group">
              <label>Passing Score %</label>
              <asp:TextBox ID="txtPassingScore" runat="server" TextMode="Number" Text="70" CssClass="form-control"></asp:TextBox>
            </div>
          </div>
          <asp:Button ID="btnAddQuiz" runat="server" Text="Create Quiz" OnClick="btnAddQuiz_Click" CssClass="btn-primary" Style="margin-top: 12px;" />
        </div>

        <div class="admin-card" style="margin-top: 18px;">
          <div class="section-header">
            <h3>Add Question to Quiz</h3>
            <p class="muted">Provide multiple choice questions and select the correct answer.</p>
          </div>

          <div class="form-grid" style="margin-top:12px;">
            <div class="admin-form-group" style="grid-column: 1 / -1;">
              <label>Select Quiz</label>
              <asp:DropDownList ID="ddlQuestionQuiz" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>

            <div class="admin-form-group" style="grid-column: 1 / -1;">
              <label>Question Text</label>
              <asp:TextBox ID="txtQuestionText" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="admin-form-group">
              <label>Option A</label>
              <asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="admin-form-group">
              <label>Option B</label>
              <asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="admin-form-group">
              <label>Option C</label>
              <asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="admin-form-group">
              <label>Option D</label>
              <asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="admin-form-group">
              <label>Correct Answer Choice</label>
              <asp:DropDownList ID="ddlCorrectAns" runat="server" CssClass="form-control">
                <asp:ListItem Value="A">Option A</asp:ListItem>
                <asp:ListItem Value="B">Option B</asp:ListItem>
                <asp:ListItem Value="C">Option C</asp:ListItem>
                <asp:ListItem Value="D">Option D</asp:ListItem>
              </asp:DropDownList>
            </div>
          </div>
          <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" OnClick="btnAddQuestion_Click" CssClass="btn-primary" Style="margin-top: 12px;" />
        </div>

        <div class="continue-learning-section" style="margin-top: 28px;">
          <h3>Existing Quizzes</h3>
          <div class="table-card">
            <div class="table-responsive">
              <asp:GridView ID="gvAdminQuizzes" runat="server" AutoGenerateColumns="False" CssClass="table" CellPadding="0" DataKeyNames="QuizID"
                OnRowEditing="gvAdminQuizzes_RowEditing" OnRowCancelingEdit="gvAdminQuizzes_RowCancelingEdit" OnRowUpdating="gvAdminQuizzes_RowUpdating" OnRowDeleting="gvAdminQuizzes_RowDeleting"
                OnRowDataBound="gvAdminQuizzes_RowDataBound">
                <Columns>
                  <asp:BoundField DataField="QuizID" HeaderText="ID" ReadOnly="True" />
                  <asp:TemplateField HeaderText="QUIZ TITLE">
                    <ItemTemplate><%# Eval("QuizTitle") %></ItemTemplate>
                    <EditItemTemplate>
                      <asp:TextBox ID="txtEditQuizTitle" runat="server" Text='<%# Bind("QuizTitle") %>' CssClass="form-control" />
                    </EditItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="RECIPE">
                    <ItemTemplate><%# Eval("RecipeTitle") %></ItemTemplate>
                    <EditItemTemplate>
                      <asp:DropDownList ID="ddlEditQuizRecipe" runat="server" CssClass="form-control" />
                    </EditItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="PASSING SCORE (%)">
                    <ItemTemplate><%# Eval("PassingScore") %></ItemTemplate>
                    <EditItemTemplate>
                      <asp:TextBox ID="txtEditPassingScore" runat="server" Text='<%# Bind("PassingScore") %>' CssClass="form-control" />
                    </EditItemTemplate>
                  </asp:TemplateField>
                  <asp:BoundField DataField="QuestionCount" HeaderText="QUESTIONS" ReadOnly="True" />
                  <asp:TemplateField HeaderText="ACTIONS" HeaderStyle-CssClass="actions-header">
                    <ItemStyle CssClass="actions-col" />
                    <ItemTemplate>
                      <div class="grid-actions">
                        <asp:LinkButton ID="lnkEditQ" runat="server" CommandName="Edit" CssClass="grid-btn edit">Edit</asp:LinkButton>
                        <asp:LinkButton ID="lnkDeleteQ" runat="server" CommandName="Delete" OnClientClick="return confirm('Delete this quiz?');" CssClass="grid-btn delete">Delete</asp:LinkButton>
                      </div>
                    </ItemTemplate>
                    <EditItemTemplate>
                      <div class="grid-actions">
                        <asp:LinkButton ID="lnkUpdateQ" runat="server" CommandName="Update" CssClass="grid-btn save">Save</asp:LinkButton>
                        <asp:LinkButton ID="lnkCancelQ" runat="server" CommandName="Cancel" CssClass="grid-btn cancel">Cancel</asp:LinkButton>
                      </div>
                    </EditItemTemplate>
                  </asp:TemplateField>
                </Columns>
              </asp:GridView>
            </div>
          </div>
        </div>
      </asp:Panel>

    </main>

  </div>
</asp:Content>
