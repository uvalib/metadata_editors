<?xml version="1.0" encoding="UTF-8"?>
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oxf="http://www.orbeon.com/oxf/processors" xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events">

<!-- retrieve the search and what vocab it is from -->
    <p:processor name="oxf:request">
        <p:input name="config">
            <config>
                <include>/request/parameters</include>
            </config>
        </p:input>
        <p:output name="data" id="request"/>
    </p:processor>

<!-- assemble the query for Stanbol. defaults provided in variables for now, except stanbol.url, which is 
        in an Orbeon property (properties-local.xml). -->
    <p:processor name="oxf:unsafe-xslt">
        <!-- have to use unsafe XSLT to use external functions like pipeline:property() -->
        <p:input name="config">
            <config xsl:version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:pipeline="java:org.orbeon.oxf.processor.pipeline.PipelineFunctionLibrary">
                <!-- LDPath pattern controls what is returned from Stanbol
                see: https://code.google.com/p/ldpath/wiki/PathLanguage -->
                <xsl:variable name="ldpath"
                    select="encode-for-uri(
                    'skos:prefLabel = skos:prefLabel :: xsd:string;
                    skos:inScheme = skos:inScheme;
                    skos:notation = skos:notation;')"/>
                <!-- where is Stanbol: pulled from an Orbeon property -->
                <xsl:variable name="stanbol-url"
                    select="concat(pipeline:property('stanbol.url'),'/entityhub/site')"/>
                <!-- controls which field to search. for SKOS vocabs, normally prefLabel is best -->
                <xsl:variable name="search-field">skos:prefLabel</xsl:variable>
                <!-- adds an asterisk onto the search term so that we get wildcard behavior -->
                <xsl:variable name="search-term"
                    select="concat(/request/parameters/parameter[name='topic']/value,'*')"/>
                <!-- which vocab to search -->
                <xsl:variable name="vocab"
                    select="/request/parameters/parameter[name='vocab']/value"/>

                <url><xsl:value-of
                        select="concat($stanbol-url,'/',$vocab,'/find?field=',$search-field,'&amp;name=',$search-term,'&amp;ldpath=',$ldpath)"
                    /></url>
                <content-type>application/rdf+xml</content-type>
                <force-content-type>true</force-content-type>
                <encoding>UTF-8</encoding>
                <force-encoding>true</force-encoding>
                <header>
                    <name>Accept</name>
                    <value>application/rdf+xml</value>
                </header>
            </config>
        </p:input>
        <p:input name="data" href="#request"/>
        <p:output name="data" id="request-params"/>
    </p:processor>

<!-- make request and get results from Stanbol -->
    <p:processor name="oxf:url-generator">
        <p:input name="config" href="#request-params"/>
        <p:output name="data" id="stanbol-results" debug="stanbol-results"/>
    </p:processor>

<!-- transform them into XForms select options -->
    <p:processor name="oxf:xslt">
        <p:input name="config">
            <section xsl:version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                <xsl:for-each select="/rdf:RDF/rdf:Description[skos:inScheme]">
                    <!-- there should never be more than one skos:prefLabel per language, so it is safe to sort on it -->
                    <xsl:sort select="skos:prefLabel" order="ascending"/>
                    <item>
                        <label>
                            <xsl:value-of select="skos:prefLabel"/>
                        </label>
                        <value rdf:about="{@rdf:about}">
                            <xsl:choose>
                                <!-- prefer skos:notation if available -->
                                <xsl:when test="skos:notation">
                                    <xsl:value-of select="skos:notation"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="skos:prefLabel"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </value>
                    </item>
                </xsl:for-each>
            </section>
        </p:input>
        <p:input name="data" href="#stanbol-results"/>
        <p:output name="data" id="options"/>
    </p:processor>
    
<!-- kick it out as XML -->
    <p:processor name="oxf:xml-serializer">
        <p:input name="data" href="#options"/>
        <p:input name="config">
            <config/>
        </p:input>
    </p:processor>

</p:config>
