<%@ Page Title="Home - knead. Culinary LMS" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="KneadLMS.DefaultPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/default.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Main Hero Section -->
  <section class="hero-section">
    <div class="hero-content">
      <h1>Learn What You Need, One Cuisine at a Time</h1>
      <p>Master the culinary arts through structured progress, hands-on tutorials, and a community of passionate learners. Your journey to professional cooking starts here.</p>
      <div class="hero-actions">
        <a href="ItemList.aspx" class="btn-primary">Start Learning</a>
        <a href="ItemList.aspx" class="btn-outline">Browse Cuisines</a>
      </div>
    </div>
    <div class="hero-image-wrapper">
      <img src='<%= ResolveUrl("~/images/hero_cooking.jpg") %>' alt="Passionate home cooks preparing meals together in a modern kitchen" />
    </div>
  </section>

  <!-- Statistics Banner -->
  <section class="stats-banner">
    <div class="stats-grid">
      <div class="stat-item">
        <h3><asp:Literal ID="litCuisineCount" runat="server">5</asp:Literal>+</h3>
        <p>Cuisines</p>
      </div>
      <div class="stat-item">
        <h3><asp:Literal ID="litCourseTypeCount" runat="server">5</asp:Literal>+</h3>
        <p>Course Types</p>
      </div>
      <div class="stat-item">
        <h3><asp:Literal ID="litRecipeCount" runat="server">10</asp:Literal>+</h3>
        <p>Tutorials</p>
      </div>
      <div class="stat-item">
        <h3><asp:Literal ID="litUserCount" runat="server">10k</asp:Literal>+</h3>
        <p>Members</p>
      </div>
    </div>
  </section>

  <!-- Browse by Cuisine Section -->
  <section class="cuisine-section">
    <div class="section-header">
      <h2>Browse by Cuisine</h2>
      <a href="ItemList.aspx" class="view-all-link">
        View All
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M5 12h14M12 5l7 7-7 7"/>
        </svg>
      </a>
    </div>

    <div class="cuisine-grid">
      <asp:Repeater ID="rptCuisines" runat="server">
        <ItemTemplate>
          <a href='<%# "ItemList.aspx?cuisineId=" + Eval("CuisineID") %>' class="cuisine-card">
            <div class="cuisine-img-box">
              <img src='<%# GetImageUrl(Eval("ImageURL")) %>' alt='<%# Eval("CuisineName") %>' />
            </div>
            <h4><%# Eval("CuisineName") %></h4>
          </a>
        </ItemTemplate>
      </asp:Repeater>
    </div>
  </section>
</asp:Content>
