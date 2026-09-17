<%@ Page Title="About Us - knead. Culinary LMS" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="About.aspx.cs" Inherits="KneadLMS.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/about.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <main class="detail-container" style="max-width: 900px; padding-top: 40px; min-height: 70vh;">
    <div class="welcome-header">
      <h1>About <span>knead.</span> Culinary LMS</h1>
      <p>Empowering passionate cooks and culinary students worldwide through structured learning, expert guidance, and community.</p>
    </div>

    <div style="background: #FFFFFF; border: 1px solid var(--border-light); border-radius: 20px; padding: 40px; box-shadow: var(--shadow-sm); line-height: 1.8; margin-top: 24px;">
      <h3 style="font-size: 24px; font-weight: 800; margin-bottom: 16px;">Our Mission</h3>
      <p style="color: var(--text-muted); margin-bottom: 24px;">
        Knead Culinary LMS was founded on the belief that culinary education should be accessible, structured, and engaging. Whether you're mastering the 5 French mother sauces, perfecting the pleats of Himalayan momos, or exploring sourdough hydration, our platform guides you step-by-step with high-definition video lessons, technique breakdowns, interactive quizzes, and a supportive community.
      </p>

      <h3 style="font-size: 24px; font-weight: 800; margin-bottom: 16px;">Why Knead?</h3>
      <ul style="margin-left: 20px; color: var(--text-muted); margin-bottom: 32px;">
        <li><strong>Structured Progression:</strong> Step-by-step modules tailored from foundational skills to advanced gastronomy.</li>
        <li><strong>Interactive Quizzes:</strong> Instant knowledge testing to reinforce techniques and theory.</li>
        <li><strong>Vibrant Community:</strong> Connect with fellow learners, share tips, troubleshooting emulsions, and sourdough starters.</li>
      </ul>

      <h3 style="font-size: 24px; font-weight: 800; margin-bottom: 16px;" id="contact">Get in Touch</h3>
      <p style="color: var(--text-muted);">Have questions or feedback? Contact our team at <a href="mailto:support@kneadculinary.com" style="color: var(--primary-orange); font-weight: 700;">support@kneadculinary.com</a></p>
    </div>
  </main>
</asp:Content>
