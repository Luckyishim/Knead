<%@ Page Title="Saved Recipes - knead. Culinary LMS" Language="C#" MasterPageFile="~/Profile.Master" AutoEventWireup="true" CodeFile="SavedRecipes.aspx.cs" Inherits="KneadLMS.SavedRecipes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/saved-recipes.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Full Width Member Page Container Without Sidebar -->
  <main class="member-page-container">
    
    <div class="member-page-header">
      <h1>Your Saved Recipes & Bookmarks</h1>
      <p>Quick access to your bookmarked tutorials and recipes for reference in the kitchen.</p>
    </div>

    <!-- Saved Recipe Grid Card -->
    <div class="member-card-panel">
      <div class="cuisine-grid" style="grid-template-columns: repeat(3, 1fr); gap: 24px;">
        <asp:Repeater ID="rptSaved" runat="server">
          <ItemTemplate>
            <a href='<%# "RecipeDetail.aspx?recipeId=" + Eval("RecipeID") %>' class="cuisine-card" style="text-decoration: none; color: inherit;">
              <div class="cuisine-img-box" style="height: 180px;">
                <img src='<%# string.IsNullOrEmpty(Eval("Thumbnail").ToString()) ? "images/momo_dish.jpg" : Eval("Thumbnail") %>' alt='<%# Eval("RecipeTitle") %>' />
              </div>
              <h4 style="margin-top: 12px; font-size: 16px; font-weight: 700;"><%# Eval("RecipeTitle") %></h4>
              <p style="font-size: 13px; color: var(--primary-orange); font-weight: 600; padding: 4px 6px 2px;"><%# Eval("CuisineName") %> • <%# Eval("CourseTypeName") %></p>
              <p style="font-size: 12px; color: var(--text-muted); padding: 0 6px 8px;"><%# Eval("Duration") %> mins • Saved on <%# Convert.ToDateTime(Eval("AddedDate")).ToString("MMM dd, yyyy") %></p>
            </a>
          </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoSaved" runat="server" Visible="false" Style="grid-column: 1 / -1; text-align: center; padding: 40px; background: white; border-radius: 16px;">
          <p style="font-size: 16px; color: var(--text-muted);">You have not saved any recipes yet.</p>
          <a href="ItemList.aspx" class="btn-primary" style="display: inline-block; margin-top: 16px; text-decoration: none;">Browse Recipes</a>
        </asp:Panel>
      </div>
    </div>

  </main>
</asp:Content>
