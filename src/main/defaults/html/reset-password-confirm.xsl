<?xml version="1.0"?>
<!--
  When the user request their password to be reset, this email is
  sent to confirm.
 -->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='reset-password-confirm']" mode="meta">
  <title>PAGESEEDER: Password reset</title>
</xsl:template>

<!-- Banner -->
<xsl:template match="notification[@template='reset-password-confirm']" mode="banner">
  <p wrapper-class="security-wrap">PageSeeder security</p>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='reset-password-confirm']" mode="body">
  <h3>Hi <xsl:value-of select="member/@firstname" />,</h3>

  <p>A password reset has been requested for the following PageSeeder site: </p>
  <p><a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)"/></a></p>

  <xsl:choose>
    <xsl:when test="@reason='forced'">
      <p>You have been made an administrator and to keep using PageSeeder you must click on the button below.</p>
    </xsl:when>
    <xsl:when test="@reason='admin'">
      <p>An administrator has requested your password be reset, to do this please click on the button below.</p>
    </xsl:when>
    <xsl:otherwise>
      <p>If you requested your password to be reset, please click on the button below.</p>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:variable name="link" select="concat(@hosturl,'/email/changepassword?member=',member/@id,'&amp;token=',@token)"/>
  <xsl:sequence select="f:button($link, 'Reset password')"/>

</xsl:template>

</xsl:stylesheet>
