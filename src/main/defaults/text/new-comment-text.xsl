<?xml version="1.0"?>
<!-- 
  Email sent to the user after a new comment is added.

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification">
<xsl:if test="@announcement = 'true'">
NOTE: This comment has been sent to you regardless of your PageSeeder notification settings because it is an announcement.

</xsl:if>
<xsl:if test="@taskchanged = 'true'">
STATUS, PRIORITY, ASSIGNMENT OR DUE DATE CHANGE

</xsl:if>
<xsl:for-each select="comment">
  <xsl:if test="@status"   >STATUS: <xsl:value-of select="@status" /><xsl:text>  </xsl:text></xsl:if>
  <xsl:if test="@priority" >PRIORITY: <xsl:value-of select="@priority" /></xsl:if>
  <xsl:if test="@status or @priority"><xsl:text>&#xA;</xsl:text></xsl:if>
  <xsl:if test="assignedto">ASSIGNED TO: <xsl:value-of select="assignedto/fullname" /><xsl:text>  </xsl:text></xsl:if>
  <xsl:if test="@due"      >DUE DATE: <xsl:value-of select="format-dateTime(@due, '[D] [MNn,*-3] [Y] [ZN,*-3]')" /></xsl:if>
  <xsl:if test="assignedto or @due"><xsl:text>&#xA;</xsl:text></xsl:if>
  <xsl:for-each select=".[@modified='true']/author">
ORIGINAL MESSAGE BELOW FROM: <xsl:value-of select="if (@fullname) then @fullname else @email" /><xsl:text>&#xA;</xsl:text>
  </xsl:for-each>
  <xsl:for-each select="labels[text() != '' and text() != ',']">
LABELS: <xsl:value-of select="string-join(tokenize(., ','), ', ')" /><xsl:text>&#xA;</xsl:text>
  </xsl:for-each>
<xsl:if test="attachment/uri">
----------------------------------------------------------------------</xsl:if>
<xsl:for-each select="attachment/uri">
ATTACHMENT: <xsl:value-of select="displaytitle" />
VIEW/DOWNLOAD: 
  <xsl:value-of select="concat(/notification/@hosturl, '/page/', ../../../group/@name, '/uri/', @id)" /><xsl:text>&#xa;</xsl:text>
</xsl:for-each>
<xsl:if test="attachment/uri">
----------------------------------------------------------------------</xsl:if>
</xsl:for-each>
<xsl:text>&#xA;</xsl:text>
<xsl:value-of select="f:comment-content(comment)"/>
----------------------------------------------------------------------
<xsl:if test="comment/context/uri/@path">CONTEXT: <xsl:value-of select="f:context(comment/context)"/><xsl:text>&#xa;</xsl:text>
</xsl:if>
View more information about this message:
  <xsl:choose>
    <xsl:when test="comment/@contentrole='Workflow'">
      <xsl:value-of select="concat(@hosturl, '/page/', group/@name, '/uri/', comment/context/uri/@id, '/workflow')" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@hosturl, '/page/', group/@name, '/comments/', comment/@id)" />
    </xsl:otherwise>
  </xsl:choose>

----------------------------------------------------------------------
Change my notification preferences:
  <xsl:value-of select="concat(@hosturl, '/email/mygroups')" />

</xsl:template>

</xsl:stylesheet>
