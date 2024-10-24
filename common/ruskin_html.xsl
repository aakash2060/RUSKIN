<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:custom="http://whatever"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="tei xs xi teix custom">
  
  <!-- Parameters -->
  <xsl:param name="assetUrl" select="'https://erm.selu.edu/web/images'" />
  <!-- <xsl:param name="assetUrl" select="'http://ruskin.english.selu.edu:8080/web/images'" /> -->
  <xsl:param name="htmlForm" select="1" />
  
  <!-- Output settings -->
  <xsl:output method="html" use-character-maps="uni-hex" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
  
  <!--A B O U T   T H I S   D O C U M E N T
  Filename:               ruskin.xsl
  Version:                2.0
  Original Release Date:
  Last Modified Date:     04/10/2016
  Author:                 Charles W. Borchers, IV
  Project Title:          The Early Works of John Ruskin (1826-42)
  Project Director:       David C. Hanson
  Project Email Address:  ruskinproject@selu.edu
  Copyright Notice:       This document was created exclusively for The Early Works of John Ruskin (1826-42), a Digital Humanities project of
  Southeastern Louisiana University's Department of English. The contents of this document may not be used or reproduced in
  any form without the express permission of the Author and the Project Director.-->
  
  <!-- Variables -->
  <xsl:variable name="newServerPath" select="'https://erm.selu.edu'" />
  <xsl:variable name="lineBreak"><br/></xsl:variable>
  
  <!-- Import all required stylesheets -->
  <xsl:import href="xsl_imports/third_party.xsl"/>
  <xsl:import href="xsl_imports/characters.xsl"/>
  <xsl:import href="xsl_imports/functions.xsl"/>
  <xsl:import href="xsl_imports/names.xsl"/>
  <xsl:import href="xsl_imports/table.xsl"/>
  <xsl:import href="xsl_imports/line_numbers.xsl"/>
  <xsl:import href="xsl_imports/tei_bibliography.xsl"/>
  <xsl:import href="xsl_imports/tei_etc.xsl"/>
  <xsl:import href="xsl_imports/tei_head.xsl"/>
  <xsl:import href="xsl_imports/tei_hi.xsl"/>
  <xsl:import href="xsl_imports/tei_ref.xsl"/>
  <xsl:import href="xsl_imports/tei_main_tags.xsl"/>
  <xsl:import href="xsl_imports/witness_tags.xsl"/>
  <xsl:import href="xsl_imports/tei_variables.xsl"/>
  <xsl:import href="xsl_imports/tei_titlePage.xsl"/>
  
  [Rest of your existing code remains exactly the same, starting from:]
  
  <!-- Root template -->
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>
          <xsl:value-of select="//tei:titleStmt/tei:title[1]"/>
        </title>
        <style>
          .tei-div { margin: 1em 0; }
          .tei-p { margin: 0.5em 0; }
          .tei-head { font-weight: bold; }
          .tei-hi-italic { font-style: italic; }
          .tei-hi-bold { font-weight: bold; }
          .tei-note { font-size: 0.9em; color: #666; }
          .tei-list { margin: 1em 0; }
          .tei-item { margin: 0.3em 0; }
          .tei-table { border-collapse: collapse; }
          .tei-cell { border: 1px solid #ccc; padding: 0.5em; }
        </style>
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  
  <!-- Header/Metadata -->
  <xsl:template match="tei:teiHeader">
    <div class="tei-header">
      <xsl:apply-templates select=".//tei:titleStmt"/>
      <xsl:apply-templates select=".//tei:sourceDesc"/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:titleStmt">
    <div class="tei-titlestmt">
      <h1><xsl:value-of select="tei:title"/></h1>
      <xsl:apply-templates select="tei:author"/>
      <xsl:apply-templates select="tei:editor"/>
    </div>
  </xsl:template>
  
  <!-- Main text structure -->
  <xsl:template match="tei:text">
    <div class="tei-text">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:body">
    <div class="tei-body">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:div">
    <div class="tei-div">
      <xsl:if test="@type">
        <xsl:attribute name="class">tei-div tei-div-<xsl:value-of select="@type"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <!-- Basic text elements -->
  <xsl:template match="tei:p">
    <p class="tei-p">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="tei:head">
    <xsl:variable name="level">
      <xsl:choose>
        <xsl:when test="parent::tei:div[@type='chapter']">2</xsl:when>
        <xsl:when test="parent::tei:div[@type='section']">3</xsl:when>
        <xsl:otherwise>4</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="h{$level}">
      <xsl:attribute name="class">tei-head</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <!-- Text formatting -->
  <xsl:template match="tei:hi[@rend='italic']">
    <em class="tei-hi-italic"><xsl:apply-templates/></em>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='bold']">
    <strong class="tei-hi-bold"><xsl:apply-templates/></strong>
  </xsl:template>
  
  <!-- Lists -->
  <xsl:template match="tei:list">
    <xsl:choose>
      <xsl:when test="@type='ordered'">
        <ol class="tei-list"><xsl:apply-templates/></ol>
      </xsl:when>
      <xsl:otherwise>
        <ul class="tei-list"><xsl:apply-templates/></ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:item">
    <li class="tei-item"><xsl:apply-templates/></li>
  </xsl:template>
  
  <!-- Tables -->
  <xsl:template match="tei:table">
    <table class="tei-table">
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  
  <xsl:template match="tei:row">
    <tr class="tei-row"><xsl:apply-templates/></tr>
  </xsl:template>
  
  <xsl:template match="tei:cell">
    <td class="tei-cell"><xsl:apply-templates/></td>
  </xsl:template>
  
  <!-- Notes and references -->
  <xsl:template match="tei:note">
    <span class="tei-note">
      <xsl:if test="@xml:id">
        <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
      </xsl:if>
      [<xsl:apply-templates/>]
    </span>
  </xsl:template>
  
  <xsl:template match="tei:ref">
    <a class="tei-ref">
      <xsl:if test="@target">
        <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </a>
  </xsl:template>
  
  <!-- Page breaks -->
  <xsl:template match="tei:pb">
    <hr class="tei-pb"/>
    <span class="tei-pb-number">Page <xsl:value-of select="@n"/></span>
  </xsl:template>
  
  <!-- Line breaks -->
  <xsl:template match="tei:lb">
    <br class="tei-lb"/>
  </xsl:template>
  
  <!-- Figures and graphics -->
  <xsl:template match="tei:figure">
    <figure class="tei-figure">
      <xsl:apply-templates/>
      <xsl:if test="tei:figDesc">
        <figcaption class="tei-figdesc">
          <xsl:value-of select="tei:figDesc"/>
        </figcaption>
      </xsl:if>
    </figure>
  </xsl:template>
  
  <xsl:template match="tei:graphic">
    <img class="tei-graphic">
      <xsl:if test="@url">
        <xsl:attribute name="src"><xsl:value-of select="@url"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@width">
        <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@height">
        <xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>
  
  <!-- Default template for unmatched elements -->
  <xsl:template match="*">
    <span class="tei-{local-name()}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
</xsl:stylesheet>