<?xml version="1.0"?>
<!-- 
  Email sent to the user after they change their email address.
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Metadata -->
<xsl:template match="notification[@template='change-email-confirm']" mode="meta">
  <title>PageSeeder email change confirmation</title>
</xsl:template>

<!-- Banner -->
<xsl:template match="notification[@template='change-email-confirm']" mode="banner">
  <p wrapper-class="security-wrap">PageSeeder security</p>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='change-email-confirm']" mode="body">
  <h3>Hi <xsl:value-of select="member/@firstname" />,</h3>

  <p>We would like to confirm that you prefer using <b><xsl:value-of select="@newemail" 
  /></b> as your email for PageSeeder.</p>
  
  <p>If you do not wish to change your email address and continue using your current
  email address <b><xsl:value-of select="member/@email" /></b>, simply disregard this 
  email.</p>

  <p>Until you confirm this change, you will need to use your current email address to
  login to PageSeeder.</p>

  <xsl:variable name="link">
    <xsl:value-of select="@hosturl"/>/page/preferences/mydetails?login-username=<xsl:value-of 
    select="encode-for-uri(member/@username)"
    />&amp;email=<xsl:value-of select="encode-for-uri(@newemail)"
    />&amp;key=<xsl:value-of select="encode-for-uri(@key)" />
  </xsl:variable>
  
  <xsl:sequence select="f:button($link, 'Change email')"/>

</xsl:template>

<!-- Footer -->
<xsl:template match="notification[@template='change-email-confirm']" mode="footer">
  <p>This email has been sent to you because you have an account on 
  <a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)"/></a></p>
</xsl:template>

</xsl:stylesheet>