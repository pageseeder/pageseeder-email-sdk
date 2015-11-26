<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY styles SYSTEM "styles.css">
]>
<!--
  This XSLT module defines a function and templates for doing some basic
  CSS inlining.
  
  Note: There is no reason to modify this module.

  To use the inliner use the function:

    f:inliner( $content )
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="http://www.pageseeder.com/function"
                exclude-result-prefixes="#all">

<!-- Styles defined externally 
<xsl:variable name="external-styles" select="unparsed-text('styles.css')"/>
-->
<xsl:variable name="external-styles">&styles;</xsl:variable>

<!-- 
  List of CSS rules to inline (processed from external styles)
-->
<xsl:variable name="rules" as="element(rule)*">
  <!-- (1:selector(2:element)|(3:class)|(4(5:ancestor-class)(6:element)))(7:declaration) -->
  <xsl:analyze-string regex="{'(([\w\-]+)|(\.[\w\-]+)|((\.[\w\-]+)\s+([\w\-]+)))\s*\{\s*([^}]+)\}'}" select="$external-styles">
    <xsl:matching-substring>
      <rule selector="{regex-group(1)}">
        <xsl:if test="regex-group(2) != '' or regex-group(6)  != ''"><xsl:attribute name="element" select="regex-group(2),regex-group(6)" separator=""/></xsl:if>
        <xsl:if test="regex-group(3) != ''"><xsl:attribute name="class" select="substring(regex-group(3), 2)"/></xsl:if>
        <xsl:if test="regex-group(5) != ''"><xsl:attribute name="ancestor-class" select="substring(regex-group(5), 2)"/></xsl:if>
        <xsl:value-of select="regex-group(7)"/>
      </rule>
    </xsl:matching-substring>
  </xsl:analyze-string>
</xsl:variable>

<!--
  Basic CSS inlining function which will insert the CSS styles inline in the style 
  attribute for every element it finds in the specified content.

  This inliner will only apply content based on class or element name.

  If the element already has some styles, no style is added.
  
  @param content The HTML content

  @return the same content with CSS inline styles inserted.
-->
<xsl:function name="f:inliner">
  <xsl:param name="content"/>
  <xsl:apply-templates select="$content" mode="inliner"/>
</xsl:function>

<!-- 
  Returns all the CSS rules applicable to an element by name or class. 
-->
<xsl:function name="f:rules" as="element(rule)*">
  <xsl:param name="element"/>
  <xsl:param name="class"/>
  <xsl:sequence select="$rules[@element = $element]"/>
  <xsl:if test="$class">
    <xsl:for-each select="tokenize($class, '\s')">
      <xsl:sequence select="$rules[@class=current()]"/>
    </xsl:for-each>
  </xsl:if>
</xsl:function>

<!-- 
  Process elements to insert inline style 
-->
<xsl:template match="*" mode="inliner">
  <xsl:copy>
    <!-- Copy all attributes except 'style' -->
    <xsl:copy-of select="@*[not(name() = 'style')]"/>
    <!-- Construct style in the following order: element, class, class + element, inline -->
    <xsl:variable name="local-rules" select="f:rules(name(), @class)" as="element(rule)*"/>
    <xsl:variable name="style">
      <xsl:value-of select="$local-rules[@element][not(@ancestor-class)]"/>
      <xsl:value-of select="$local-rules[@class][not(@ancestor-class)]"/>
      <xsl:value-of select="$local-rules[@element][@ancestor-class = current()/ancestor::*/@class]"/>
      <xsl:value-of select="@style"/>
    </xsl:variable>
    <!-- Add style attribute if there is some inline style -->
    <xsl:if test="$style != ''">
      <xsl:attribute name="style" select="$style"/>
    </xsl:if>
    <!-- bgcolor for 'body', 'table', 'td' and 'th' elements -->
    <xsl:if test="self::body or self::table or self::td or self::th">
      <xsl:if test="not(@bgcolor)">
        <xsl:analyze-string regex="{'background(-color)?:\s*(#[a-fA-F0-9]{6})'}" select="$style">
          <xsl:matching-substring>
            <xsl:attribute name="bgcolor" select="regex-group(2)"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates select="*|text()" mode="inliner"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
