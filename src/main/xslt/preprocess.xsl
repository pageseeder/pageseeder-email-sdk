<?xml version="1.0"?> 
<!-- 
  Preprocess the messages and inject the 'emaildomain' and 'hosturl' attributes.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="hosturl" />
<xsl:param name="emaildomain" />

<!-- Generate XML -->
<xsl:output method="xml"/>

<!-- Generate Emails as indented XHTML documents -->
<xsl:output method="xml" name="notification"/>

<!-- 
  Sample messages contain multiple notifications 
-->
<xsl:template match="notifications">
<xsl:for-each select="notification">
  <!-- Each notification  -->
  <xsl:result-document href="{@template}-{position()}.xml" format="notification">
    <xsl:apply-templates select="."/>
  </xsl:result-document>
</xsl:for-each>
</xsl:template>

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