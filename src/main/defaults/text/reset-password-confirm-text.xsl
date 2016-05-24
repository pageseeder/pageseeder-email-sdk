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
An administrator has reset your password.
You can enter a new one by following the link below.
</xsl:when>
<xsl:otherwise>
It looks like you requested a new password.
If that sounds right, you can enter new password by following the link below.
</xsl:otherwise>
</xsl:choose>
UPDATE YOUR PASSWORD:
  <xsl:value-of select="concat(@hosturl,'/email/changepassword?member=',member/@id,'&amp;token=',@token)" />

This link will be valid for the next 12 hours.

<xsl:if test="@reason='forced'">
Note: we do not (and should not!) know your password, so if your current password is strong enough you might be able to reuse.
</xsl:if>

-----------------------------------------------------------------------
This email has been sent to you because you have an account on <xsl:value-of select="concat(@hosturl, '/')"/>

This is an automatically generated email - please do not reply to this email.
</xsl:template>

</xsl:stylesheet>