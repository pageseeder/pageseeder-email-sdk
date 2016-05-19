<?xml version="1.0"?> 
<!--
  When the user request their password to be reset, this email is
  sent to confirm.

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='reset-password-confirm']">
Hi <xsl:value-of select="member/@firstname" />,

A password reset has been requested for the following PageSeeder site: 
  <xsl:value-of select="@hosturl"/><xsl:text>
</xsl:text>
<xsl:choose>
<xsl:when test="@reason='forced'">
You have been made an administrator and to keep using PageSeeder you must click on the link below.
</xsl:when>
<xsl:when test="@reason='admin'">
An administrator has requested your password be reset, to do this please click on the link below.
</xsl:when>
<xsl:otherwise>
If you requested your password to be reset, please click on the link below.
</xsl:otherwise>
</xsl:choose>
RESET PASSWORD:
  <xsl:value-of select="concat(@hosturl,'/email/changepassword?member=',member/@id,'&amp;token=',@token)" />

</xsl:template>

</xsl:stylesheet>