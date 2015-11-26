<?xml version="1.0"?>
<!--
  Template used when a member has been invited
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Metadata -->
<xsl:template match="notification[@template='membership-confirm']" mode="meta">
  <title>[<xsl:value-of select="membership/(group|project)/@name" />] <xsl:value-of select=" if (membership/project) then 'Project' else 'Group'"/> Invitation</title>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='membership-confirm']" mode="body">
  <h3>Hi <xsl:value-of select="membership/member/@firstname" />,</h3>

  <p>You have been invited to join the <xsl:value-of select="if (membership/project) then 'project ' else 'group '"/>
  <b><xsl:value-of select="membership/(group|project)/@name" /></b> 
  on <a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)"/></a></p>

  <xsl:sequence select="f:button(concat(@hosturl, '/page/', membership/(group|project)/@name, '/member/groupdetails?action=accept&amp;login-username=', membership/member/@username), 'Accept the invitation')"/>

  <p class="last">Disregard this email, if you do not wish to join.</p>
</xsl:template>

</xsl:stylesheet>
