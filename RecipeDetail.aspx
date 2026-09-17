<%@ Page Title="Recipe Detail - knead. Culinary LMS" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="RecipeDetail.aspx.cs" Inherits="KneadLMS.RecipeDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/recipe-detail-page.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <main class="detail-container">
    
    <!-- Breadcrumb -->
    <div class="breadcrumb">
      <a href="ItemList.aspx">← Cuisines</a>
      <span>›</span>
      <asp:HyperLink ID="lnkBreadcrumbCuisine" runat="server">Cuisine</asp:HyperLink>
      <span>›</span>
      <span><asp:Literal ID="litBreadcrumbCourse" runat="server">Course</asp:Literal></span>
    </div>

    <!-- Title Header -->
    <h1 class="detail-header-title"><asp:Literal ID="litRecipeTitle" runat="server">Recipe Title</asp:Literal></h1>

    <!-- Meta Stats and Badges Row -->
    <div class="detail-meta-row">
      <div class="detail-meta-info">
        <span>⭐ <strong>4.9</strong> (Culinary Masterclass)</span>
        <span>•</span>
        <span>⏱️ <asp:Literal ID="litDuration" runat="server">45</asp:Literal> mins</span>
        <span>•</span>
        <span>👥 Active Learners</span>
        <div style="display: flex; gap: 6px; margin-left: 8px;">
          <span class="badge-tag"><asp:Literal ID="litCuisineBadge" runat="server">Nepali</asp:Literal></span>
          <span class="badge-tag"><asp:Literal ID="litCourseBadge" runat="server">Main</asp:Literal></span>
          <span class="badge-tag"><asp:Literal ID="litDifficultyBadge" runat="server">Intermediate</asp:Literal></span>
        </div>
      </div>

      <div class="detail-actions">
        <asp:Button ID="btnSaveFavorite" runat="server" Text="Save" OnClick="btnSaveFavorite_Click" CssClass="btn-action-outline btn-save-recipe" Style="cursor: pointer;" />
        <button type="button" class="btn-action-outline" onclick="navigator.clipboard.writeText(window.location.href); alert('Link copied to clipboard!');">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="18" cy="5" r="3"></circle>
            <circle cx="6" cy="12" r="3"></circle>
            <circle cx="18" cy="19" r="3"></circle>
            <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line>
            <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line>
          </svg>
          Share
        </button>
      </div>
    </div>

    <!-- Hero Video Player Container -->
    <div class="video-player-box">
      <asp:Image ID="imgThumbnail" runat="server" ImageUrl="images/momo_dish.jpg" AlternateText="Tutorial Video Thumbnail" />
      <div class="video-overlay-header">Masterclass Tutorial 🌶️</div>
      <div class="video-overlay-title">
        <asp:Literal ID="litVideoTitle" runat="server">Recipe Video Guide</asp:Literal><br/>
        <span style="font-size: 18px; font-weight: 600; text-transform: none; opacity: 0.9;">Authentic Culinary Technique</span>
      </div>
      <asp:HyperLink ID="lnkPlayVideo" runat="server" Target="_blank" CssClass="play-button-center" ToolTip="Play Video Masterclass">
        <svg width="32" height="32" viewBox="0 0 24 24" fill="currentColor">
          <polygon points="5 3 19 12 5 21 5 3"></polygon>
        </svg>
      </asp:HyperLink>
      <div class="video-duration-badge"><asp:Literal ID="litVideoDuration" runat="server">12:45</asp:Literal></div>
    </div>

    <!-- Tab Navigation -->
    <div class="detail-tab-nav">
      <button type="button" class="tab-btn active" data-tab="overview">Overview & Ingredients</button>
      <button type="button" class="tab-btn" data-tab="step-by-step">Step-by-Step Instructions</button>
      <button type="button" class="tab-btn" data-tab="forum">Discussions</button>
    </div>

    <!-- Tab Content Layout -->
    <div class="detail-content-layout">
      
      <!-- Left Main Column -->
      <div class="detail-left-pane">
        
        <!-- Overview Tab -->
        <div id="overview" class="tab-pane" style="display: block;">
          <p class="detail-main-text">
            <asp:Literal ID="litDescription" runat="server">Recipe description...</asp:Literal>
          </p>

          <!-- Chef's Secret Box -->
          <div class="chef-secret-card">
            <div class="chef-secret-header">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--primary-orange)" stroke-width="2">
                <path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"></path>
              </svg>
              Chef's Technique Tip
            </div>
            <p>
              Pre-measure all ingredients before starting. Rest dough and balance acidity to release optimal flavor notes!
            </p>
          </div>

          <!-- Ingredients Box -->
          <div class="ingredients-box">
            <h3>
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
              </svg>
              Ingredients Checklist
            </h3>

            <div class="ingredient-list">
              <asp:Repeater ID="rptIngredients" runat="server">
                <ItemTemplate>
                  <div class="ingredient-item">
                    <div class="custom-checkbox"></div>
                    <div class="ingredient-details">
                      <h5><%# Container.DataItem %></h5>
                    </div>
                  </div>
                </ItemTemplate>
              </asp:Repeater>
            </div>
          </div>

        </div>

        <!-- Step by Step Tab -->
        <div id="step-by-step" class="tab-pane" style="display: none;">
          <h3>Step-by-Step Preparation</h3>
          <div style="margin-top: 16px; display: flex; flex-direction: column; gap: 20px;">
            <asp:Repeater ID="rptSteps" runat="server">
              <ItemTemplate>
                <div style="background-color: #FFFDF9; border: 1px solid var(--border-light); border-radius: 12px; padding: 20px; display: flex; gap: 16px;">
                  <div style="width: 36px; height: 36px; border-radius: 50%; background-color: var(--primary-orange); color: white; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 16px; flex-shrink: 0;">
                    <%# Eval("StepNumber") %>
                  </div>
                  <div>
                    <p style="font-size: 15px; color: var(--text-dark); line-height: 1.6; margin: 0;"><%# Eval("Instruction") %></p>
                  </div>
                </div>
              </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoSteps" runat="server" Visible="false">
              <p style="color: var(--text-muted);">Step details coming soon!</p>
            </asp:Panel>
          </div>
        </div>

        <!-- Forum Tab -->
        <div id="forum" class="tab-pane" style="display: none;">
          <h3>Recipe Discussions</h3>
          <p style="margin-top: 8px; color: var(--text-muted);">Connect with fellow students learning this recipe.</p>
          <asp:HyperLink ID="lnkForumDiscussions" runat="server" CssClass="btn-primary" Style="display: inline-block; margin-top: 16px; text-decoration: none;" Text="View Discussion Threads"></asp:HyperLink>
        </div>

      </div>

      <!-- Right Sidebar -->
      <div class="detail-sidebar">
        
        <!-- Progress Widget -->
        <div class="progress-widget-card">
          <div class="progress-widget-header">
            <span>Your Progress</span>
            <span><asp:Literal ID="litProgressPercent" runat="server">0%</asp:Literal></span>
          </div>
          <div class="progress-track" style="margin-bottom: 16px;">
            <asp:Panel ID="pnlProgressFill" runat="server" CssClass="progress-fill" Style="width: 0%;"></asp:Panel>
          </div>

          <asp:Button ID="btnMarkComplete" runat="server" Text="Mark as Complete" OnClick="btnMarkComplete_Click" CssClass="btn-dark" Style="width: 100%; border: none; cursor: pointer; padding: 12px; margin-bottom: 8px;" />
          
          <asp:Label ID="lblStatusMessage" runat="server" Style="display: block; text-align: center; font-size: 13px; margin-top: 6px;" ForeColor="#059669"></asp:Label>
        </div>

        <!-- Quiz Widget -->
        <div class="quiz-callout-widget">
          <h4>Test Your Knowledge</h4>
          <p>Complete the recipe assessment to verify your skills!</p>
          <asp:HyperLink ID="lnkStartQuiz" runat="server" CssClass="btn-primary" Style="width: 100%; box-shadow: none; text-align: center; text-decoration: none; display: block; box-sizing: border-box; padding: 12px;">Start Quiz</asp:HyperLink>
        </div>

      </div>

    </div>

  </main>
</asp:Content>
