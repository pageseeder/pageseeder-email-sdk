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

body {
  background: #eee;
}

.sdk-email {
  background: #eee;
}

.sdk-email-template {
  background: #aaa;
  margin: 0; 
}

.sdk-email-name,.sdk-email-description {
  font-family: Sans-serif; 
  font-size: 1.5rem;
  font-weight: normal;
  margin: 0; 
  padding: 0.4rem; 
}

.help {
  font-family: sans-serif;
  text-align: center;
  font-size: 5rem;
  color: #ddd;
  margin-top: 30%;
  padding: 0;
  text-shadow: 1px 1px 1px rgba(0,0,0,.33);
}

.sdk-email-description {
  color: #444;
  font-style: italic;
  font-size: 1rem;
  padding: 0.25rem 0.4rem;
}

.sdk-email-description .no {
  color: white;
  float: left;
  width: 40px;
  height: 40px;
  padding: 10px;
  background: #00abba;
  border-radius: 1000px;
  box-sizing: border-box;
  margin-right: 1ex;
  margin-top: -10px;
  text-align: center;
  font-weight: bold;
}

.sdk-email-meta {
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

.sdk-nav {
  font-family: sans-serif;
  position: fixed;
  width: 25%;
  height: 100%;
  box-sizing: border-box;
  background: #333;
  box-shadow: inset -1ex 0 1ex -.5ex rgba(0,0,0,.5);
}

.sdk-nav h1 {
  margin-left: 13px;
  color: #777
}

.sdk-main {
  float:right;
  width: 75%;
  height: 100%;
}

.sdk-menu {
  list-style-type: none;
  padding: 0;
  margin: 0;
  height: 100%;
  overflow: auto;
}

.sdk-menu li {
  font-family: sans-serif;
  font-size: 13px;
  padding: 1ex 1em;
  border-bottom: 1px solid #777;
  color: #fff
}

.sdk-menu li:first-child {
  border-top: 1px solid #777;
}

.sdk-menu li:hover {
  background: #555;
}

.sdk-email-wrapper {
  max-width: 40em;
  margin: 0 auto
}

.sdk-plaintext {
  padding: 1em;
  word-wrap: break-word;
  white-space: pre-wrap;
}

.sdk-menu li label {
  cursor: pointer;
  background: #777;
  padding: 4px;
  border-radius: 1000px;
  width: 15px;
  height: 15px;
  display: inline-block;
  text-align: center;
  margin-left: 0.33ex;
}

.sdk-menu li label:hover {
  background: #00abba;
}

input[type='radio'], .sdk-email { 
  display: none;
}
input[type='radio']:checked + .sdk-email {
  display: block;
}

    </style>
  </head>
  <body style="padding:0;margin:0">
    <nav class="sdk-nav">
      <h1>Text email templates</h1>
      <ul class="sdk-menu">
        <xsl:for-each-group select="collection(concat($from, '?select=*.txt;unparsed=yes'))" group-by="replace(document-uri(), '.*/([a-z-]+)-\d+\.txt', '$1')">
          <xsl:variable name="template" select="current-grouping-key()"/>
          <li>
            <span><xsl:value-of select="$template"/></span>
            <xsl:for-each select="current-group()">
              <label for="{$template}-{position()}"><xsl:value-of select="position()"/></label>
            </xsl:for-each>
          </li>
        </xsl:for-each-group>
      </ul>
    </nav>

    <main class="sdk-main">
      <input type="radio" name="tabs" checked=""/>
      <div class="sdk-email">
        <div class="help">Select template</div>
      </div>
      <xsl:for-each select="collection(concat($from, '?select=*.txt;unparsed=yes'))">

        <xsl:variable name="ref"  select="replace(document-uri(), '.*/([a-z0-9-]+)\.txt', '$1')"/>
        <xsl:variable name="source" select="replace(replace(document-uri(), '/email/text/', '/build/message/'), 'txt', 'xml')"/>

        <input type="radio" name="tabs" id="{$ref}"/>

        <div class="sdk-email">
         <xsl:variable name="notification" select="document($source)//notification"/>
          <div class="sdk-email-template">
            <h1 class="sdk-email-name"><xsl:value-of select="$notification/@template"/></h1>
          </div>
          <div class="sdk-email-template">
            <h2 class="sdk-email-description"><span class="no"><xsl:value-of select="tokenize($ref,'-')[last()]"/></span> <xsl:value-of select="$notification/@description"/></h2>
          </div>
          <div class="sdk-email-wrapper">
            <div class="sdk-email-body">
              <pre class="sdk-plaintext"><xsl:value-of select="unparsed-text(document-uri(), 'utf-8')"/></pre>
            </div>
          </div>
        </div>
      </xsl:for-each>
    </main>
  </body>
</html>
</xsl:template>

</xsl:stylesheet>