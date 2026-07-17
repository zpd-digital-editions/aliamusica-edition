<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0">

	<xsl:output encoding="UTF-8" indent="yes" method="xml" standalone="yes"/>

	<xsl:variable name="sourceDoc" select="substring-after(substring-before(base-uri(), '.xml'), 'tei/')"/>

	<xsl:variable name="ms-m" select="document('ms-m.xml')"/>
	<xsl:variable name="ms-p" select="document('ms-p.xml')"/>

	<xsl:template match="/">
		<xsl:result-document href="{$sourceDoc}-apparatus.xml">
			<xsl:apply-templates select="@* | node()" mode="apparatus"/>
		</xsl:result-document>
		<xsl:result-document href="{$sourceDoc}-glosses.xml">
			<xsl:apply-templates select="@* | node()" mode="glosses"/>
		</xsl:result-document>
		<xsl:result-document href="{$sourceDoc}-sources.xml">
			<xsl:apply-templates select="@* | node()" mode="sources"/>
		</xsl:result-document>
		<xsl:result-document href="{$sourceDoc}-synopsis.xml">
			<xsl:apply-templates select="@* | node()" mode="synopsis"/>
		</xsl:result-document>
		<xsl:result-document href="{$sourceDoc}-translation.xml">
			<xsl:apply-templates select="@* | node()" mode="translation"/>
		</xsl:result-document>
	</xsl:template>

	<!-- identity transform -->
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

	<!-- ignore standOff (sources) -->
	<xsl:template match="TEI/standOff" mode="#all"/>

	<!-- base text -->
	<xsl:template match="text/body" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

	<!-- ignore back matter (translation) -->
	<xsl:template match="text/back" mode="#all"/>

	<!-- APPARATUS -->

	<!-- ignore apparatus everywhere but in apparatus view -->
	<xsl:template match="text//app" mode="glosses sources synopsis translation">
		<xsl:apply-templates select="lem" mode="#current"/>
	</xsl:template>
	<xsl:template match="text//lem" mode="glosses sources synopsis translation">
		<xsl:apply-templates select="@* | node()" mode="#current"/>
	</xsl:template>

	<!-- ignore corrections everywhere but in apparatus view -->
	<xsl:template match="text//choice" mode="glosses sources synopsis translation">
		<xsl:apply-templates select="corr" mode="#current"/>
	</xsl:template>
	<xsl:template match="text//corr" mode="glosses sources synopsis translation">
		<xsl:apply-templates select="@* | node()" mode="#current"/>
	</xsl:template>

	<!-- ignore figure notes everywhere but in apparatus view -->
	<xsl:template match="text//figure/note" mode="glosses sources synopsis translation"/>

	<!-- GLOSSES -->

	<!-- ignore glosses everywhere but in glosses view -->
	<xsl:template match="text//add[@type = 'gloss']" mode="apparatus sources synopsis translation"/>

	<xsl:template match="text//add[@type = 'gloss']" mode="glosses">
		<seg type="gloss">
			<anchor/>
			<xsl:copy>
				<xsl:apply-templates select="@* | node()" mode="#current"/>
			</xsl:copy>
		</seg>
	</xsl:template>

	<!-- SOURCES -->

	<!-- parallel view: manuscript / sources -->
	<xsl:template match="text//div/p" mode="sources">
		<div type="parallel">
			<xsl:copy>
				<xsl:apply-templates select="@* | node()" mode="#current"/>
			</xsl:copy>
			<xsl:variable name="sourceRef" select="
					//standOff/seg[@sameAs = concat('#', current()/@xml:id)]
					/ref"/>
			<xsl:if test="$sourceRef">
				<xsl:variable name="sourceDoc" select="document($sourceRef/@source)/TEI"/>
				<xsl:variable name="sourceLines" select="
						$sourceRef/@target
						! tokenize(., '\s+')"/>
				<p corresp="{concat('#',@xml:id)}">
					<xsl:for-each select="$sourceLines">
						<xsl:variable name="line" select="$sourceDoc//line[@xml:id = substring(current(), 2)]"/>
						<seg type="line">
							<xsl:copy-of select="$line/@rend"/>
							<xsl:value-of select="$line"/>
						</seg>
					</xsl:for-each>
					<seg type="source">
						<xsl:text>(</xsl:text>
						<xsl:value-of select="$sourceDoc//teiHeader/fileDesc/sourceDesc/p"/>
						<xsl:text>, </xsl:text>
						<xsl:variable name="lineRefs" select="tokenize(normalize-space($sourceRef/@target), '\s+')"/>
						<xsl:value-of select="substring($lineRefs[1], 3)"/>
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring($lineRefs[last()], 3)"/>
						<xsl:text>)</xsl:text>
					</seg>
				</p>
			</xsl:if>
		</div>
	</xsl:template>
	<!-- segment highlighting -->
	<xsl:template match="text//seg" mode="sources">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="//standOff/seg[contains(@corresp, current()/@xml:id)]">
					<xsl:attribute name="ana" select="'hasSource'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="ana" select="'hasNoSource'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

	<!-- SYNOPSIS -->

	<!-- parallel view: manuscript / corresponding sections -->
	<xsl:template match="text//seg" mode="synopsis">
		<seg type="parallel">
			<xsl:copy>
				<xsl:apply-templates select="@* | node()" mode="#current"/>
			</xsl:copy>
			<!-- get all corresponding sections from other manuscripts -->
			<seg corresp="{concat('#',@xml:id)}">
				<lb source="M"/>
				<xsl:choose>
					<xsl:when test="$ms-m//seg[@xml:id = current()/@xml:id]">
						<xsl:apply-templates select="$ms-m//seg[@xml:id = current()/@xml:id]/node()" mode="#current"/>
					</xsl:when>
					<xsl:otherwise>
						<seg corresp="#none">--</seg>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<lb source="P"/>
				<xsl:choose>
					<xsl:when test="$ms-p//seg[@xml:id = current()/@xml:id]">
						<xsl:apply-templates select="$ms-p//seg[@xml:id = current()/@xml:id]/node()" mode="#current"/>
					</xsl:when>
					<xsl:otherwise>
						<seg corresp="#none">--</seg>
					</xsl:otherwise>
				</xsl:choose>
			</seg>
		</seg>
	</xsl:template>

	<!-- TRANSLATION -->

	<!-- parallel view: manuscript / translation -->
	<xsl:template match="text//div/p" mode="translation">
		<div type="parallel">
			<xsl:copy>
				<xsl:apply-templates select="@* | node()" mode="#current"/>
			</xsl:copy>
			<!-- get translated paragraph -->
			<xsl:copy-of select="//p[substring(@corresp, 2) = current()/@xml:id]"/>
		</div>
	</xsl:template>

</xsl:stylesheet>
