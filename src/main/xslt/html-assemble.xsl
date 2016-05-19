<?xml version="1.0"?> 
<!-- 
  Generate the filelist of messages
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:xhtml="http://www.w3.org/1999/xhtml">

<!-- Generate Emails as indented XHTML documents -->
<xsl:output method="xhtml" media-type="application/html+xml" indent="yes"
 doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
 doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
 name="email"/>

<xsl:param name="from"/>

<xsl:template match="/">
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
    <xsl:for-each select="collection(concat($from, '?select=*.html'))">
      <xsl:apply-templates select="document(document-uri())//xhtml:html" mode="assemble">
        <xsl:with-param name="source" select="replace(replace(document-uri(), '/email/html/', '/build/message/'), 'html', 'xml')"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </body>
</html>
</xsl:template>


<xsl:template match="xhtml:html" mode="assemble">
<xsl:param name="source"/>
<div class="sdk-email">
 <xsl:variable name="notification" select="document($source)//notification"/>
  <div class="sdk-email-template">
    <h1 class="sdk-email-name"><xsl:value-of select="$notification/@template"/></h1>
  </div>
  <div class="sdk-email-template">
    <h2 class="sdk-email-description"><xsl:value-of select="$notification/@description"/></h2>
  </div>
  <xsl:apply-templates select="xhtml:head|xhtml:body" mode="email"/>
</div>
</xsl:template>

<!-- Display headers -->
<xsl:template match="xhtml:head" mode="email">
<div class="sdk-email-meta">
  <table>
    <xsl:for-each select="xhtml:meta[@name]">
      <tr><th><xsl:value-of select="@name"/></th><td><xsl:value-of select="@content"/></td></tr>
    </xsl:for-each>
  </table>
</div>
</xsl:template>

<!-- Copy the body -->
<xsl:template match="xhtml:body" mode="email">
<div class="sdk-email-wrapper">
  <xsl:for-each select="../xhtml:head/xhtml:title">
    <div class="sdk-email-title"><xsl:value-of select="."/></div>
  </xsl:for-each>
  <div class="sdk-email-body">
  <div style="{replace(@style, 'height: 100%', '')}">
    <xsl:copy-of select="@*[not(name() = 'style')]"/>
    <xsl:copy-of select="*|text()"/>
  </div>
  </div>
</div>
</xsl:template>

</xsl:stylesheet>