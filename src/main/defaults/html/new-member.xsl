<?xml version="1.0"?>
<!-- 
  Email sent to the user after a user is created.

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='new-member']" mode="meta">
  <title>Welcome to PageSeeder</title>
</xsl:template>

<!-- Banner -->
<xsl:template match="notification[@template='new-member']" mode="banner">
  <p wrapper-class="membership-wrap">PageSeeder invitation</p>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='new-member']" mode="body">
  <h3>Hi <xsl:value-of select="member/@firstname" />,</h3>

  <p class="lead">
  <xsl:choose>
    <xsl:when test="inviter"><b><xsl:value-of select="inviter/fullname"/></b> invited you to use</xsl:when>
    <xsl:otherwise>Welcome to</xsl:otherwise>
  </xsl:choose> PageSeeder at <a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)" /></a>.</p>

  <p>PageSeeder allows groups of people to collaborate on different documents
     available on the site.</p>

  <p>You must click on the button below to get started before being able to use PageSeeder.</p>
  <xsl:sequence select="f:button(concat(@hosturl, '/email/getstarted?member=', member/@id, '&amp;token=', @token), 'Get started')"/>
  
  <p class="last">This link will be valid for the next 48 hours.</p>
  
  <xsl:call-template name="noreply"/>
</xsl:template>

<!-- Footer -->
<xsl:template match="notification[@template='new-member']" mode="footer">
  <p>You have received this email because a PageSeeder member created an account for you on 
  <a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)"/></a>.</p>
</xsl:template>

</xsl:stylesheet>
