<?xml version="1.0"?>
<!--
  Template used when a membership has been accepted
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='membership-complete']" mode="meta">
  <title>[<xsl:value-of select="membership/(group|project)/@name" />] <xsl:value-of select=" if (membership/project) then 'Project' else 'Group'"/> registration</title>
</xsl:template>

<!-- Banner -->
<xsl:template match="notification[@template='membership-complete']" mode="banner">
  <p wrapper-class="membership-wrap">PageSeeder group registration</p>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='membership-complete']" mode="body">
  <!-- compute the help URL -->
  <xsl:variable name="helpurl" select="if (starts-with(@helpurl, '/')) then concat(@hosturl, @helpurl)
                                else if (string(@helpurl) != '') then @helpurl
                                else 'http://user.pageseeder.com'"/>
  <xsl:variable name="project-group" select="if (membership/group) then 'group ' else 'project '"/>

  <h3>Hi <xsl:value-of select="membership/member/@firstname" />,</h3>

  <xsl:choose>
    <xsl:when test="inviter">
      <p class="lead"><b><xsl:value-of select="inviter/fullname"/></b> has added you to <xsl:value-of select="$project-group"/><b><xsl:value-of select="membership/(group|project)/@name" /></b>.</p>
    </xsl:when>
    <xsl:otherwise>
      <p class="lead">You have now joined <xsl:value-of select="$project-group"/><b><xsl:value-of select="membership/(group|project)/@name" /></b>.</p>
    </xsl:otherwise>
  </xsl:choose>

  <!-- Copy the welcome message -->
  <xsl:if test="membership/(group|project)/message">
    <p><xsl:copy-of select="f:text-to-html(membership/(group|project)/message)" /></p>
  </xsl:if>

  <!-- TODO: Remove if no longer required -->
  <p><b>Note:</b> You may need to logout from PageSeeder and login again to gain access.</p>

  <xsl:variable name="email-address" select="concat(membership/(group|project)/@name, '@', @emaildomain)" />

  <xsl:call-template name="table">
    <xsl:with-param name="title-image">ico-group.png</xsl:with-param>
    <xsl:with-param name="title"><xsl:value-of select="membership/(group|project)/@name" /></xsl:with-param>
    <xsl:with-param name="rows">
      <rows xmlns="">
        <row title="Description"><xsl:value-of select="membership/(group|project)/@description" /></row>
        <row title="Notification"><xsl:value-of select="membership/@notification" /></row>
        <xsl:choose>
          <xsl:when test="membership/(group|project)/@homeurl">
            <row title="Home">
              <xsl:sequence select="f:link(membership/(group|project)/@homeurl, membership/(group|project)/@homeurl)" />
            </row>
          </xsl:when>
          <xsl:otherwise>
            <row title="Home">
              <xsl:sequence select="f:link(concat(@hosturl, '/page/', membership/(group|project)/@name, '/home'),
                                             concat(@hosturl, '/page/', membership/(group|project)/@name, '/home'))" />
            </row>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@generalcomments = 'true' and $email-address">
          <row title="Email">
            <xsl:sequence select="f:link(concat('mailto:', $email-address), $email-address)" />
          </row>
        </xsl:if>
      </rows>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:if test="@generalcomments = 'true' and $email-address">
    <h4>What's next?</h4>
    <p>You can send a message to this <xsl:value-of select="$project-group"/>by posting to 
    <xsl:sequence select="f:link(concat('mailto:', $email-address), $email-address)" />.</p>
  </xsl:if>

  <h4>Read me first</h4>
  <p>The system powering this <xsl:value-of select="$project-group"/>is called PageSeeder.<br/>
  If you are unfamiliar with PageSeeder please follow the link below for an introduction to its features.</p>
  <p><a href="{$helpurl}"><xsl:value-of select="$helpurl" /></a></p>
  
  <xsl:call-template name="noreply"/>
</xsl:template>

<!-- Footer -->
<xsl:template match="notification[@template='membership-complete']" mode="footer">
  <xsl:variable name="group" select="membership/(group|project)"/>
  <p>You received this message because you are part of the <i><xsl:value-of select="$group/@name" /></i>
   group on <a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)"/></a>.</p>
  <p>Manage your ongoing  notification settings using your <a href="{@hosturl}/email/mygroups">subscription options</a></p>
</xsl:template>

</xsl:stylesheet>
