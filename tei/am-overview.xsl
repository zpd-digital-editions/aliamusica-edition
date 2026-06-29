<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0">

	<xsl:output encoding="UTF-8" indent="yes" method="xml" standalone="yes"/>

	<xsl:template match="/">
		<xsl:result-document href="am-overview.xml">
			<xsl:apply-templates select="@* | node()"/>
		</xsl:result-document>
	</xsl:template>

	<xsl:variable name="am-edition" select="document('am-edition-abgd.xml')"/>

	<xsl:template match="body">
		<body>
			<div xml:id="intro">
				<head>Overview</head>
				<xsl:copy-of select="id('overview')"/>
			</div>
			<div rend="columns column-header">
				<p rend="edition">Before Rearrangement<lb/>(α + β + γ + δ)</p>
				<p rend="ms">After Rearrangement<lb/>(Manuscript Order)</p>
			</div>
			<xsl:for-each select="div">
				<div rend="columns">
					<xsl:apply-templates select="head"/>
					<p rend="edition">
						<xsl:variable name="divId" select="@xml:id"/>
						<xsl:for-each select="$am-edition//div[@xml:id = $divId]/p">
							<num source="{@source}">
								<ref target="../?doc=am-edition-abgd#{@xml:id}">
									<xsl:value-of select="substring(num, 2)"/>
								</ref>
							</num>
						</xsl:for-each>
					</p>
					<p rend="ms">
						<xsl:for-each select="p[num]">
							<num source="{@source}">
								<xsl:value-of select="substring(num, 2)"/>
							</num>
						</xsl:for-each>
					</p>
				</div>
			</xsl:for-each>
		</body>
	</xsl:template>

	<xsl:template match="back"/>

	<!-- identity transform -->
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
