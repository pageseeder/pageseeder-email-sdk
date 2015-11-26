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

<!-- Metadata -->
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

  <p>If you requested your password to be reset, please click on the button below.</p>

  <xsl:variable name="link" select="concat(@hosturl,'/page/changepassword?member-password=&amp;member-username=',encode-for-uri(member/@username),'&amp;key=',encode-for-uri(@key))"/>
  <xsl:sequence select="f:button($link, 'Reset password')"/>

</xsl:template>

</xsl:stylesheet>
