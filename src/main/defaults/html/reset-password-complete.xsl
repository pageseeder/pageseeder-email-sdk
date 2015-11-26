<?xml version="1.0"?>
<!--
  This email is sent after the password of a user has been reset.
 -->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Metadata -->
<xsl:template match="notification[@template='reset-password-complete']" mode="meta">
  <title>PAGESEEDER: Password reset</title>
</xsl:template>

<!-- Banner -->
<xsl:template match="notification[@template='reset-password-complete']" mode="banner">
  <p wrapper-class="security-wrap">PageSeeder security</p>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='reset-password-complete']" mode="body">
  <h3>Hi <xsl:value-of select="member/@firstname" />,</h3>

  <p>Your PageSeeder password has been reset <xsl:value-of select="if (group/@name = 'admin') then
  'because you have become an administrator' else ''" /> for the following site: </p>
  <p><a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)"/></a></p>

  <p>You can login using your email <b><xsl:value-of select="member/@email"/></b>
  <xsl:if test="not(string(member/@username) = '' or member/@username = member/@email)">
    or your username <b><xsl:value-of select="member/@username" /></b>
  </xsl:if> and the temporary random password below:</p>
  <center><h4><xsl:value-of select="@password" /></h4></center>

  <xsl:choose>
    <xsl:when test="member/@status = 'unactivated'">
      <p>You must click on the button below to activate your account before being able to use PageSeeder.
      You can also change your random password to something easier for you to remember.</p>
      <xsl:variable name="link" select="concat(@hosturl,'/page/nogroup/preferences/mydetails?username=',encode-for-uri(member/@username),'&amp;key=',encode-for-uri(@key))"/>
      <xsl:sequence select="f:button($link, 'Activate my account')"/>
    </xsl:when>
    <xsl:otherwise>
      <p>Please follow the link below to change it to something easier for you to remember:</p>
      <xsl:variable name="link" select="concat(@hosturl,'/page/nogroup/preferences/mydetails')"/>
      <xsl:sequence select="f:button($link, 'Update my password')"/>

    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

</xsl:stylesheet>