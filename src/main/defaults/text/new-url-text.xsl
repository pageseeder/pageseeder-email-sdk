<?xml version="1.0"?> 

<!--
  Template used when a URL is created or edited
  The input XML format is:
  <notification name="new-url" announcement="[true|false]" modified="[true|false]" emaildomain="my-host.com" hosturl="https://www.my-host.com">
    <uri id="456" scheme="https" host="www.my-external-host.com" port="443" path="/my-external-url.html"
         decodedpath="/my-external-url.html" external="true" created="2013-08-26T12:11:59+10:00"
         title="My URL title">
      <displaytitle>My URL title</displaytitle>
      <description>My URL description.</description>
    </uri>
    <group id="123" name="myproject-mygroup" owner="My Organisation" description="My Own Group">
      <message>Welcome to the group!</message>
    </group\>
  </notification>

-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:psf="http://www.pageseeder.com/function"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs psf">

<xsl:variable name="new-line"><xsl:text>
</xsl:text></xsl:variable>
  
<xsl:template match="/notification">
  <!-- Header -->
  <xsl:call-template name="notification-text-header"/>
  <!-- Content -->
  <xsl:choose>
    <xsl:when test="@modified = 'true'">An existing URL was updated in </xsl:when>
    <xsl:otherwise>A new URL was added to </xsl:otherwise>
  </xsl:choose>
  <xsl:text>the group </xsl:text>
  <xsl:value-of select="group/@name" />
  <xsl:text>:</xsl:text>
  <xsl:value-of select="$new-line" />
  <xsl:if test="uri/displaytitle"><xsl:value-of select="uri/usertitle" /><xsl:value-of select="$new-line" /></xsl:if>
  <xsl:value-of select="psf:url(uri)" />
  <xsl:value-of select="$new-line" />
  <xsl:value-of select="$new-line" />
  <xsl:if test="uri/description"><xsl:value-of select="uri/description" /><xsl:value-of select="$new-line" /><xsl:value-of select="$new-line" /></xsl:if>
  <!-- Footer -->
  <xsl:call-template name="notification-text-footer"/>
</xsl:template>

<xsl:function name="psf:url">
  <xsl:param name="uri" />
  <xsl:value-of select="$uri/@scheme" />
  <xsl:text>://</xsl:text>
  <xsl:value-of select="$uri/@host" />
  <xsl:if test="not($uri/@scheme = 'http' and $uri/@port = '80') and not($uri/@scheme = 'https' and $uri/@port = '443')">
    <xsl:text>:</xsl:text>
    <xsl:value-of select="$uri/@port" />
  </xsl:if>
  <xsl:value-of select="$uri/@path" />
</xsl:function>

<!-- The header of the text email -->
<xsl:template name="notification-text-header">
  <xsl:if test="@announcement = 'true'">
    <xsl:text>NOTE: This comment has been sent to you regardless of your PageSeeder notification settings because it is an announcement..</xsl:text>
    <xsl:value-of select="$new-line" />
  </xsl:if>
  <!-- add labels, need to be in URI context -->
  <xsl:for-each select="uri">
    <xsl:if test="string(labels) != '' and string(labels) != ','">
      <xsl:text>LABELS: </xsl:text>
      <xsl:for-each select="tokenize(labels, ',')">
        <xsl:if test="position() != 1">, </xsl:if><xsl:value-of select="." />
      </xsl:for-each>
      <xsl:text>&#xA;&#xA;</xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<!-- 
  The footer of the Text email.
  
  The footer should contain one of the strings specified in the group properties
  emailFooterStart so as to be able to remove it from replies.
  The text removed is after the last line containing one of the values of the property (including that line).
-->
<xsl:template name="notification-text-footer">
  <xsl:value-of select="$new-line" />
  <xsl:text>--------------------------------------------------------------</xsl:text>
  <xsl:value-of select="$new-line" />
  <xsl:value-of select="$new-line" />
  <xsl:text>You can access this URL here: </xsl:text>
  <xsl:value-of select="$new-line" />
  <xsl:value-of select="concat(@hosturl, '/page/', group/@name, '/uri/', uri/@id)" />
  <xsl:value-of select="$new-line" />
  <xsl:value-of select="$new-line" />
  <xsl:text>Change my notification preferences:</xsl:text>
  <xsl:value-of select="$new-line" />
  <xsl:value-of select="concat(@hosturl, '/page/', group/@name, '/preferences/mygroups')" />
  <xsl:value-of select="$new-line" />
</xsl:template>

</xsl:stylesheet>