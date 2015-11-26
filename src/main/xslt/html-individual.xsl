<?xml version="1.0"?> 
<!-- 
  Generate each the HTML email in a separate file.
-->
<xsl:stylesheet version="2.0"
        xmlns:psf="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<!-- Import HTML templates -->
<xsl:import href="../template/html.xsl" />

<!-- Generate Emails as indented XHTML documents -->
<xsl:output method="xhtml" media-type="application/html+xml" indent="yes"
 doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
 doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
 name="email"/>

<!-- 
  Sample messages contain multiple notifications 
-->
<xsl:template match="notifications">
<xsl:for-each select="notification">
  <!-- Each notification  -->
  <xsl:result-document href="{@name}-{position()}.html" format="email">
    <xsl:apply-templates select="."/>
  </xsl:result-document>
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>