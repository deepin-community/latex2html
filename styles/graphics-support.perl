# graphics-support.perl
#    by Bruce Miller <bruce.miller@nist.gov>
# Derived from
#  graphics.perl by Herbert Swan <dprhws.edp.Arco.com>  12-22-95
#     and Ross Moore  <ross@mpce.mq.edu.au>  98/1/7
#  but almost completely rewritten by
#     Bruce Miller <bruce.miller@nist.gov> 2001-04-19
# =========
# Extension to LaTeX2HTML to supply support for the "graphics"
# and "graphicx" standard LaTeX2e packages.
#
# When an image name is passed to \includegraphics WITHOUT the extension,
# the LaTeX graphics package searches for files of appropriate formats.
# The dvips driver chooses eps or ps; pdflatex chooses pdf, jpeg or png.
# This package implements similar behaviour for LaTeX2HTML by searching
# for appropriate `web' formats (gif, jpeg, png).
#
# The effects of the various image processing options are either ignored,
# or handled by modifying IMG attributes (eg. WIDTH,HEIGHT),
# or passing the image through a pipeline of netpbm utilities.
#
#======================================================================
# Note 1) Traditionally, l2h passed \includegraphics commands through a 
# pipe of LaTeX | dvips | ghostscript | netpbm utilities to convert the 
# images into .gif or .png.  This mechanism is preserved for hard cases.
#
# Note 2) The graphics package implicitly assumes that files of different
# formats are interchangeable or equivalent. Ie. that foo.eps and foo.gif
# represent the `same' image, including scaling and positioning.  
#   If that is NOT the case, or if a different scaling is desired for the
# different media, you'll have to use other conditional mechanisms of L2h.
#
# Note 3) Some options or combinations of them (particularly viewport, bb,
# w/o clipping set) can create an image larger than its `bounding box'.  
# While this works fine in ps or pdf (the image overlaps the neighboring 
# text), the effect cannot be easily achieved in HTML. This is true even
# when letting LaTeX produce the image! (See note 1).
#
#    ========================================
# Bugs/To Do
#  1) Perhaps it would be useful to recognize \rotatebox, \scalebox, when 
#     wrapped around an \includegraphics and integrate the operations?
#  2) I dont handle any of the file format options (type ext read command).
#     Could do more for any image type XXX where XXXtopnm exists. 
#     (And even leave the result in gif,jpg or png format.)
#     Could even do this automatically with \DeclareGraphicsExtensions,
#     assuming we had a portable `which ${xxx}topnm`.
#    [simply extend HTMLGRAPHICS_MAP and HTMLGRAPHICS_EXTENSIONS]
#  3) No means to provide reasonable ALT tag (or other web specific things).
#    [Ross had a suggestion about a \htmlimage{...} command ]
#  4) I arbitrarily pad with -white.   Also, transparency should be
#   applied only if the original image had it (?).  I presume there's
#   no way to handle png's alpha channel in netpbm.
#  5) I dont know if I'm using l2h's image caching mechanism correctly.
#======================================================================
# User controllable parts:
#   If you want to IGNORE clipping, rotation and/or scaling options, set 
#     $GRAPHICS_HIDECLIP, $GRAPHICS_HIDEROTATE or $GRAPHICS_HIDESCALE
#  in your init file.
#  To force LaTeX to handle the image when these options are invoked, set 
#     $GRAPHICS_PUNTCLIP, $GRAPHICS_PUNTROTATE or $GRAPHICS_PUNTSCALE
#======================================================================
package main;
use POSIX;
use File::Basename;
### use File::Spec;
# Need modified get_image_size.
do_require_package('getimagesize');

#======================================================================
# Settable stuff for initfiles.
#======================================================================
# Names of executable programs from the netpbm utilities

# Check whether an executable has been assigned.  If $$varname is undefined,
# we'll look for one (as $progname).  Otherwise, we'll assume it points to
# an executable, or '', meaning there is none, and it's disabled.
sub check_graphics_util {
  my($varname,$progname)=@_;
  return $$varname if defined($$varname); # If defined (even ''), return that value.
  # WARNING: platform dependent!! (soln: set these vars first)
  my $cmd = `which $progname`;	# Actually, writes to stderr!
  chomp($cmd);
  return $cmd unless !$cmd || $cmd =~ /no $progname /;
  &write_warnings("$progname is not available; need LaTeX for some image effects"); 
  ''; }				# returning '' disables the command.

# Utilities needed for transformations.
$PNMCUT    = check_graphics_util('PNMCUT','pnmcut');
$PNMPAD    = check_graphics_util('PNMPAD','pnmpad');
$PNMFLIP   = check_graphics_util('PNMFLIP','pnmflip');
$PNMSCALE  = check_graphics_util('PNMSCALE','pnmscale');
$PNMQUANT  = check_graphics_util('PNMQUANT','pnmquant');
$PNMROTATE = check_graphics_util('PNMROTATE','pnmrotate');

# Utilities needed for image conversions.
$GIFTOPNM  = check_graphics_util('GIFTOPNM','giftopnm');
$JPEGTOPNM = check_graphics_util('JPEGTOPNM','jpegtopnm');
$PNGTOPNM  = check_graphics_util('PNGTOPNM','pngtopnm');
$TIFFTOPNM = check_graphics_util('TIFFTOPNM','tifftopnm');
$PPMTOGIF  = check_graphics_util('PPMTOGIF','ppmtogif');
$PPMTOJPEG = check_graphics_util('PPMTOJPEG','ppmtojpeg');
$PNMTOPNG  = check_graphics_util('PNMTOPNG','pnmtopng');

# Conversion rules for image types that we have utilities for.
$GRAPHICS_RULE{'.gif'}  = [$GIFTOPNM,$PPMTOGIF]   if $GIFTOPNM && $PPMTOGIF;
$GRAPHICS_RULE{'.jpg'}  = [$JPEGTOPNM,$PPMTOJPEG] if $JPEGTOPNM && $PPMTOJPEG;
$GRAPHICS_RULE{'.jpeg'} = [$JPEGTOPNM,$PPMTOJPEG] if $JPEGTOPNM && $PPMTOJPEG;
$GRAPHICS_RULE{'.png'}  = [$PNGTOPNM,$PNMTOPNG]   if $PNGTOPNM && $PNMTOPNG;
$GRAPHICS_RULE{'.tiff'} = [$TIFFTOPNM,$PPMTOJPEG] if $TIFFTOPNM && $PPMTOJPEG;

# You can add other extensions, such as...
#$GRAPHICS_RULE{'.pict'} = [$PICTTOPPM,$PPMTOJPEG] if $PICTTOPPM && $PPMTOJPEG;
#$GRAPHICS_RULE{'.pcx'}  = [$PCXTOPPM,$PPMTOJPEG] if $PCXTOPPM && $PPMTOJPEG;
#$GRAPHICS_RULE{'.bmp'}  = [$BMPTOPPM,$PPMTOJPEG] if $BMPTOPPM && $PPMTOJPEG;
#$GRAPHICS_RULE{'.sgi'}  = [$SGITOPNM,$PPMTOJPEG] if $SGITOPNM && $PPMTOJPEG;
#$GRAPHICS_RULE{'.xbm'}  = [$XBMTOPBM,$PPMTOJPEG] if $XBMTOPBM && $PPMTOJPEG;
#$GRAPHICS_RULE{'.xwd'}  = [$XWDTOPNM,$PPMTOJPEG] if $XWDTOPNM && $PPMTOJPEG;
# or 'punt' other types
#               '.avi' =>[$ANYTOPNM,$PPMTOJPEG]



# Extensions for html graphics files; we'll look specifically for them.
$GRAPHICS_EXTENSIONS =[grep($GRAPHICS_RULE{$_},  qw(.svg .png .jpg .jpeg .gif .tiff))];

%GRAPHICS_TRANSPARENCY=('.png'=>1, '.gif'=>1);

$GRAPHICS_DPI = 100;


# The path to search for graphics files (extended by \graphicspath)
$GRAPHICS_PATH = [] unless defined($GRAPHICS_PATH);

@GRAPHICS_CLIPOPTS  = qw(viewport trim clip);
@GRAPHICS_SCALEEOPTS = qw(scale width height totalheight keepaspectratio);
@GRAPHICS_ROTATEOPTS= qw(angle origin);

# %GRAPHICS_OPTHIDE : graphics options we'll ignore
# %GRAPHICS_OPTPUNT : graphics options we'll punt to LaTeX.
map($GRAPHICS_OPTHIDE{$_}=1, @GRAPHICS_CLIPOPTS)   if $GRAPHICS_HIDECLIP;
map($GRAPHICS_OPTHIDE{$_}=1, @GRAPHICS_SCALEEOPTS) if $GRAPHICS_HIDESCALE;
map($GRAPHICS_OPTHIDE{$_}=1, @GRAPHICS_ROTATEOPTS) if $GRAPHICS_HIDEROTATE;
map($GRAPHICS_OPTPUNT{$_}=1, @GRAPHICS_CLIPOPTS)   if $GRAPHICS_PUNTCLIP;
map($GRAPHICS_OPTPUNT{$_}=1, @GRAPHICS_SCALEEOPTS) if $GRAPHICS_PUNTSCALE;
map($GRAPHICS_OPTPUNT{$_}=1, @GRAPHICS_ROTATEOPTS) if $GRAPHICS_PUNTROTATE;

map($GRAPHICS_OPTHIDE{$_}=1, qw(draft hiresbb));
map($GRAPHICS_OPTPUNT{$_}=1, qw(type ext read command));

#======================================================================
# Too useful not to define...

sub x_next_arg { # Modifies $_
  my $arg;
  missing_braces unless ((s/$next_pair_pr_rx/$arg=$2;''/e)
			 ||(s/$next_pair_rx/$arg=$2;''/e));
  $arg; }

sub x_next_optarg { # Modifies $_
  my($arg)=get_next_optional_argument();
  $arg; }

#======================================================================
# BRM: modified to remove \Q ..\E from replacement patterns.
# and to save the declared path.
sub do_cmd_graphicspath {
    local($_) = @_;
    local($paths);
    my $paths = x_next_arg();
    $paths = &revert_to_raw_tex($paths);

    #RRM: may only work correctly for Unix    
    # $dd  holds the directory-delimiter, usually / 
    $paths =~ s/\s*(\{|\})\s*/$1/g;
    local(@paths) = split (/}/, $paths);
    if ($DESTDIR eq $FILE) {
	# given paths are relative to parent directory
	map(s|^{([^/~\.\$\\][^}]*)|{..$dd$1|, @paths);
	map(s/^{\.\Q$dd\E/{\.\.$dd/, @paths);
    } elsif ($DESTDIR eq '.') {
	# paths are already relative to working directory
    } else { 
	# specify full paths, by prepending source directory
	map(s|^{([^/~\.\$\\][^}]*)|{$orig_cwd$dd$1|, @paths);
	map(s/^{\.\Q$dd\E/{$orig_cwd$dd/, @paths);
    }
    $paths = join('}', @paths).'}';
    map(s/^{//,@paths);		# Strip leading { and trailing $dd
    map(s/\Q$dd\E$//,@paths);
    $GRAPHICS_PATH = [@$GRAPHICS_PATH,@paths];

    if ($PREAMBLE) {
	# this puts a graphicspath command at the end of the preamble
	# in images.tex.  unfortunately we still get the original
	# graphicspath command earlier in the preamble.
	$preamble .= "\n\\graphicspath{$paths}\n\n";
    } else {
	$latex_body .= "\n\\graphicspath{$paths}\n\n";
    }
    $_; }

# adds ../ if file name begins with ./ or ../
# used to adjust filename in \includegraphics for
# use in images.tex, which will be latex'ed in a subdir
sub find_from_subdir {
    my($file) = @_;
    if ( $file =~ /^\.\.?\Q$dd\E/ ) {
	$file = "..$dd$file";
    }
    $file;
}

sub do_cmd_DeclareGraphicsRule {
    local($_) = @_;
    local($arg1,$arg2,$arg3,$arg4);
    $arg1 = &missing_braces unless (
	(s/$next_pair_pr_rx/$arg1=$&;''/e)
	||(s/$next_pair_rx/$arg1=$&;''/e));
    $arg2 = &missing_braces unless (
	(s/$next_pair_pr_rx/$arg2=$&;''/e)
	||(s/$next_pair_rx/$arg2=$&;''/e));
    $arg3 = &missing_braces unless (
	(s/$next_pair_pr_rx/$arg3=$&;''/e)
	||(s/$next_pair_rx/$arg3=$&;''/e));
    $arg4 = &missing_braces unless (
	(s/$next_pair_pr_rx/$arg4=$&;''/e)
	||(s/$next_pair_rx/$arg4=$&;''/e));
    # need a full path to the filename
    $arg4 =~ s/(\#1)/$orig_cwd$dd$1/g
	unless ($arg4 =~ /^\Q$dd\E|\Q$env_key\E/);
    $latex_body .= "\n".&revert_to_raw_tex(
	'\DeclareGraphicsRule'.$arg1.$arg2.$arg3.$arg4)."\n";
    $_; }

#======================================================================
# Note: I'm trying to mimic the logic of the TeX version, which isn't
# 100% intuitive. Things are mostly not processed in order (except 
# rotate & scale).
#  Bounding Box: bb, bbllx, bblly, bburx, bbury, natwidth, natheight.
#    Although equivalent to viewport & trim, the INTENT apparently is to
#    fix broken ps or eps files.  So, these do NOT modify the image.
#  Clipping: viewport, trim, clip.
#    Unless clip is on, we ignore viewport & trim (Note 3), else use netpbm.
#  Rotation: angle, origin.   
#    The order of rotation & scaling operations is respected in graphicx.
#    We rotate the image using netpbm.  Since origin primarily affects
#    the positioning of the resulting image (See Note 3), I'm currently
#    ignoring it [BUT: what about composition with a clipping viewport?]
#  Scaling: width, height, totalheight, keepaspectratio.
#    Unless netpbm is already being used, simply alter IMG's WIDTH & HEIGHT.
#  Perverse    : type, ext, read, command.
#    Not handled.
#  Ignorable   : draft, hiresbb(?).

# convert_length rounds up to 1 & uses %. Not quite right for here.
#  [convert_length(@_)]->[0];
%BP_conversions=(pt=>72/72.27, pc=>12*(72/72.27), in=>72, bp=>1,
		 cm=>72/2.54, mm=>72/25.4, dd=>(72/72.27)*(1238/1157),
		 cc=>12*(72/72.27)*(1238/1157),sp=>(72/72.27)/65536);
sub to_bp { 
  my($x)=@_;
  my($v,$u);
  $x =~ /^\s*(([+-]?[\d\.]+)?)\s*(\w*|\\\w+(width|height))\s*$/;
  $v = ($1 ? $1 : 1);
  $u = $3;
  # Induce using native image dimensions if given size totally unrecognized
  return '' if($1 eq '' && $3 eq '');
  if ($u =~ /\\\w+(width|height)/) {
    my($w,$h);
    if ($PAPERSIZE) { ($w,$h) = &get_text_size($PAPERSIZE); }
    else { ($w,$h) = &get_text_size("a5"); }
    if ($u =~ /height/) { $u = $h; }
    else { $u = $w; }
  }
  elsif ($u eq 'em' || $u eq 'ex') {
    $u = $LATEX_FONT_SIZE;
    $u = 12 if ($u < 1);
  }
  else { $u = $u ? $BP_conversions{$u} : 1; }
  #$u *= $FIGURE_SCALE_FACTOR*0.8;	# just an extra empirical coefficient
  $v*$u; }

# Return numeric width and height of text area depending on paper format
# Analogous to adjust_textwidth, used for \includegraphics
sub get_text_size {
    local($_) = @_;
    local($width,$length) = ('','');
    if (/a4/) {$width = 595; $length= 842; }
    elsif (/letter/) {$width = 612; $length= 792; }
    elsif (/legal/) {$width = 612; $length= 1008; }
    elsif (/note/) {$width = 540; $length= 720; }
    elsif (/b5/) {$width = 501; $length= 709; }
    elsif (/a5/) {$width = 421; $length= 595; }
    elsif (/a6/) {$width = 297; $length= 421; }
    elsif (/a7/) {$width = 210; $length= 297; }
    elsif (/a8/) {$width = 148; $length= 210; }
    elsif (/a9/) {$width = 105; $length= 148; }
    elsif (/a10/) {$width = 74; $length= 105; }
    elsif (/b4/) {$width = 709; $length= 1002; }
    elsif (/a3/) {$width = 842; $length= 1190; }
    elsif (/b3/) {$width = 1002; $length= 1418; }
    elsif (/a2/) {$width = 1190; $length= 1684; }
    elsif (/b2/) {$width = 1418; $length= 2004; }
    elsif (/a1/) {$width = 1684; $length= 2380; }
    elsif (/b1/) {$width = 2004; $length= 2836; }
    elsif (/a0/) {$width = 2380; $length= 3368; }
    elsif (/b0/) {$width = 2836; $length= 4013; }
    else {
	&write_warnings("\nPAPERSIZE: $_ unknown, using a5.");
	$width = 421; $length= 595;
    }
    if ($width > 500) { $width = $width - 144; $length = $length - 288; }
    elsif ($width > 250) { $width = $width - 72; $length = $length - 144; }
    elsif ($width > 125) { $width = $width - 36; $length = $length - 72; }

    # Evtl adjust according to wrapfigure dimensions
    if ($wrapfigure_width) {	# defined inside wrapfigure only
      my($pxs,$len) = &convert_length($wrapfigure_width, 1);
      if ($pxs =~ s/%$//) {	# scale width and length by percent
	$width  *= $pxs/100;
	$length *= $pxs/100;
      } else { # revert scaling, set explicit width, recalculate length
	$pxs /= $FIGURE_SCALE_FACTOR*0.8;
	$length *= $pxs/$width;
	$width = $pxs;
      }
    }

    # Evtl adjust according to minipage dimensions (possibly nested)
    if ($MINIPAGE) {
      my($i, $mw);
      for ($i=0; $i<$MINIPAGE; $i++) {
	$mw = $minipage_width[$i];
	if ($mw =~ s/%$//) {	# scale width and length by percent
	  $width  *= $mw/100;
	  $length *= $mw/100;
	} else { # revert scaling, set explicit width, recalculate length
	  $mw /= $MATH_SCALE_FACTOR*$FIGURE_SCALE_FACTOR*0.8;
	  $length *= $mw/$width;
	  $width = $mw;
	}
      }
    }

    # Round results and return
    $width  = sprintf("%.0f", $width);
    $length = sprintf("%.0f", $length);
    ($width, $length);
}

sub scaled_image_size {
  my($imagew,$imageh, $reqw,$reqh,$scale,$keepaspect)=@_;
  if($reqw && $reqh && $keepaspect){ # If keeping aspect ratio, ignore a req.
    ($reqw/$imagew < $reqh/$imageh ? $reqh : $reqw) = 0; }
  if($reqw && $reqh){}
  elsif($reqw){ $reqh = $imageh*$reqw/$imagew; }
  elsif($reqh){ $reqw = $imagew*$reqh/$imageh; }
  elsif($scale){ $reqw = $imagew*$scale; $reqh = $imageh*$scale; }
  else{ $reqw=$imagew; $reqh=$imageh; }
  (ceil($reqw),ceil($reqh)); }

$GRAPHICS_NIMAGES=0;

sub fall_back_to_latex_image {
    my ($src, $origcall, $save) = @_;
    print "\nLaTeX image $src" if ($VERBOSITY > 1);
    join('',process_in_latex($origcall),$save);
}

sub do_includegraphics {
  my($file,$options,$origcall)=@_;
  my $save = $_;
  my $quiet = ($VERBOSITY > 1 ? '' : ' -quiet');
  local $_;
  # --------------------------------------------------
  # Parse options
  my ($v,@bb,@vp,$clip,$trim,$rqw,$rqh,$rqs,$aspect,$a,$rotfirst, $punt);
  foreach (split(',',$options)){
    /^\s*(\w+)(=\s*(.*))?\s*$/;  $_=$1; $v=$3;
    if($GRAPHICS_OPTHIDE{$_}){ next; } # Ignore this option
    if($GRAPHICS_OPTPUNT{$_}){ $punt=1; last; } # This one we can't handle.
    if   (/^bb$/)               { @bb = map(to_bp($_),split(' ',$v)); }
    elsif(/^bb(ll|ur)(x|y)$/)   { $bb[2*/ur/ + /y/] = to_bp($v); }
    elsif(/^nat(width|height)$/){ $bb[2 + /width/] = to_bp($v); }
    elsif(/^viewport$/)         { @vp = map(to_bp($_),split(' ',$v)); $trim=0;}
    elsif(/^trim$/)             { @vp = map(to_bp($_),split(' ',$v)); $trim=1;}
    elsif(/^clip$/)             { $clip = !($v eq 'false'); }
    elsif(/^keepaspectratio$/)  { $aspect = !($v eq 'false'); }
    elsif(/^width$/)            { $rqw = to_bp($v); }
    elsif(/^(total)?height$/)   { $rqh = to_bp($v); }
    elsif(/^scale$/)            { $rqs = $v; }
    elsif(/^angle$/)            { $a = $v; $rotfirst = !($rqw||$rqh||$rqs); }
    elsif(/^origin$/)           { } # ??
    else { &write_warnings("Unrecognized option $_ to \\includegraphics"); }}
  # --------------------------------------------------
  # Fall back to letting LaTeX generating the image.
  $file =~ /(\.[^\.]+)$/;
  my $ext = $1;
  my $src;
  if( $punt || ($ext && !$GRAPHICS_RULE{$ext}) ||
     !($src=find_file($file,$GRAPHICS_PATH, $GRAPHICS_EXTENSIONS))){
    &fall_back_to_latex_image($src,$origcall,$save); }
  # --------------------------------------------------
  # We'll work with the web image.
  else {
    my($name,$path,$ext)=fileparse($src,@$GRAPHICS_EXTENSIONS);
    my ($ignore,$ignore,$w,$h) = get_image_size($src,1);
    # Just assume a fixed dpi ?
    my($Wf,$Hf)=($GRAPHICS_DPI/72.0,$GRAPHICS_DPI/72.0);
    # --------------------------------------------------
    # Simple case: Just scale the image via IMG attributes.
    if(!$a && !($clip && @vp)){
      ($w,$h)=scaled_image_size($w,$h, $rqw*$Wf,$rqh*$Hf,$rqs,$aspect);
      my $dst = "./$name$ext";
      print "\nReuse $src scaled to $w x $h" if ($VERBOSITY > 1);
      (L2hos->Copy($src,$dst) or # Would be nice to preserve timestamps, too.
       &write_warnings("\\includegraphics couldn't copy $src to tree: $!\n"))
	unless (-f $dst) && (-M $dst < -M $src); 
      my ($img, $imgsize) = embed_image($dst,'web image',0,"Image $name", 
					'','','','','',
					qq(WIDTH="$w" HEIGHT="$h"));
      join('',$img,$save); }
    # --------------------------------------------------
    # Complicated case: but if netpbm utilities are not available...
    elsif ($ALWAYS_USE_LATEX) {
	&fall_back_to_latex_image($src,$origcall,$save); }
    # --------------------------------------------------
    # Complicated case: pipe the image through netpnm utilities.
    else {
      my @missing_utils = ();
      # Attempt to leverage l2h's cache.
      my $cacheid = "IG$name";
      my $cmd = $GRAPHICS_RULE{$ext}->[0];
      if (!$cmd) {
	&write_warnings("Utility unavailable to process $ext file: $src ");
	return (&fall_back_to_latex_image($src,$origcall,$save));
      }
      my $pipe = "$cmd $quiet $src";
      # 1: Perform any cutting or padding based on viewport or trim options.
      if(@vp && $clip){
	my($x0,$y0,$x1,$y1)=(floor($Wf*$vp[0]),floor($h-$Hf*$vp[3]),
			     ceil($Wf*$vp[2]), ceil($h-$Hf*$vp[1])); 
	if($trim){ $y0=floor($Hf*$vp[3]); $x1 = ceil($w-$Wf*$vp[2]); }
	if(($x0 < 0)||($y0 < 0)||($x1 > $w)||($y1 > $h)){
	  push (@missing_utils,'pnmpad') unless $PNMPAD;
	  $pipe .= " | $PNMPAD$quiet -white"
	    .($x0 < 0 ? " -l".-$x0 : '').($x1 > $w ? " -r".($x1-$w) : '')
	    .($y0 < 0 ? " -t".-$y0 : '').($y1 > $h ? " -b".($y1-$h) : ''); }
	if(($x0 > 0)||($y0 > 0)||($x1 < $w)||($y1 < $h)){
	  push (@missing_utils,'pnmcut') unless $PNMCUT;
	  $pipe .= " | $PNMCUT$quiet "
	    .($x0 > 0 ? $x0 : '0').' '.($y0 > 0 ? $y0 : '0').' '
	    .($x1 < $w ? ($x1-$x0) : '0').' '.($y1 < $h ? ($y1-$y0) : '0'); }
	($w,$h)=($x1-$x0,$y1-$y0);
	$cacheid .= "|T$x0,$y0,$x1,$y"; }
      # 2: Perform any pre-scaling.
      if(!$rotfirst && ($rqw||$rqh||$rqs)){
	($w,$h)=scaled_image_size($w,$h, $rqw*$Wf,$rqh*$Hf,$rqs,$aspect);
	push (@missing_utils,'pnmscale') unless $PNMSCALE;
	push (@missing_utils,'pnmquant') unless $PNMQUANT;
	$pipe .= " | $PNMSCALE$quiet -width $w -height $h"; 
	$pipe .= " | $PNMQUANT$quiet 255";
	$cacheid .= "|S$w,$h"; }
      # 3: Perform any rotation
      if($a){
	my $q;			# operate in 1st quadrant.
	$a -= 360*floor($a/360); $q = floor($a/90); $a -= $q*90;
	my ($c,$s)=(cos($a*3.1415926/180),sin($a*3.1415926/180));
	if($a != 0){		# Wrap in pad/cut to set background color!
	  my($dx,$dy)=(ceil($c*$s*($h+4)),ceil($c*$s*($w+4)));
	  push (@missing_utils,'pnmpad') unless $PNMPAD;
	  push (@missing_utils,'pnmrotate') unless $PNMROTATE;
	  push (@missing_utils,'pnmcut') unless $PNMCUT;
	  $pipe .= " | $PNMPAD$quiet -white -l$dx -r$dx -t$dy -b$dy";
	  $pipe .= " | $PNMROTATE$quiet $a";
	  ($w,$h)=(ceil(abs($c*$w)+abs($s*$h)),ceil(abs($s*$w)+abs($c*$h)));
	  ($dx,$dy)=(ceil($c*$dx+$s*$dy),ceil($s*$dx+$c*$dy));
	  $pipe .= " | $PNMCUT$quiet $dx $dy $w $h";
	}
	if ($q) {
	  push (@missing_utils,'pnmflip') unless $PNMFLIP;
	  $pipe .= "| $PNMFLIP$quiet ".('','-xy -tb','-lr -tb','-xy -lr')[$q];
	}
	($w,$h)=($h,$w) if $q%2; 
      	$cacheid .= "|R$a,$q"; }
      # 4: Perform any post-scaling.
      if($rotfirst && ($rqw||$rqh||$rqs)){
	($w,$h)=scaled_image_size($w,$h, $rqw*$Wf,$rqh*$Hf,$rqs,$aspect);
	push (@missing_utils,'pnmscale') unless $PNMSCALE;
	push (@missing_utils,'pnmquant') unless $PNMQUANT;
	$pipe .= " | $PNMSCALE$quiet -width $w -height $h"; 
	$pipe .= " | $PNMQUANT$quiet 255";
	$cacheid .= "|S$w,$h"; }
      #  ----------------------
      if(@missing_utils) {
	&write_warnings(join(" ",@missing_utils)
		." unavailable to process $ext file: $src ");
	return (&fall_back_to_latex_image($src,$origcall,$save));
      }
      #  ----------------------
      # Pipe & cacheid are constructed. See if we can reuse, else run the pipe.
      my $img = $cached_env_img{$cacheid};
      if(!$img){		# Need to generate the image.
	print "\nProcess $src ($cacheid)\n" if ($VERBOSITY > 1);
	my $dst = "IGimg".++$GRAPHICS_NIMAGES.$ext;
	# Best would be to do this IFF the original were transparent!
	my $tr=($TRANSPARENT_FIGURES && $GRAPHICS_TRANSPARENCY{$ext} 
		? " -transparent white" : '');
	$cmd = $GRAPHICS_RULE{$ext}->[1];
	if (!$cmd) {
	  &write_warnings("Utility unavailable to process $ext file: $src ");
	  return (&fall_back_to_latex_image($src,$origcall,$save));
	}
	$pipe .= " | $cmd $quiet $tr > $dst";
        print "\ngraphics: $pipe\n" if ($VERBOSITY > 1);
	system($pipe)==0 || 
	  &write_warnings("\\includegraphics processing of $src failed! $!");
	my $imgsize;
	($img, $imgsize) = embed_image($dst,'web image',0,"Image $name",
				       '','','','','',
				       qq(WIDTH="$w" HEIGHT="$h"));
	$cached_env_img{$cacheid}=$img; }

      join('',$img,$save);
	} # end of 'pipe through netpbm utilities'
    } # end of 'work with the web image'
}

#======================================================================

# Attempt to get a PS Bounding Box for $file.
sub ps_boundingbox{
  my($file)=@_;
  my(@bb,$f);
  if(($f=find_file($file,$GRAPHICS_PATH,['.eps','.ps','.bb'])) && open(PS,$f)){
	binmode PS;
    while(<PS>){
      if(/^%%BoundingBox:\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s*$/){
	@bb=($1,$2,$3,$4); last; }}
    close(PS); }
  &write_warnings("No bounding box found for $file") unless @bb;
  return @bb; }
    
# Find a file in a set of directories, with one of a set of file extensions.
sub find_file {
  my($file,$dirs,$exts)=@_;
  my($name,$dir0,$ext)=fileparse($file,@$exts);
  $exts=[$ext] if $ext;		# Given extension? We're stuck with it.
#  $dirs = (File::Spec->file_name_is_absolute($file) ? [''] # Abs path? Stuck!
  $dirs = (L2hos->is_absolute_path($file) ? [''] # Abs path? Stuck!
	   : [@$dirs,$texfilepath]); # Else, include tex search path too.
  my($dir);
  foreach $dir (@$dirs){
    foreach $ext (@$exts){
#      my $path = File::Spec->catfile($dir,$dir0,"$name$ext");
      my $path = "$dir$dd$dir0$name$ext";
      return $path if (-f $path); }}
  return ''; }

#======================================================================

#&process_commands_wrap_deferred (<<_RAW_ARG_CMDS_);
#graphicspath # {}
#_RAW_ARG_CMDS_

&process_commands_in_tex (<<_RAW_ARG_CMDS_);
rotatebox # [] # {} # {}
scalebox # {} # [] # {}
reflectbox # {}
resizeboxstar # {} # {} # {}
resizebox # {} # {} # {}
_RAW_ARG_CMDS_

&process_commands_nowrap_in_tex (<<_RAW_ARG_CMDS_);
DeclareGraphicsExtensions # {}
psfragstar # {} # {}
psfrag # {} # {}
_RAW_ARG_CMDS_

&ignore_commands( <<_IGNORED_CMDS_);
setkeys # {} # {}
_IGNORED_CMDS_

#======================================================================
1;	# Must be last line

