<?xml version="1.0"?>
<!--
  Define useful functions for the templates
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="http://www.pageseeder.com/function"
                exclude-result-prefixes="#all">

<!-- 
  Return a formatted link
  
  @param url  The URL of the link
  @param text The text to display
-->
<xsl:function name="f:link" as="element(a)">
  <xsl:param name="url" />
  <xsl:param name="text" />
  <a href="{$url}"><xsl:value-of select="$text" /></a>
</xsl:function>

<!-- 
  Return a formatted button
  
  @param url  The URL of the link
  @param text The text to display
-->
<xsl:function name="f:button" as="element(div)">
  <xsl:param name="url" />
  <xsl:param name="text" />
  <div class="button">
    <table><tr><td><a href="{$url}"><xsl:value-of select="$text" /></a></td></tr></table>
  </div>
</xsl:function>


<!-- 
  Extracts the host from a URL

  @param url The full URL  
  
  @return the host name
--> 
<xsl:function name="f:hostname">
  <xsl:param name="url" />
  <xsl:analyze-string regex="https?://([\w\-\.]+)([:/].*)?" select="$url">
    <xsl:matching-substring>
      <xsl:value-of select="regex-group(1)"/>
    </xsl:matching-substring>
    <xsl:non-matching-substring>
      <xsl:value-of select="$url"/>
    </xsl:non-matching-substring>
  </xsl:analyze-string>
</xsl:function>

<!--
  Finds the specified strings in the given text.

  @param strings the strings to look for in the text
  @param text    The text to search

  @return the strings that where found in the texts.
-->
<xsl:function name="f:find-string">
  <xsl:param name="strings"/>
  <xsl:param name="text"/>
  <xsl:variable name="upper" select="upper-case($text)"/>
  <xsl:for-each select="tokenize($strings, ',')">
    <xsl:if test="contains($upper, normalize-space(upper-case(.)))">
      <xsl:value-of select="normalize-space(.)" />
    </xsl:if>
  </xsl:for-each>
</xsl:function>

<!--
  Build the name for the icon corresponding to the mediatype of the URI provided

  Note: This file should be kept in sync with 'mediatypes.xsl' used for the user interface.

  @param uri the uri

  @return the icon name
 -->
<xsl:function name="f:media-type-icon">
  <xsl:param name="uri" />
  <xsl:choose>
    <!-- Specific PageSeeder -->
    <xsl:when test="$uri/@mediatype = 'application/vnd.pageseeder.document.standard+xml'">media-psstandard.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/vnd.pageseeder.psml+xml'">media-psml.png</xsl:when>
    <xsl:when test="$uri/@external = 'true' and $uri/@scheme = 'https'">media-url-secure.png</xsl:when>
    <xsl:when test="$uri/@external = 'true'">media-url.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/vnd.pageseeder.url+xml'">media-url.png</xsl:when>
    <!-- Specific MIME -->
    <xsl:when test="$uri/@mediatype = 'application/pdf'">media-pdf.png</xsl:when>
    <xsl:when test="starts-with($uri/@mediatype, 'application/vnd.ms-word') or $uri/@mediatype = 'application/msword'">media-ms-word.png</xsl:when>
    <xsl:when test="starts-with($uri/@mediatype, 'application/vnd.ms-excel')">media-ms-excel.png</xsl:when>
    <xsl:when test="starts-with($uri/@mediatype, 'application/vnd.ms-powerpoint')">media-openxml-powerpoint.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'">media-openxml-word.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'">media-openxml-excel.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/vnd.openxmlformats-officedocument.presentationml.presentation'">media-openxml-powerpoint.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'text/properties'">media-properties.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'text/html'">media-html.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'text/css' or ends-with($uri/@path, '.scss')">media-css.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/javascript' or $uri/@mediatype = 'application/json'">media-javascript.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/zip'">media-compressed.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/x-tar'">media-compressed.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/x-gzip'">media-compressed.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/java-archive'">media-compressed.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/xml-dtd'">media-xml-validate.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/schematron+xml'">media-xml-validate.png</xsl:when>
    <xsl:when test="ends-with($uri/@path, '.xsd')">media-xml-validate.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'application/xslt+xml'">media-xml-transform.png</xsl:when>
    <!-- Main categories -->
    <xsl:when test="ends-with($uri/@mediatype, 'xml')">media-xml.png</xsl:when>
    <xsl:when test="starts-with($uri/@mediatype, 'text/')">media-text.png</xsl:when>
    <xsl:when test="starts-with($uri/@mediatype, 'image/')">media-image.png</xsl:when>
    <xsl:when test="starts-with($uri/@mediatype, 'audio/')">media-audio.png</xsl:when>
    <xsl:when test="starts-with($uri/@mediatype, 'video/')">media-video.png</xsl:when>
    <xsl:when test="$uri/@mediatype = 'folder'" >ico-folder.png</xsl:when>
    <xsl:otherwise>media-unknown.png</xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!--
  Matches any part of the text which contains a string starting with
  'http://' or 'https://' and create a link.

  @param text the text node to work from.
  @return a sequence of the text nodes and links.
-->
<xsl:function name="f:linkify">
  <xsl:param name="text" />
  <xsl:for-each select="$text">
    <xsl:analyze-string select="." regex="http[s]?://[^\s]+">
      <xsl:matching-substring>
        <a href="{.}"><xsl:value-of select="."/></a>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:for-each>
</xsl:function>

<!--
  Replaces the newlines \n by <br/> tags
  
  @param text The text to process
-->
<xsl:function name="f:text-to-html">
  <xsl:param name="text"/>
  <xsl:variable name="lines" select="tokenize($text, '\n')"/>
  <xsl:for-each select="$lines">
    <xsl:copy-of select="."/><br/>
  </xsl:for-each>
</xsl:function>

</xsl:stylesheet>
