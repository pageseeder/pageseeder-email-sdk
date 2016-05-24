<?xml version="1.0"?>
<!--
  Template used when a new member has been created and invited to a group
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='membership-new-member']" mode="meta">
  <title>[<xsl:value-of select="membership/(group|project)/@name" />] <xsl:value-of select=" if (membership/project) then 'Project ' else 'Group '"/>
    <xsl:value-of select="if (membership/@status = 'invited') then 'invitation' else 'registration'"/></title>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='membership-new-member']" mode="body">
  <xsl:variable name="firstname" select="membership/member/@firstname"/>
  <h3>
    <xsl:choose>
      <xsl:when test="$firstname!='Member'">Hi <xsl:value-of select="$firstname"/>,</xsl:when>
      <xsl:otherwise>Hi,</xsl:otherwise>
    </xsl:choose>
  </h3>

  <p class="lead">
  <xsl:choose>
    <xsl:when test="inviter"><b><xsl:value-of select="inviter/fullname"/></b> has <xsl:value-of 
    select="if (membership/@status = 'invited') then 'invited you to join' else 'added you to'"/></xsl:when>
    <xsl:otherwise>You have been <xsl:value-of 
    select="if (membership/@status = 'invited') then 'invited to join' else 'added to'"/></xsl:otherwise>
  </xsl:choose> the <xsl:value-of select=" if (membership/project) then 'project ' else 'group '"/><b><xsl:value-of select="membership/(group|project)/@name" /></b>
  on PageSeeder at <a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)" /></a>.</p>

  <p>PageSeeder allows groups of people to collaborate on different documents
     available on the site.</p>

  <p>You must click on the button below to get started before being able to use PageSeeder.</p>
  <xsl:sequence select="f:button(concat(@hosturl, '/email/getstarted?member=', membership/member/@id, '&amp;token=', @token), 'Get started')"/>

  <p class="last">This link will be valid for the next 48 hours.</p>

</xsl:template>

<!-- Footer -->
<xsl:template match="notification[@template='membership-new-member']" mode="footer">
  <p>You have received this email because a PageSeeder member created an account for you and 
  invited you to join group <i><xsl:value-of select="membership/(group|project)/@name" /></i> on 
  <a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)"/></a>.</p>
  <p>This is an automatically generated email - please do not reply to this email.</p>
</xsl:template>

</xsl:stylesheet>
