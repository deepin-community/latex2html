### File: koi8r.pl
### Version 0.1,  October 28, 2005
### Written by Sergej Znamenskij <znamensk@rustex.botik.ru>
###
### koi8r encoding information
###
### based on cp1252.pl

## Copyright (C) 1999 by Ross Moore
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
#<!-- (C) International Organization for Standardization 1986
#     Permission to copy in any form is granted for use with
#     conforming SGML systems and applications as defined in
#     ISO 8879, provided this notice is included in all copies.
#     This has been extended for use with HTML to cover the full
#     set of codes in the range 160-255 decimal.
#-->
#<!-- Character entity set. Typical invocation:
#     <!ENTITY % ISOlat1 PUBLIC
#       "ISO 8879-1986//ENTITIES Added Latin 1//EN//HTML">
#     %ISOlat1;
#-->

$CHARSET = "koi8-r";
$PREV_CHARSET = "koi8-r";
$INPUTENC='koi8-r';  # empty implies 'latin1'
$russian_encoding=$INPUTENC;

#Character ranges for lower --> upper-case conversion

$sclower = "\\243-\\243\\300-\\337";
$scupper = "\\263-\\263\\340-\\377";

%low_entities = ( '163', '179'
                 ,'192', '224'
                 ,'193', '225'
                 ,'194', '226'
                 ,'195', '227'
                 ,'196', '228'
                 ,'197', '229'
                 ,'198', '230'
                 ,'199', '231'
                 ,'200', '232'
                 ,'201', '233'
                 ,'202', '234'
                 ,'203', '235'
                 ,'204', '236'
                 ,'205', '237'
                 ,'206', '238'
                 ,'207', '239'
                 ,'208', '240'
                 ,'209', '241'
                 ,'210', '242'
                 ,'211', '243'
                 ,'212', '244'
                 ,'213', '245'
                 ,'214', '246'
		 ,'215', '247'
                 ,'216', '248'
                 ,'217', '249'
                 ,'218', '250'
                 ,'219', '251'
                 ,'220', '252'
                 ,'221', '253'
                 ,'222', '254'
		 ,'223', '255'
);


sub do_cmd_copyright {join('', '�', $_[0]);}
sub do_cmd_cyra {join('', '�', $_[0]);}
sub do_cmd_CYRA {join('', '�', $_[0]);}
sub do_cmd_cyrb {join('', '�', $_[0]);}
sub do_cmd_CYRB {join('', '�', $_[0]);}
sub do_cmd_cyrch {join('', '�', $_[0]);}
sub do_cmd_CYRCH {join('', '�', $_[0]);}
sub do_cmd_cyrc {join('', '�', $_[0]);}
sub do_cmd_CYRC {join('', '�', $_[0]);}
#sub do_cmd_cyrdje {join('', '�', $_[0]);}
#sub do_cmd_CYRDJE {join('', '�', $_[0]);}
sub do_cmd_cyrd {join('', '�', $_[0]);}
sub do_cmd_CYRD {join('', '�', $_[0]);}
#sub do_cmd_cyrdze {join('', '�', $_[0]);}
#sub do_cmd_CYRDZE {join('', '�', $_[0]);}
#sub do_cmd_cyrdzhe {join('', '�', $_[0]);}
#sub do_cmd_CYRDZHE {join('', '�', $_[0]);}
sub do_cmd_cyre {join('', '�', $_[0]);}
sub do_cmd_CYRE {join('', '�', $_[0]);}
sub do_cmd_cyrerev {join('', '�', $_[0]);}
sub do_cmd_CYREREV {join('', '�', $_[0]);}
sub do_cmd_cyrery {join('', '�', $_[0]);}
sub do_cmd_CYRERY {join('', '�', $_[0]);}
sub do_cmd_cyrf {join('', '�', $_[0]);}
sub do_cmd_CYRF {join('', '�', $_[0]);}
sub do_cmd_cyrg {join('', '�', $_[0]);}
sub do_cmd_CYRG {join('', '�', $_[0]);}
#sub do_cmd_cyrgup {join('', '�', $_[0]);}
#sub do_cmd_CYRGUP {join('', '�', $_[0]);}
sub do_cmd_cyrh {join('', '�', $_[0]);}
sub do_cmd_CYRH {join('', '�', $_[0]);}
sub do_cmd_cyrhrdsn {join('', '�', $_[0]);}
sub do_cmd_CYRHRDSN {join('', '�', $_[0]);}
#sub do_cmd_cyrie {join('', '�', $_[0]);}
#sub do_cmd_CYRIE {join('', '�', $_[0]);}
#sub do_cmd_CYRII {join('', '�', $_[0]);}
#sub do_cmd_cyrii {join('', '�', $_[0]);}
sub do_cmd_cyri {join('', '�', $_[0]);}
sub do_cmd_CYRI {join('', '�', $_[0]);}
sub do_cmd_cyrishrt {join('', '�', $_[0]);}
sub do_cmd_CYRISHRT {join('', '�', $_[0]);}
#sub do_cmd_cyrje {join('', '�', $_[0]);}
#sub do_cmd_CYRJE {join('', '�', $_[0]);}
sub do_cmd_cyrk {join('', '�', $_[0]);}
sub do_cmd_CYRK {join('', '�', $_[0]);}
#sub do_cmd_CYRLJE {join('', '�', $_[0]);}
#sub do_cmd_cyrlje {join('', '�', $_[0]);}
sub do_cmd_cyrl {join('', '�', $_[0]);}
sub do_cmd_CYRL {join('', '�', $_[0]);}
sub do_cmd_cyrm {join('', '�', $_[0]);}
sub do_cmd_CYRM {join('', '�', $_[0]);}
#sub do_cmd_cyrnje {join('', '�', $_[0]);}
#sub do_cmd_CYRNJE {join('', '�', $_[0]);}
sub do_cmd_cyrn {join('', '�', $_[0]);}
sub do_cmd_CYRN {join('', '�', $_[0]);}
sub do_cmd_cyro {join('', '�', $_[0]);}
sub do_cmd_CYRO {join('', '�', $_[0]);}
sub do_cmd_cyrp {join('', '�', $_[0]);}
sub do_cmd_CYRP {join('', '�', $_[0]);}
sub do_cmd_cyrr {join('', '�', $_[0]);}
sub do_cmd_CYRR {join('', '�', $_[0]);}
sub do_cmd_cyrsftsn {join('', '�', $_[0]);}
sub do_cmd_CYRSFTSN {join('', '�', $_[0]);}
sub do_cmd_cyrshch {join('', '�', $_[0]);}
sub do_cmd_CYRSHCH {join('', '�', $_[0]);}
sub do_cmd_cyrsh {join('', '�', $_[0]);}
sub do_cmd_CYRSH {join('', '�', $_[0]);}
sub do_cmd_cyrs {join('', '�', $_[0]);}
sub do_cmd_CYRS {join('', '�', $_[0]);}
sub do_cmd_cyrt {join('', '�', $_[0]);}
sub do_cmd_CYRT {join('', '�', $_[0]);}
#sub do_cmd_cyrtshe {join('', '�', $_[0]);}
#sub do_cmd_CYRTSHE {join('', '�', $_[0]);}
sub do_cmd_cyru {join('', '�', $_[0]);}
sub do_cmd_CYRU {join('', '�', $_[0]);}
#sub do_cmd_cyrushrt {join('', '�', $_[0]);}
#sub do_cmd_CYRUSHRT {join('', '�', $_[0]);}
sub do_cmd_cyrv {join('', '�', $_[0]);}
sub do_cmd_CYRV {join('', '�', $_[0]);}
sub do_cmd_cyrya {join('', '�', $_[0]);}
sub do_cmd_CYRYA {join('', '�', $_[0]);}
#sub do_cmd_cyryi {join('', '�', $_[0]);}
#sub do_cmd_CYRYI {join('', '�', $_[0]);}
sub do_cmd_cyryo {join('', '�', $_[0]);}
sub do_cmd_CYRYO {join('', '�', $_[0]);}
sub do_cmd_cyryu {join('', '�', $_[0]);}
sub do_cmd_CYRYU {join('', '�', $_[0]);}
sub do_cmd_cyrzh {join('', '�', $_[0]);}
sub do_cmd_CYRZH {join('', '�', $_[0]);}
sub do_cmd_cyrz {join('', '�', $_[0]);}
sub do_cmd_CYRZ {join('', '�', $_[0]);}
#sub do_cmd_dots { join('', &iso_map("hellip", ""), $_[0]);}
sub do_cmd_dots { join('', '&#133;', $_[0]);}
#sub do_cmd_guillemotleft { join('', &iso_map("laquo", ""), $_[0]);}
sub do_cmd_guillemotleft { join('', '&#171;', $_[0]);}
#sub do_cmd_guillemotright { join('', &iso_map("raquo", ""), $_[0]);}
sub do_cmd_guillemotright { join('', '&#187;', $_[0]);}
#sub do_cmd_guilsinglleft { join('', &iso_map("lsaquo", ""), $_[0]);}
sub do_cmd_guilsinglleft { join('', '&#139;', $_[0]);}
#sub do_cmd_guilsinglright { join('', &iso_map("rsaquo", ""), $_[0]);}
sub do_cmd_guilsinglright { join('', '&#155;', $_[0]);}
sub do_cmd_lnot { join('', &iso_map("not", ""), $_[0]);}
sub do_cmd_mathdegree { join('', &iso_map("deg", ""), $_[0]);}
sub do_cmd_mathordfeminine { join('', &iso_map("ordf", ""), $_[0]);}
sub do_cmd_mathordmasculine { join('', &iso_map("ordm", ""), $_[0]);}
sub do_cmd_micron { join('', &iso_map("micro", ""), $_[0]);}
sub do_cmd_minus { join('', &iso_map("minus", ""), $_[0]);}
#sub do_cmd_minus { join('', &iso_map("shy", ""), $_[0]);}
sub do_cmd_mu {join('', &iso_map("mu", ""), $_[0]);}
#sub do_cmd_nobreakspace {join('', '�', $_[0]);}
#sub do_cmd_nobreakspace {join('', &iso_map("nbsp", ""), $_[0]);}
sub do_cmd_nobreakspace {join('', '&#160;', $_[0]);}
#sub do_cmd_P { join('', &iso_map("para", ""), $_[0]);}
sub do_cmd_P { join('', '&#182;', $_[0]);}
sub do_cmd_pm { join('', &iso_map("plusmn", ""), $_[0]);}
sub do_cmd_pounds { join('', &iso_map("pound", ""), $_[0]);}
sub do_cmd_quotedblbase { join('', &iso_map("dbquo", ""), $_[0]);}
#sub do_cmd_quotesinglbase { join('', &iso_map("sbquo", ""), $_[0]);}
sub do_cmd_quotesinglbase { join('', '&#130;', $_[0]);}
#sub do_cmd_S { join('', &iso_map("sect", ""), $_[0]);}
sub do_cmd_S { join('', '&#167;', $_[0]);}
sub do_cmd_ss { join('', &iso_map("sz", "lig"), $_[0]);}
sub do_cmd_textbrokenbar { join('', &iso_map("brvbar", ""), $_[0]);}
#sub do_cmd_textbullet { join('', &iso_map("bull", ""), $_[0]);}
sub do_cmd_textbullet { join('', '&#149;', $_[0]);}
sub do_cmd_textcent { join('', &iso_map("cent", ""), $_[0]);}
sub do_cmd_textcurrency { join('', &iso_map("curren", ""), $_[0]);}
#sub do_cmd_textdegree {join('', '�', $_[0]);}
#sub do_cmd_textdegree { join('', &iso_map("deg", ""), $_[0]);}
sub do_cmd_textdegree { join('', '&#176;', $_[0]);}
#sub do_cmd_textemdash { join('', &iso_map("mdash", ""), $_[0]);}
sub do_cmd_textemdash { join('', '&#151;', $_[0]);}
#sub do_cmd_textendash { join('', &iso_map("ndash", ""), $_[0]);}
sub do_cmd_textendash { join('', '&#150;', $_[0]);}
sub do_cmd_texteuro { join('', &iso_map("euro", ""), $_[0]);}
sub do_cmd_textflorin { join('', &iso_map("florin", ""), $_[0]);}
sub do_cmd_textnumero {join('', '&#8470;', $_[0]);}
#sub do_cmd_textperiodcentered {join('', '�', $_[0]);}
sub do_cmd_textperiodcentered { join('', &iso_map("middot", ""), $_[0]);}
sub do_cmd_textperthousand { join('', &iso_map("permil", ""), $_[0]);}
#sub do_cmd_textquotedblleft { join('', &iso_map("ldquo", ""), $_[0]);}
sub do_cmd_textquotedblleft { join('', '&#147;', $_[0]);}
#sub do_cmd_textquotedblright { join('', &iso_map("rdquo", ""), $_[0]);}
sub do_cmd_textquotedblright { join('', '&#148;', $_[0]);}
sub do_cmd_textquoteleft { join('', &iso_map("lsquo", ""), $_[0]);}
sub do_cmd_textquoteright { join('', &iso_map("rsquo", ""), $_[0]);}
sub do_cmd_textregistered { join('', &iso_map("reg", ""), $_[0]);}
#sub do_cmd_texttrademark { join('', &iso_map("trade", ""), $_[0]);}
sub do_cmd_texttrademark { join('', '&#152;', $_[0]);}
sub do_cmd_times { join('', &iso_map("times", ""), $_[0]);}

%koi8_r_character_map
     = (
#    '\\CYRDJE' , '&#128', 
#    '\\@tabacckludge\'\CYRG' , '&#129', 
#    '\\quotesinglbase' , '&#130', 
#    '\\@tabacckludge\'\cyrg' , '&#131', 
#    '\\quotedblbase' , '&#132', 
#    '\\dots' , '&#133', 
#    '\\dag' , '&#134', 
#    '\\ddag' , '&#135', 
#    '\\texteuro' , '&#136', 
#    '\\textperthousand' , '&#137', 
#    '\\CYRLJE' , '&#138', 
#    '\\guilsinglleft' , '&#139', 
#    '\\CYRNJE' , '&#140', 
#    '\\@tabacckludge\'\CYRK' , '&#141', 
#    '\\CYRTSHE' , '&#142', 
#    '\\CYRDZHE' , '&#143', 
#    '\\cyrdje' , '&#144', 
#    '\\textquoteleft' , '&#145', 
#    '\\textquoteright' , '&#146', 
#    '\\textquotedblleft' , '&#147', 
#    '\\textquotedblright' , '&#148', 
#    '\\textbullet' , '&#149', 
#    '\\textendash' , '&#150', 
#    '\\textemdash' , '&#151', 
#    '\\texttrademark' , '&#153', 
#    '\\cyrlje' , '&#154', 
#    '\\guilsinglright' , '&#155', 
#    '\\cyrnje' , '&#156', 
#    '\\@tabacckludge\'\cyrk' , '&#157', 
#    '\\cyrtshe' , '&#158', 
#    '\\cyrdzhe' , '&#159', 
#    '\\nobreakspace' , '&#160', 
#    '\\CYRUSHRT' , '&#161', 
#    '\\cyrushrt' , '&#162', 
#    '\\CYRJE' , '&#163', 
#    '\\textcurrency' , '&#164', 
#    '\\CYRGUP' , '&#165', 
#    '\\textbrokenbar' , '&#166', 
#    '\\S' , '&#167', 
#    '\\CYRYO' , '&#168', 
#    '\\copyright' , '&#169', 
#    '\\CYRIE' , '&#170', 
#    '\\guillemotleft' , '&#171', 
#    '\\lnot' , '&#172', 
#    '\\-' , '&#173', 
#    '\\textregistered' , '&#174', 
#    '\\CYRYI' , '&#175', 
#    'textdegree' , '&#176', 
#    '\\pm' , '&#177', 
#    '\\CYRII' , '&#178', 
#    '\\cyrii' , '&#179', 
#    '\\cyrgup' , '&#180', 
#    '\\mu' , '&#181', 
#    '\\P' , '&#182', 
#    '\\textperiodcentered' , '&#183', 
#    '\\cyryo' , '&#184', 
#    '\\textnumero' , '&#185', 
#    '\\cyrie' , '&#186', 
#    '\\guillemotright' , '&#187', 
#    '\\cyrje' , '&#188', 
#    '\\CYRDZE' , '&#189', 
#    '\\cyrdze' , '&#190', 
#    '\\cyryi' , '&#191', 
       'amp', '&amp;',  # ampersand
       'gt', '&#62;',   # greater than
       'lt', '&lt;',    # less than
       'quot', '&quot;',        # double quote

# These have HTML mnemonic names for HTML 4.0 ...
       'euro',  '&#136;', 
       'sbquo', '&#130;', 
       'florin', '&#131;', 
       'dbquo', '&#132;', 
       'hellip', '&#133;', 
       'dagger', '&#134;', 
       'Dagger', '&#135;', 
       'caret', '&#136;',   # caret accent
       'tilde', '&#152;',   # tilde accent
       'permil', '&#137;',   # 
       'lsaquo', '&#139;',   # 
       'rsaquo', '&#155;',   # 
       'lsquo', '&#145;', 
       'rsquo', '&#146;', 
       'ldquo', '&#147;', 
       'rdquo', '&#148;', 
       'bull', '&#149;', 
       'ndash', '&#150;', 
       'mdash', '&#151;', 
       'trade', '&#152;',   # trademark symbol
       'nbsp', '&#160;',       # non-breaking space
       'curren', '&#164;',     # currency sign
       'brvbar', '&#166;',  
       'sect', '&#167;',       # section mark
       'copy', '&#169;',       # copyright mark
       'laquo', '&#171;', 
       'raquo', '&#187;', 
       'not', '&#172;',
       'shy', '&#173;',
       'reg', '&#174;',
       'deg', '&#176;',
       'plusmn', '&#177;',
       'micro', '&#181;',
       'para', '&#182;',   # paragraph mark
       'middot', '&#183;',

# These are character types without arguments ...
       'grave' , "`",
       'circ', '^',
       'dot', '.',
       'cedil', "&#184;"
	);

%koi8_character_map_inv =
    (
     '^'      , '\\^{}',
     '&#62;'  , '\\ensuremath{>}',
     '&lt;'   , '\\ensuremath{<}',
     '&amp;'  , '\\&',
    '&#128' , '\\CYRDJE', 
    '&#129' , '\\@tabacckludge\'\CYRG', 
    '&#131' , '\\@tabacckludge\'\cyrg', 
    '&#138' , '\\CYRLJE', 
    '&#140' , '\\CYRNJE', 
    '&#141' , '\\@tabacckludge\'\CYRK', 
    '&#142' , '\\CYRTSHE', 
    '&#143' , '\\CYRDZHE', 
    '&#144' , '\\cyrdje', 
    '&#154' , '\\cyrlje', 
    '&#156' , '\\cyrnje', 
    '&#157' , '\\@tabacckludge\'\cyrk', 
    '&#158' , '\\cyrtshe', 
    '&#159' , '\\cyrdzhe', 
    '&#161' , '\\CYRUSHRT', 
    '&#162' , '\\cyrushrt', 
    '&#163' , '\\CYRJE', 
    '&#165' , '\\CYRGUP', 
    '&#168' , '\\CYRYO', 
    '&#170' , '\\CYRIE', 
    '&#175' , '\\CYRYI', 
    '&#178' , '\\CYRII', 
    '&#179' , '\\cyrii', 
    '&#180' , '\\cyrgup', 
    '&#184' , '\\cyryo', 
    '&#185' , '\\textnumero', 
    '&#186' , '\\cyrie', 
    '&#188' , '\\cyrje', 
    '&#189' , '\\CYRDZE', 
    '&#190' , '\\cyrdze', 
    '&#191' , '\\cyryi', 
     '&#126;' , '\\~{}',
     '&#130;' , '\\quotesinglbase{}',
     '&#131;' , '\\textflorin{}',
     '&#132;' , '\\quotedblbase{}',
     '&#133;' , '\\dots{}',
     '&#134;' , '\\dag{}',
     '&#135;' , '\\ddag{}',
     '&#136;' , '\\texteuro{}',
     '&#137;' , '\\textperthousand{}',
     '&#139;' , '\\guilsinglleft{}',
     '&#145;' , '\\textquoteleft{}',
     '&#146;' , '\\textquoteright{}',
     '&#147;' , '\\textquotedblleft{}',
     '&#148;' , '\\textquotedblright{}',
     '&#149;' , '\\textbullet{}',
     '&#150;' , '\\textendash{}',
     '&#151;' , '\\textemdash{}',
     '&#152;' , '\\~{}',
     '&#153;' , '\\texttrademark{}',
     '&#155;' , '\\guilsinglright{}',
	'&#160;' , '\\nobreakspace{}',
	'&#164;' , '\\textcurrency{}',
	'&#166;' , '\\textbrokenbar{}',
     '&#167;' , '\\S{}',
     '&#169;' , '\\copyright{}',
	'&#171;' , '\\guillemotleft{}',
	'&#172;' , '\\ensuremath{\\lnot{}}',
	'&#173;' , '\\-',
#	'&#174;' , '\\textregistered{}',
	 '&#174;' , '\\ensuremath{\\circledR}',
     '&#176;' , '\\ensuremath{^{\\circ}}',
	'&#177;' , '\\ensuremath{\\pm}',
	'&#181;' , '\\ensuremath{\\mu}',
     '&#182;' , '\\P{}',
#	'&#183;' , '\\textperiodcentered{}',
     '&#183;' , '\\cdot{}',
     '&#184;' , '\\c{ }',
	'&#187;' , '\\guillemotright{}',
);

sub russian_titles {
    $toc_title = "����������";
  #  $toc_title = "����������";
    $lof_title = "������ �����������";
    $lot_title = "������ ������";
    $idx_title = "���������� ���������";
  #  $idx_title = "���������� ���������";
    $ref_title = "������ ����������";
  #  $ref_title = "������";
    $bib_title = "����������";
  # $nom_title = "������ �����������";
    $nom_title = "�����������";
    $abs_title = "���������";
    $app_title = "����������";
    $pre_title = "�����������";
    $foot_title = "����������";
  #  $foot_title = "����������";
  #  $foot_title = "������";
    $thm_title = "�������";
    $fig_name = "���.";
  #  $fig_name = "�������";
    $tab_name = "�������";
    $prf_name = "��������������";
    $date_name = "����";
    $page_name = "�.";
  #  $page_name = "���.";
  #  Sectioning-level titles
    $part_name = "�����";
    $chapter_name = "�����";
    $section_name = "��������";
  #  $section_name = "������";
  #  $section_name = "������";
    $subsection_name = "�����";
  #  $subsection_name = "���������";
  #  $subsection_name = "���������";
    $subsubsection_name = "��������";
  #  $subsubsection_name = "������������";
  #  $subsubsection_name = "������";
    $paragraph_name = "�����";
  #  $paragraph_name = "��������";
  #  Misc. strings
  #  $child_name = "���������";
    $child_name = "�������";
    $info_title = "�� ���� ��������� ...";
  #  $info_title = "���������� �� ���� ��������� ...";
    $also_name = "��. �����";
  #  $also_name = "������ �����";
    $russian_see_name = "��.";
  #  $russian_see_name = "������";
    $see_name = $russian_see_name;
  #  names in navigation panels
  #  $next_name = "����.";
    $next_name = "�����";
  #  $next_name = "��������� ������";
  #  $up_name = "����";
    $up_name = "������� ����";
  #  $up_name = "���� �� ���������";
  #  $prev_name = "����.";
    $prev_name = "�����";
  #  $prev_name = "���������� ������";
    $group_name = "������";
  #  $group_name = "�����������";
  #  field names in email headers
    $encl_name = "���.";
    $headto_name = "��.";
    $cc_name = "���.";

    @russian_Month = ('', '������', '�������', '�����', '������', '���',
		      '����', '����', '�������', '��������', '�������',
		      '������', '�������');
    @Month = @russian_Month;
    $GENERIC_WORDS = "�|���|���|��|�|��";
   # $GENERIC_WORDS = "�|���|��";
}

sub russian_today {
    local($today) = &get_date();
    $today =~ s|(\d+)/0?(\d+)/|$2 $russian_Month[$1] |;
    join('',$today,$_[0],' �.');
}

sub russian_seename {
  join('',$russian_see_name,$_[0]);
}

1;
