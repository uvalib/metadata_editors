<!--
  Copyright (C) 2010 Orbeon, Inc.

  This program is free software; you can redistribute it and/or modify it under the terms of the
  GNU Lesser General Public License as published by the Free Software Foundation; either version
  2.1 of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  The full text of the license is available at http://www.gnu.org/copyleft/lesser.html
  -->
<!--
    This is a very simple theme that shows you how to create a common layout for all your pages. You can modify it at
    will or, even better, copy it as theme.xsl under your application folder where it will be picked up. For example,
    if your app is my-app: resources/my-app/theme.xsl.
-->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:version="java:org.orbeon.oxf.common.Version">

    <!-- Orbeon Forms version -->
    <xsl:variable name="orbeon-forms-version" select="version:getVersionString()" as="xs:string"/>

    <xsl:template match="xhtml:head">
        <xsl:copy>
            <xsl:call-template name="head"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xhtml:div[contains(@class, 'fr-top') or contains(@class, 'fr-separator')]">
    </xsl:template>
    
    <xsl:template match="xhtml:div[contains(@class, 'fr-toc')]">
        <xhtml:div class="topbar">
            <xhtml:div class="topbar-inner">
                <xhtml:div class="toc-wrapper container">
                    <xhtml:a class="toc-title brand"><xsl:value-of select="//xhtml:title"/></xhtml:a>
                    <xsl:apply-templates select="xhtml:ol" />
                </xhtml:div>
            </xhtml:div>
        </xhtml:div>
    </xsl:template>
    
    <xsl:template match="//xhtml:div[contains(@class, 'fr-toc')]/xhtml:ol">
        <xhtml:ul class="nav secondary-nav">
            <xhtml:li class="dropdown">
                <xhtml:a href="#" class="dropdown-toggle">Jump to Section</xhtml:a>
                <xhtml:ol class="dropdown-menu">
                    <xsl:apply-templates />
                </xhtml:ol>
            </xhtml:li>
        </xhtml:ul>
    </xsl:template>
    
    <xsl:template match="xhtml:a[contains(@class, 'xforms-trigger')]/xhtml:img[@title='Add']">
        <xsl:copy>
           <xsl:copy-of select="@*"/>
           <xsl:attribute name="src">/forms/style/icons/add_circle.png</xsl:attribute>
           <xsl:attribute name="height">26</xsl:attribute>
           <xsl:attribute name="width">26</xsl:attribute>
    	   <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
        
    <xsl:template name="head">
        <xsl:apply-templates select="@*"/>
        <!-- Handle head elements except scripts -->
        <xsl:apply-templates select="xhtml:meta | xhtml:link | xhtml:style"/>
        <!-- Title -->
        <xhtml:title>
            <xsl:apply-templates select="xhtml:title/@*"/>
            <xsl:choose>
                <xsl:when test="xhtml:title != ''">
                    <xsl:value-of select="xhtml:title"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="(/xhtml:html/xhtml:body/xhtml:h1)[1]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xhtml:title>
        <!-- Orbeon Forms version -->
        <xhtml:meta name="generator" content="{$orbeon-forms-version}"/>
        <!-- Handle head scripts if present -->
        <xsl:apply-templates select="xhtml:script"/>
        <xhtml:script src="/forms/scripts/main.js"><!-- custom script --></xhtml:script>
    </xsl:template>

    <!-- Simply copy everything that's not matched -->
    <xsl:template match="@*|node()" priority="-2">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
