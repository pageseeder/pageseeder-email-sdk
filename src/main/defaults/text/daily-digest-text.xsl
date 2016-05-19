<?xml version="1.0"?>
<!--
  Template used for the daily digest notification
  The input XML format is:
  <notification name="membership-confirm" emaildomain="my-host.com" hosturl="https://www.my-host.com">
    <comments>
      <comment id="123" contentrole="Comment" created="2012-03-08T12:34:00+10:00">
        <title>Cavern stolen!</title>
        <author id="12" firstname="John" surname="Jones" email="jjones@email.com" username="jjones">
          <fullname>John Jones</fullname>
        </author>
        <content type="text/plain">Sesame opened the door</content>
        <context>
          <group id="3" name="acme-test" />
        </context>
      </comment>
      <comment id="123" contentrole="Comment" created="2012-03-08T12:34:00+10:00">
        <title>Cavern stolen!</title>
        <author id="12" firstname="John" surname="Jones" email="jjones@email.com" username="jjones">
          <fullname>John Jones</fullname>
        </author>
        <content type="text/plain">Sesame opened the door</content>
        <context>
          <group id="3" name="acme-test" />
        </context>
      </comment>
      ...
    </comments>
    <group id="3" name="acme-test" description="ACME group" owner="acme" />
  </notification>
-->
<xsl:stylesheet version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:psf="http://www.pageseeder.com/function"
                exclude-result-prefixes="xs psf">

<xsl:template match="/notification">
  <xsl:text>THESE COMMENTS HAVE BEEN ADDED TO GROUP </xsl:text>
  <xsl:value-of select="group/@name" /> IN THE LAST 24 HOURS
<xsl:if test="@emaildomain">
SEND - a message to the <xsl:value-of select="group/@name" /> group
  mailto:<xsl:value-of select="group/@name" />@<xsl:value-of select="@emaildomain" />
  <xsl:text>&#xA;</xsl:text>
</xsl:if>
CHANGE - your options for receiving notifications:
  <xsl:value-of select="concat(@hosturl, '/email/mygroups')" />
  <xsl:for-each select="comments/comment">
    <xsl:sort select="@created" order="descending"/>
    <xsl:text>

***********************************************************************</xsl:text>
    <xsl:text>
SUBJECT: </xsl:text>
    <xsl:value-of select="title" />
    <xsl:text>
AUTHOR: </xsl:text>
    <xsl:value-of select="author/fullname" />
    <xsl:text>
DATE: </xsl:text>
    <xsl:value-of select="format-dateTime(xs:dateTime(@created), '[D] [MNn,*-3] [Y], [h]:[m01] [PN]')" />
      <xsl:text>

</xsl:text>
    <xsl:if test="@status">
      <xsl:text>STATUS: </xsl:text>
      <xsl:value-of select="@status" />
      <xsl:text>  </xsl:text>
    </xsl:if>
    <xsl:if test="@priority">
      <xsl:text>PRIORITY: </xsl:text>
      <xsl:value-of select="@priority" />
    </xsl:if>
    <xsl:if test="@status or @priority">
      <xsl:text>&#xA;&#xA;</xsl:text>
    </xsl:if>
    <xsl:if test="assignedto">
      <xsl:text>ASSIGNED TO: </xsl:text>
      <xsl:value-of select="assignedto/fullname" />
      <xsl:text>  </xsl:text>
    </xsl:if>
    <xsl:if test="@due">
      <xsl:text>DUE DATE: </xsl:text>
      <xsl:value-of select="format-dateTime(xs:dateTime(@due), '[D] [MNn,*-3] [Y] [ZN,*-3]')" />
    </xsl:if>
    <xsl:if test="assignedto or @due">
      <xsl:text>&#xA;&#xA;</xsl:text>
    </xsl:if>
    <xsl:if test="attachment/uri">
      <xsl:text>-----------------------------------------------------------------------
</xsl:text>
    </xsl:if>
    <xsl:for-each select="attachment/uri">
      <xsl:text>ATTACHMENT:   </xsl:text>
      <xsl:value-of select="displaytitle" />
      <xsl:text>
VIEW/DOWNLOAD:
    </xsl:text>
      <xsl:value-of select="concat(/notification/@hosturl, '/page/', /notification/group/@name, '/uri/', @id)" />
      <xsl:text>

</xsl:text>
    </xsl:for-each>
    <xsl:if test="attachment/uri">
      <xsl:text>-----------------------------------------------------------------------

</xsl:text>
    </xsl:if>
    <xsl:for-each select="content">
      <xsl:value-of select="." />
      <xsl:text>
</xsl:text>
    </xsl:for-each>
    <xsl:text>
-----------------------------------------------------------------------
</xsl:text>
  <xsl:text>CONTEXT: </xsl:text>
  <xsl:value-of select="if (context/uri) then context/uri/displaytitle else concat('Group ', context/group/@name)" />
  <xsl:text> </xsl:text>
  <xsl:variable name="location-name">
    <xsl:choose>
      <xsl:when test="starts-with(context/@fragment, 'pspdf(') or starts-with(context/@fragment, 'psgen(')">
        <xsl:value-of select="concat('Page ', number(substring-before(substring-after(context/@fragment, '('), '-')) + 1)"/>
      </xsl:when>
      <xsl:when test="context/@fragment='default'"></xsl:when>
      <xsl:when test="contains(context/@fragment, '//Discussion')">
        <xsl:value-of select="concat('Location: ', substring-before(context/@fragment, '//Discussion'))"/>
      </xsl:when>
      <xsl:when test="context/@fragment">
        <xsl:value-of select="concat('Location: ', context/@fragment)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="upper-case($location-name)" />
  <xsl:text>
</xsl:text>
<xsl:text>
REPLY or VIEW - the full discussion and context:
  </xsl:text>
  <xsl:value-of select="/notification/@hosturl" />/page/<xsl:value-of select="/notification/group/@name" />
  <xsl:text>/comments/</xsl:text><xsl:value-of select="@id" />
<xsl:if test="/notification/@emaildomain"><xsl:text>

REPLY - via email:
  mailto:</xsl:text>
  <xsl:value-of select="@id" />
  <xsl:text>-reply@</xsl:text>
  <xsl:value-of select="/notification/@emaildomain" />
  <xsl:text>?subject=Reply</xsl:text>
</xsl:if>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
