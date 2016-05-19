<?xml version="1.0"?> 
<!-- 
  Email sent to the user after a user is created.

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='new-member']">
Hi <xsl:value-of select="member/@firstname" />,

<xsl:choose>
  <xsl:when test="inviter">*<xsl:value-of select="inviter/fullname"/>* invited you to use</xsl:when>
  <xsl:otherwise>Welcome to</xsl:otherwise>
</xsl:choose> PageSeeder at 
  <xsl:value-of select="concat(@hosturl,'/')" />

PageSeeder allows groups of people to collaborate on different documents available on the site.

You can login using your email *<xsl:value-of select="member/@email"/>*<xsl:if 
 test="not(string(member/@username) = '' or member/@username = member/@email)">
 or your username <b><xsl:value-of select="member/@username" /></b>
</xsl:if>.
<xsl:choose>
  <xsl:when test="member/@status != 'activated'">You must follow the link below to activate your account</xsl:when>
  <xsl:otherwise>You must click on the button below to get started</xsl:otherwise>
</xsl:choose> before being able to use PageSeeder.
  <xsl:value-of select="concat(@hosturl, '/email/getstarted?member=', member/@id, '&amp;token=', @token)"/>
</xsl:template>

</xsl:stylesheet>
