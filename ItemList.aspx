<%@ Page Title="Browse Cuisines & Recipes - knead. Culinary LMS" Language="C#" MasterPageFile="~/Site.Master"
  AutoEventWireup="true" CodeBehind="ItemList.aspx.cs" Inherits="KneadLMS.ItemList" %>

  <asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="styles/item-list.css" />
  </asp:Content>

  <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <main class="cuisine-section" style="padding-top: 40px; min-height: 80vh;">

      <div class="welcome-header" style="margin-bottom: 28px;">
        <h1>Explore Cuisines & Recipes</h1>
        <p>Discover world-class recipes, master fundamental techniques, and build your culinary skills step-by-step.</p>
      </div>

      <!-- Search & Filter Bar -->
      <div class="forum-top-controls" style="margin-bottom: 32px; gap: 16px; flex-wrap: wrap; align-items: center;">
        <div class="forum-search-box" style="flex: 1; min-width: 250px;">
          <svg class="forum-search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="2">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          <asp:TextBox ID="txtSearch" runat="server" placeholder="Search cuisines, recipes, or ingredients..."
            AutoPostBack="true" OnTextChanged="btnSearch_Click"></asp:TextBox>
        </div>

        <asp:DropDownList ID="ddlCuisineFilter" runat="server" AutoPostBack="true"
          OnSelectedIndexChanged="ddlCuisineFilter_SelectedIndexChanged" CssClass="form-control">
        </asp:DropDownList>

        <asp:DropDownList ID="ddlDifficultyFilter" runat="server" AutoPostBack="true"
          OnSelectedIndexChanged="ddlCuisineFilter_SelectedIndexChanged" CssClass="form-control">
          <asp:ListItem Value="">Filter by Difficulty</asp:ListItem>
          <asp:ListItem Value="Beginner">Beginner</asp:ListItem>
          <asp:ListItem Value="Intermediate">Intermediate</asp:ListItem>
          <asp:ListItem Value="Advanced">Advanced</asp:ListItem>
        </asp:DropDownList>

        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="btn-primary" />
      </div>

      <!-- Cuisines / Recipes Grid -->
      <div style="margin-bottom: 24px;">
        <h3 style="font-size: 20px; font-weight: 700; margin-bottom: 16px;">
          <asp:Literal ID="litSectionTitle" runat="server">Available Recipes</asp:Literal>
        </h3>
      </div>

      <div class="cuisine-grid">
        <asp:Repeater ID="rptRecipes" runat="server">
          <ItemTemplate>
            <a href='<%# "RecipeDetail.aspx?recipeId=" + Eval("RecipeID") %>' class="cuisine-card"
              style="text-decoration: none; color: inherit;">
              <div class="cuisine-img-box">
                <img
                  src='<%# GetImageUrl(Eval("Thumbnail")) %>'
                  alt='<%# Eval("RecipeTitle") %>' />
              </div>
              <h4 style="margin-top: 12px; font-size: 16px; font-weight: 700;">
                <%# Eval("RecipeTitle") %>
              </h4>
              <p style="font-size: 13px; color: var(--text-muted); padding: 4px 6px 8px;">
                <%# Eval("Duration") %> mins • <%# Eval("CuisineName") %> Flavors
              </p>
            </a>
          </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoResults" runat="server" Visible="false"
          Style="grid-column: 1 / -1; text-align: center; padding: 40px; background: white; border-radius: 16px;">
          <p style="font-size: 16px; color: var(--text-muted);">No recipes found matching your search criteria.</p>
        </asp:Panel>
      </div>

    </main>
  </asp:Content>