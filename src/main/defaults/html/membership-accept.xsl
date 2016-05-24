<?xml version="1.0"?>
<!--
  Template used when a membership needs moderation.
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='membership-accept']" mode="meta">
  <title>[<xsl:value-of select="membership/(group|project)/@name" />] <xsl:value-of select=" if (membership/project) then 'Project' else 'Group'"/> registration request</title>
</xsl:template>

<xsl:template match="notification[@template='membership-accept']" mode="banner">
  <p wrapper-class="moderation-wrap">PageSeeder moderation</p>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='membership-accept']" mode="body">

  <h3>Hi <xsl:value-of select="moderator/@firstname"/>,</h3>

  <p>The person below would like to join the group <b><xsl:value-of select="membership/(group|project)/@name" /></b>
  that you are moderating.</p>

  <table style="height:100px;width:100%" border="0" cellpadding="0" cellspacing="0"><tr>
    <td style="vertical-align: top;width:240px">
      <xsl:call-template name="table">
        <xsl:with-param name="table-style">width: 100%;</xsl:with-param>
        <xsl:with-param name="title" select="membership/member/@firstname" />
        <xsl:with-param name="rows">
          <rows xmlns="">
            <row title="Name"><xsl:value-of select="membership/member/fullname" /></row>
            <row title="Email"><xsl:value-of select="membership/member/@email" /></row>
          </rows>
        </xsl:with-param>
      </xsl:call-template>
    </td>
    <td style="vertical-align: top;width: 90px">
      <img src="{$images-url}/arrow.png;" border="0" />
    </td>
    <td style="vertical-align: top;width:240px">
      <xsl:call-template name="table">
        <xsl:with-param name="table-style">width: 100%;</xsl:with-param>
        <xsl:with-param name="title-image">ico-group.png</xsl:with-param>
        <xsl:with-param name="title" select="membership/(group|project)/@name" />
        <xsl:with-param name="rows">
          <rows xmlns="">
            <row title="{if (membership/project) then 'Project' else 'Group'}"><xsl:value-of select="membership/(group|project)/@name" /></row>
            <row title="Description"><xsl:value-of select="membership/(group|project)/@description" /></row>
          </rows>
        </xsl:with-param>
      </xsl:call-template>
    </td>
  </tr></table>

  <h4 style="clear: both">Accept <xsl:value-of select="membership/member/@firstname" />'s request?</h4>

  <xsl:sequence select="f:button(concat(@hosturl, '/email/moderatemember?group=', membership/(group|project)/@name, '&amp;member=', membership/member/@id), 'Accept')"/>

  <p class="last">To reject the above request, or to defer your decision, simply ignore this message.</p>

  <p>This request will remain available under the 'Pending'
     section of the Members page until a time that it is either 'Accepted' or 'Permanently Removed'.</p>
</xsl:template>

<!-- Footer -->
<xsl:template match="notification[@template='membership-accept']" mode="footer">
  <p>You have been sent this email because you are the moderator of group <i><xsl:value-of select="membership/(group|project)/@name" /></i>
  on <a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)"/></a>.</p>
  <p>This is an automatically generated email - please do not reply to this email.</p>
</xsl:template>

</xsl:stylesheet>
