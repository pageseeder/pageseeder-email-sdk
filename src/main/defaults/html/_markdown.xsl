<?xml version="1.0"?>
<!--
  This XSLT module defines a function for generating HTML for emails from a 
  PageSeeder flavoured markdown syntax.

  Note: There is no reason to modify this module.

  To format using markdown use:

    f:markdown( $content )
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="http://www.pageseeder.com/function"
                exclude-result-prefixes="#all">

<!--
  Enhances the text so that it can include styles, links, lists, headings and 
  code blocks using markdown-like techniques.

  @param text the plain text to enhance.
  
  @deprecated markdown conversion is done by java now
  
  @return the HTML formatted equivalent
-->
<xsl:function name="f:markdown">
  <xsl:param name="text" as="xs:string"/>
  <xsl:variable name="raw-lines" select="tokenize($text, '\n')"/>
  <xsl:variable name="analyzed" select="f:_parse-lines($raw-lines)" as="element()*"/>
  <xsl:for-each-group select="$analyzed" group-adjacent="name()">
    <xsl:choose>
      <xsl:when test="self::pre">
        <pre>
          <xsl:for-each select="current-group()">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
          </xsl:for-each>
        </pre>
      </xsl:when>
      <xsl:when test="self::quote">
        <blockquote>
          <xsl:for-each-group select="current-group()" group-adjacent="boolean(text())">
            <xsl:if test="text()">
              <p><xsl:sequence select="f:_beautify(string-join(current-group()/text(), ' '))"/></p>
            </xsl:if>
          </xsl:for-each-group>
        </blockquote>
      </xsl:when>
      <xsl:when test="self::list">
        <xsl:element name="{if (@number) then 'ol' else 'ul'}">
          <xsl:if test="@number"><xsl:attribute name="start" select="@number"/></xsl:if>
          <xsl:for-each-group select="current-group()" group-starting-with="list[@item]">
            <li><xsl:sequence select="f:_beautify(string-join(current-group()/text(), ' '))"/></li>
          </xsl:for-each-group>
        </xsl:element>
      </xsl:when>
      <xsl:when test="self::p">
        <p>
          <xsl:for-each-group select="current-group()" group-ending-with="p[@break]">
            <xsl:sequence select="f:_beautify(string-join(current-group()/text(), ' '))"/>
            <xsl:if test="position() lt last()"><br xmlns="http://www.w3.org/1999/xhtml"/></xsl:if>
          </xsl:for-each-group>
        </p>
      </xsl:when>
      <xsl:when test="self::empty-line">
        <xsl:for-each select="1 to count(current-group())-1"><br xmlns="http://www.w3.org/1999/xhtml"/></xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{name()}"><xsl:sequence select="f:_beautify(string-join(current-group()/text(), ' '))"/></xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each-group>
</xsl:function>

<!-- ====================================================================== -->
<!-- Supports the markdown function: DO NOT MODIFY -->
<!-- ====================================================================== -->

<!--
  Trim the spaces in the specified sequence.
-->
<xsl:function name="f:_trim">
  <xsl:param name="t" as="xs:string"/>
  <xsl:sequence select="if (matches($t, '\S+')) then replace($t, '^\s*(.+?)\s*$', '$1') else ''"/>
</xsl:function>

<!--
  Turn the link
-->
<xsl:function name="f:_linkify">
  <xsl:param name="t" as="xs:string"/>
  <xsl:analyze-string regex="(https?://\S+)" select="$t">
    <xsl:matching-substring>
      <a href="{.}"><xsl:value-of select="."/></a>
    </xsl:matching-substring>
    <xsl:non-matching-substring>
      <xsl:value-of select="."/>
    </xsl:non-matching-substring>
  </xsl:analyze-string>
</xsl:function>

<!--
  Read each line and turn into a set of elements identifying the kind of element being processed

  @param lines the lines from the source
-->
<xsl:function name="f:_parse-lines" as="element()*">
  <xsl:param name="lines" as="xs:string*"/>
  <xsl:choose>
    <xsl:when test="count($lines) gt 1000">
      <xsl:for-each select="$lines"><pre><xsl:value-of select="."/></pre></xsl:for-each>
    </xsl:when>
    <xsl:otherwise><xsl:sequence select="f:_parse-line($lines, 1, count($lines), false())"/></xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!--
  Parse an individual line.

  @param lines All lines form the source.
  @param i     Line being processed.
  @param total Total number of lines in source
-->
<xsl:function name="f:_parse-line" as="element()*">
  <xsl:param name="lines" as="xs:string*"/>
  <xsl:param name="i"     as="xs:integer"/>
  <xsl:param name="total" as="xs:integer"/>
  <xsl:param name="in-list"  as="xs:boolean"/>
  <xsl:if test="not($i gt $total)">
    <xsl:variable name="line" select="$lines[$i]"/>
    <xsl:variable name="list-item" select="matches($line, '^\s?(-|\+|\*|\d+\.)\s.+')"/>
    <xsl:variable name="space-only" select="not(matches($line, '\S'))"/>
    <xsl:choose>
      <!-- Lines made entirely of '=' or '-' are used for heading 1 and 2 -->
      <xsl:when test="$i gt 1 and matches($line, '^\s?(==+|\-\-+)\s*$')"/>

      <!-- Empty lines are used to separate the different kinds of blocks -->
      <xsl:when test="$space-only"><empty-line/></xsl:when>

      <!-- List items starting with '+', '-', '*' or number followed by a '.' -->
      <xsl:when test="$list-item">
        <list item="{if ($in-list) then 'continue' else 'start'}">
          <xsl:analyze-string regex="^\s*(\d+)\.\s.+" select="$line">
            <xsl:matching-substring>
              <xsl:attribute name="number" select="regex-group(1)"/>
            </xsl:matching-substring>
          </xsl:analyze-string>
          <xsl:sequence select="f:_trim(replace($line, '^\s*(-|\+|\*|\d+\.)\s+(.+)$', '$2'))"/>
        </list>
      </xsl:when>

      <!-- Continuation of a list item -->
      <xsl:when test="$in-list">
        <list><xsl:sequence select="f:_trim($line)"/></list>
      </xsl:when>

      <!-- Lines starting with two spaces: preformatted code -->
      <xsl:when test="matches($line, '^\s{2}')">
        <pre><xsl:sequence select="substring($line, 3)"/></pre>
      </xsl:when>

      <!-- Lines starting with '>': quoted content  -->
      <xsl:when test="matches($line, '^\s*>+\s?')">
        <xsl:variable name="quoted" select="substring-after($line, '>')"/>
        <quote><xsl:if test="matches($quoted, '\S')"><xsl:sequence select="$quoted"/></xsl:if></quote>
      </xsl:when>

      <!-- Probably a paragraph or heading -->
      <xsl:otherwise>

        <xsl:analyze-string regex="^\s*(#{{1,6}})\s+(.*)$" select="$line">
          <!-- Headings start with '#' -->
          <xsl:matching-substring>
            <xsl:element name="h{string-length(regex-group(1))}"><xsl:sequence select="f:_trim(regex-group(2))"/></xsl:element>
          </xsl:matching-substring>
          <!-- Paragraphs or headings followed by '-' or '=' -->
          <xsl:non-matching-substring>
            <xsl:variable name="next" select="if ($i lt $total) then $lines[$i+1] else ''"/>
            <xsl:variable name="element">
              <xsl:choose>
                <xsl:when test="matches($next, '^\s*==+\s*$')">h1</xsl:when>
                <xsl:when test="matches($next, '^\s*\-\-+\s*$')">h2</xsl:when>
                <xsl:otherwise>p</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:element name="{$element}"><xsl:sequence select="f:_trim($line)"/></xsl:element>
            <!-- If the line breaks occurs before 66 characters, we assume it is intentional and insert a break -->
            <xsl:if test="$element = 'p' and string-length($line) le 66"><p break=""/></xsl:if>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:otherwise>

    </xsl:choose>
    <xsl:variable name="next-in-list" select="if ($in-list) then if ($space-only) then false() else true() else $list-item"/>
    <xsl:sequence select="f:_parse-line($lines, $i+1, $total, $next-in-list)"/>
  </xsl:if>
</xsl:function>

<!--
  Beautify the text by using markdown style inline markup such as codes, links and emphases.

  @param t the string to beautify
  @return the corresponding set of nodes
-->
<xsl:function name="f:_beautify" as="node()*">
  <xsl:param name="t" as="xs:string"/>
  <xsl:analyze-string select="$t" flags="x" regex='(\*\*(.*?)\*\*)
                                                 | (\*(.*?)\*)
                                                 | (`(.*?)`)
                                                 | (\[(.*?)\]\((.*?)\))
                                                 | (&lt;((https?://|mailto:)(.*?))>)
                                                 | (https?://\S+[\w])'>
    <xsl:matching-substring>
      <xsl:choose>
       <!-- Normal emphases (appear in italic) -->
       <xsl:when test="regex-group(1)">
         <em><xsl:sequence select="f:_beautify(regex-group(2))"/></em>
       </xsl:when>
       <!-- Strong emphases (appear in bold) -->
       <xsl:when test="regex-group(3)">
         <strong><xsl:sequence select="f:_beautify(regex-group(4))"/></strong>
       </xsl:when>
       <!-- Code -->
       <xsl:when test="regex-group(5)">
         <code><xsl:sequence select="regex-group(6)"/></code>
       </xsl:when>
       <!-- Titled links -->
       <xsl:when test="regex-group(7)">
         <a href="{regex-group(9)}"><xsl:sequence select="regex-group(8)"/></a>
       </xsl:when>
       <!-- Explicit links -->
       <xsl:when test="regex-group(10)">
         <a href="{regex-group(11)}"><xsl:sequence select="regex-group(13)"/></a>
       </xsl:when>
       <!-- Auto links -->
       <xsl:when test="regex-group(14)">
         <a href="{regex-group(14)}"><xsl:sequence select="regex-group(14)"/></a>
       </xsl:when>
      </xsl:choose>
    </xsl:matching-substring>
    <xsl:non-matching-substring>
      <xsl:value-of select="."/>
    </xsl:non-matching-substring>
  </xsl:analyze-string>
</xsl:function>

</xsl:stylesheet>
