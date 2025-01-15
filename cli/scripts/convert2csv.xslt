<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:csv="csv:csv"
    xmlns:gov="http://pub.data.gov.bc.ca/schemas/bcgov_directory/2012/1">
    <xsl:output method="text" encoding="utf-8"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="delimiter" select="','"/>
    <csv:columns>
        <column>Full Name</column>
        <column>Last Name</column>
        <column>First Name</column>
        <column>Job Title</column>
        <column>E-mail Address</column>
        <column>Business Phone</column>
        <column>Department</column>
        <column>Company</column>
        <column>Reports_To</column>
    </csv:columns>

    <xsl:template match="/">
        <!-- Output the CSV header -->
        <xsl:for-each select="document('')/*/csv:columns/*">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()">
                <xsl:value-of select="$delimiter"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="gov:PERSON">
        <xsl:if test="contains(gov:NAME, ',') and not(contains(gov:NAME, 'Vacant, Vacant'))">
            <xsl:variable name="surname" select="substring-before(gov:NAME, ',')"/>
            <xsl:variable name="given" select="translate(substring-after(gov:NAME, ','), ' ','')"/>
            <xsl:variable name="org" select="translate(ancestor::gov:ORGANIZATION/@NAME, ',','')"/>
            <xsl:variable name="unit" select="translate(parent::gov:ORGUNIT/@NAME, ',','')"/>
            <xsl:value-of select="$given"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$surname"/>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="$org"/>
            <xsl:text>)</xsl:text>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="$surname"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="$given"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="translate(gov:TITLE, ',',';')"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="gov:CONTACT[@TYPE='email']"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="gov:CONTACT[@TYPE='telephone']"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="$unit"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="$org"/>
            <xsl:text>&#xa;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="gov:ORGUNIT/gov:ADDRESS"/>
    <xsl:template match="gov:ORGUNIT/gov:CONTACT"/>

    <xsl:template match="*">
    <xsl:apply-templates />
    </xsl:template>

</xsl:stylesheet>