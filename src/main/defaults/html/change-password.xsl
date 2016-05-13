<?xml version="1.0"?> 
<!--
  Template used to produce an email used to notify the user that their password was updated. 
 -->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='change-password']" mode="meta">
  <title>PAGESEEDER: Password updated</title>
</xsl:template>

<!-- Banner -->
<xsl:template match="notification[@template='change-password']" mode="banner">
  <p wrapper-class="security-wrap">PageSeeder security</p>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='change-password']" mode="body">
  <h3>Hi <xsl:value-of select="member/@firstname" />,</h3>

  <p>Your <b>password has been updated</b> for the following PageSeeder site: 
  <a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)" /></a></p>

  <p>If you changed your password, you can disregard this email. It was only sent 
  to alert you in case you did not make the change yourself.</p>

  <p>If you didn't change your password, your account might have been 
  compromised and we recommend that you reset your password as soon as possible.</p>

</xsl:template>

</xsl:stylesheet>
