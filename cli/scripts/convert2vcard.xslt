<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:csv="csv:csv"
    xmlns:gov="http://pub.data.gov.bc.ca/schemas/bcgov_directory/2012/1"
    xmlns:ms="urn:schemas-microsoft-com:xslt">
    <xsl:output method="text" encoding="utf-8"/>
    <xsl:strip-space elements="*"/>


    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="gov:PERSON">
        <!-- RFC6350 VCARD  Spec -->
        <xsl:if test="contains(gov:NAME, ',') and not(contains(gov:NAME, 'Vacant, Vacant'))">
            <xsl:variable name="surname" select="substring-before(gov:NAME, ',')"/>
            <xsl:variable name="given" select="translate(substring-after(gov:NAME, ','), ' ','')"/>
            <xsl:variable name="org" select="translate(ancestor::gov:ORGANIZATION/@NAME, ',','')"/>
            <xsl:variable name="unit" select="translate(parent::gov:ORGUNIT/@NAME, ',','')"/>

            <xsl:text>BEGIN:VCARD&#xa;</xsl:text>
            <xsl:text>VERSION:3.0&#xa;</xsl:text>
            <xsl:text>FN:</xsl:text>        
            <xsl:value-of select="$given"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$surname"/>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="$org"/>
            <xsl:text>)</xsl:text>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>N:</xsl:text>
            <xsl:value-of select="$surname"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$given"/>
            <xsl:text>;;;</xsl:text>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>EMAIL;TYPE=work:</xsl:text>
            <xsl:value-of select="gov:CONTACT[@TYPE='email']"/>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>TEL;TYPE=work:</xsl:text>
            <xsl:value-of select="gov:CONTACT[@TYPE='telephone']"/>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>TITLE:</xsl:text>
            <xsl:value-of select="gov:TITLE"/>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>ORG:</xsl:text>
            <xsl:value-of select="$org"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$unit"/>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>END:VCARD</xsl:text>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>&#xa;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="gov:ORGUNIT/gov:ADDRESS"/>
    <xsl:template match="gov:ORGUNIT/gov:CONTACT"/>

    <xsl:template match="*">
    <xsl:apply-templates />
    </xsl:template>

</xsl:stylesheet>