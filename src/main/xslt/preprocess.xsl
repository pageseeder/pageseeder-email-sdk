<?xml version="1.0"?> 
<!-- 
  Preprocess the messages and inject the 'emaildomain' and 'hosturl' attributes.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="hosturl" />
<xsl:param name="emaildomain" />

<!-- Generate Emails as indented XHTML documents -->
<xsl:output method="xml"/>

<!-- Inject headers into notifications -->
<xsl:template match="notification">
  <xsl:copy>
    <xsl:attribute name="hosturl" select="$hosturl"/>
    <xsl:attribute name="emaildomain" select="$emaildomain"/>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!-- Copy elements -->
<xsl:template match="*">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>