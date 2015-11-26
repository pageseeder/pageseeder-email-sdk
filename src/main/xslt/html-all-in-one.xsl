<?xml version="1.0"?> 
<!-- 
  Generate all the HTML emails in one HTML file.
-->
<xsl:stylesheet version="2.0"
        xmlns:psf="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<!-- Import HTML templates -->
<xsl:import href="../template/html.xsl"/>

<!-- Generate Emails as indented XHTML documents -->
<xsl:output method="xhtml" media-type="application/html+xml" indent="no"
 doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
 doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
/>

<xsl:template match="filelist">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <style>

.sdk-email {
  border-top: #ccc solid 1px;
  background: #eee;
  padding: 1px;
}

.sdk-email-template {
  background: #ddd;
  margin: 0; 
  height: 2.5rem;
}

.sdk-email-name,.sdk-email-description {
  float:left;
  clear: both;
  font-family: Sans-serif; 
  font-size: 1.5rem;
  font-weight: normal;
  margin: 0; 
  padding: 0.4rem; 
}

.sdk-email-description {
  color: #999;
}

.sdk-email-meta {
  border-top: #ccc solid 1px;
  background: #eee; 
  font-family: Sans-serif; 
  font-size: 1rem; 
  margin: 0; 
  padding: 0.2rem; 
  font-style:normal
}
.sdk-email-meta table {
  margin: 0 auto;
  border-collapse: collapse;
  border: 1px solid #ccc;
}
.sdk-email-meta td, .sdk-email-meta th {
  text-align: left;
  background: #fff;
  font-size: .8rem;
  padding: .2rem .4rem;
  font-family: consolas;
}

.sdk-email-title {
  background: whitesmoke;
  font-family: Sans-serif; 
  font-size: 1rem;
  font-weight: bold;
  padding: .4rem;
  border-bottom: 1px solid #ddd;
}
.sdk-email-wrapper {
  background: white;
  margin: 2rem;
  box-shadow: 0 0 3px 3px rgba(0,0,0,.1)
}
    </style>
  </head>
  <body style="padding:0;margin:0">
  <xsl:for-each select="file">
    <xsl:apply-templates select="document(@href)"/>
  </xsl:for-each>
  </body>
</html>
</xsl:template>

<!-- 
  Sample messages contain multiple notifications 
-->
<xsl:template match="notifications">
<xsl:variable name="emails" as="element(email)*">
  <xsl:for-each select="notification">
    <!-- Each notification  -->
    <email name="{@template}" description="{@description}" position="{position()}">
      <xsl:apply-templates select="."/>
    </email>
  </xsl:for-each>
</xsl:variable>
<xsl:for-each select="$emails">
<div class="sdk-email">
  <xsl:if test="@position=1">
  <div class="sdk-email-template">
    <h1 class="sdk-email-name"><xsl:value-of select="@name"/></h1>
  </div>
  </xsl:if>
  <div class="sdk-email-template">
    <h2 class="sdk-email-description"><xsl:value-of select="@description"/></h2>
  </div>
  <xsl:apply-templates select="html" mode="email"/>
</div>
</xsl:for-each>
</xsl:template>

<!-- Display headers -->
<xsl:template match="head" mode="email">
<div class="sdk-email-meta">
  <table>
    <xsl:for-each select="meta[@name]">
      <tr><th><xsl:value-of select="@name"/></th><td><xsl:value-of select="@content"/></td></tr>
    </xsl:for-each>
  </table>
</div>

</xsl:template>

<!-- Copy the body -->
<xsl:template match="body" mode="email">
<div class="sdk-email-wrapper">
  <xsl:for-each select="../head/title">
    <div class="sdk-email-title"><xsl:value-of select="."/></div>
  </xsl:for-each>
  <div class="sdk-email-body">
  <div>
    <xsl:copy-of select="@*"/>
    <xsl:copy-of select="*|text"/>
  </div>
  </div>
</div>
</xsl:template>

</xsl:stylesheet>