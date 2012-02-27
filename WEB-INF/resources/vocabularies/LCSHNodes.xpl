<?xml version="1.0" encoding="UTF-8"?>
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oxf="http://www.orbeon.com/oxf/processors" xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events">

    <p:processor name="oxf:request">
        <p:input name="config">
            <config>
                <include>/request/parameters</include>
            </config>
        </p:input>
        <p:output name="data" id="request"/>
    </p:processor>

    <p:processor name="oxf:xslt">
        <p:input name="config">
            <config xsl:version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                <url>http://localhost:10080/entityhub/site/LCSH/find?field=skos:prefLabel&amp;name=<xsl:value-of select="/request/parameters/parameter[name='topic']/value"/>*&amp;ldpath=skos%3AConcept%20%3D%20skos%3AprefLabel%20%3A%3A%20xsd%3Astring%3B%0A</url>
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

    <p:processor name="oxf:url-generator">
        <p:input name="config" href="#request-params"/>
        <p:output name="data" id="stanbol-results" debug="stanbol-results"/>
    </p:processor>

    <p:processor name="oxf:xslt">
        <p:input name="config">
            
            <xsl:transform version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                <xsl:template name="description" match="/">
                    <xsl:for-each select="rdf:Description">
                    {"id" : "<xsl:value-of select='@rdf:about'/>"
                        "name" : "<xsl:value-of select='skos:prefLabel'/>",
                       "children" : [ <xsl:for-each select="skow:narrower">
                           
                       </xsl:for-each>]}
                </xsl:template>
            </xsl:transform>
        </p:input>
        <p:input name="data" href="#stanbol-results"/>
        <p:output name="data" id="options"/>
    </p:processor>

    <p:processor name="oxf:xml-serializer">
        <p:input name="data" href="#options"/>
        <p:input name="config">
            <config/>
        </p:input>
    </p:processor>

</p:config>
