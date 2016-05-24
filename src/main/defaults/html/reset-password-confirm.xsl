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

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='reset-password-confirm']" mode="meta">
  <title>Update your password</title>
</xsl:template>

<!-- Banner -->
<xsl:template match="notification[@template='reset-password-confirm']" mode="banner">
  <p wrapper-class="security-wrap">PageSeeder security</p>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='reset-password-confirm']" mode="body">
  <h3>Hi <xsl:value-of select="member/@firstname" />,</h3>

  <xsl:choose>
    <xsl:when test="@reason='forced'">
      <p>You are now an administrator!</p>
      <p>As a security precaution, we have reset your password and ask you to enter one that meets our security requirements.</p>
    </xsl:when>
    <xsl:when test="@reason='admin'">
      <p>An administrator has reset your password.</p>
      <p>You can enter a new one by clicking on the button below.</p>
    </xsl:when>
    <xsl:otherwise>
      <p>It looks like you requested a new password.</p>
      <p>If that sounds right, you can enter new password by clicking on the button below.</p>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:variable name="link" select="concat(@hosturl,'/email/changepassword?member=',member/@id,'&amp;token=',@token)"/>
  <xsl:sequence select="f:button($link, 'Update password')"/>

  <p class="last">This link will be valid for the next 12 hours.</p>

  <xsl:if test="@reason='forced'">
    <p class="last">We do not (and should not!) know your password, so if your current password is strong
    enough you might be able to reuse it.</p>
  </xsl:if>

</xsl:template>

</xsl:stylesheet>
