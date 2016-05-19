<?xml version="1.0"?>
<!--
  Define useful functions for plain text emails
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="http://www.pageseeder.com/function"
                exclude-result-prefixes="#all">

<xsl:output encoding="UTF-8" method="text" />

<!--
   @param uri The attachment URI
   @return The link to the attachment
-->
<xsl:function name="f:attachment-link" as="xs:string">
  <xsl:param name="uri"/>
  <xsl:variable name="n" select="$uri/ancestor::notification"/>
  <xsl:value-of select="concat($n/@hosturl, '/page/', $n/group/@name, '/uri/', $uri/@id)" />
</xsl:function>

<!--
   @param uri The comment author
   @return The name and email of the author if available
-->
<xsl:function name="f:author" as="xs:string">
  <xsl:param name="author"/>
  <xsl:value-of select="$author/fullname,$author/@email" separator=", "/>
</xsl:function>

<!--
  @param context The comment context element 
  @return the context string to display
-->
<xsl:function name="f:context-link" as="xs:string">
  <xsl:param name="context" />
  <xsl:variable name="host" select="$context/ancestor::notification/@hosturl"/>
  <xsl:for-each select="$context">
    <xsl:choose>
      <xsl:when test="group">
        <xsl:value-of select="concat($host, '/page/', group/@name, '/comments')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($host, '/page/uri/', uri/@id)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:function>

<!--
  @param context The comment context element 
  @return the context string to display
-->
<xsl:function name="f:context" as="xs:string*">
  <xsl:param name="context" />
  <xsl:for-each select="$context">
    <xsl:variable name="location-name">
      <xsl:choose>
        <xsl:when test="starts-with(@fragment, 'pspdf(') or starts-with(@fragment, 'psgen(')">
          <xsl:value-of select="concat('Page ', number(substring-before(substring-after(@fragment, '('), '-')) + 1)"/>
        </xsl:when>
        <xsl:when test="@fragment = 'default'"></xsl:when>
        <xsl:when test="contains(@fragment, '//Discussion')">
          <xsl:value-of select="concat('Location: ', substring-before(@fragment, '//Discussion'))"/>
        </xsl:when>
        <xsl:when test="@fragment">
          <xsl:value-of select="concat('Location: ', @fragment)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="group">Group <xsl:value-of select="group/@name" /></xsl:when>
      <xsl:when test="uri"><xsl:value-of select="uri/displaytitle" /></xsl:when>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:value-of select="upper-case($location-name)" />
  </xsl:for-each>
</xsl:function>

<!--
  Finds the specified strings in the given text.

  @param strings the strings to look for in the text
  @param text    The text to search

  @return the strings that where found in the texts.
-->
<xsl:function name="f:find-string" as="xs:string">
  <xsl:param name="strings"/>
  <xsl:param name="text"/>
  <xsl:variable name="upper" select="upper-case($text)"/>
  <xsl:for-each select="tokenize($strings, ',')">
    <xsl:if test="contains($upper, normalize-space(upper-case(.)))">
      <xsl:value-of select="normalize-space(.)" />
    </xsl:if>
  </xsl:for-each>
</xsl:function>

<xsl:function name="f:comment-content"  as="xs:string*">
  <xsl:param name="comment"/>
  <xsl:for-each select="$comment/content[contains(@type,'text/plain')]">
    <xsl:value-of select="." />
    <xsl:text>
  </xsl:text>
</xsl:for-each>
</xsl:function>

</xsl:stylesheet>
