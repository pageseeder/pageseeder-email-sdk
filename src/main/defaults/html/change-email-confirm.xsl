<?xml version="1.0"?>
<!-- 
  Email sent to the user after they change their email address.

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='change-email-confirm']" mode="meta">
  <title>Confirm your email change</title>
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

  <xsl:variable name="link" select="concat(@hosturl, '/email/changeemail?member=', member/@id, '&amp;token=', @token)"/>
  <xsl:sequence select="f:button($link, 'Change email')"/>

  <p class="last">This link will be valid for the next 12 hours.</p>

  <xsl:call-template name="noreply"/>
</xsl:template>

</xsl:stylesheet>
