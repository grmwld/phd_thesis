% To use this style - say something like:
%  for dull, boring thesis format:
%	\documentclass[12pt]{mitthesis}
%       \pagestyle{plain}
% OR for fast drafts: 
%	\documentclass[11pt,singlespace,draft]{mitthesis}
%	\pagestyle{drafthead}
% OR for Tech Reports:
%	\documentclass[12pt,twoside]{mitthesis}	
%	\pagestyle{headings}
% OR
%  some other combination...
%
%%%% New options:
% 
% Option `twoside':
%   Good for producing Tech Reports.
%   The default is single-sided printing, which is what M.I.T. wants on the
%   thesis document itself.
%
% Option `singlespace':
%   Good for drafts.
%   Double-spaced theses are the default.
%   That is what M.I.T. asks for in the formal specifications.
%
%   To get singlespacing in an area - Use  the 'singlespace' environment. 
%
% Option `draft':
%   Puts `overfull' boxes at the end of lines that are too long. 
%
% Pagestyle `drafthead':
%   Puts the date and the label ``*DRAFT*'' in the footer.
%
%%%%%%%%%%
%
%%%%%%%% Newer additions 
%
% documentclass options - 
% vi		For MIT course VI or VIII thesis - will copyright the thesis to
% 		you while giving MIT permission to copy and distribute it.
% upcase	Will put much of the cover page in uppercase, as per the
% 		example on page 17 of the *Specifications for Thesis
% 		Preparation*, (revised 1989)
% Also added ``All Rights Reserved'' to default copyright notice.
%
%%%%%%%%%%%
%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mitthesis}[1999/10/20]

\def\mystretch{1.5}		% Double spacing hack
\DeclareOption{doublespace}{}	% This is default
				% So we do not read this style twice
\DeclareOption{singlespace}{		% If he explicitly wants single spacing
    \typeout{Single spaced}
    \def\mystretch{1}}	

%% `vi' and `upcase' document style options.  Krishna Sethuraman (1990)
\newcount\vithesis
\DeclareOption{vi}{\typeout{Course VI/VIII thesis style.}\advance\vithesis by1}
\vithesis=0

\DeclareOption{upcase}{\typeout{Uppercase cover page.}
	\gdef\choosecase#1{\uppercase\expandafter{#1}}}
\def\choosecase#1{#1}

%% leftblank option by Kevin Fu
\newif\if@leftblank \@leftblankfalse

\DeclareOption{leftblank}{\typeout{Intentionally Leaving Pages Blank}
\@leftblanktrue}

%  Thesis looks much like report
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions
\LoadClass[]{report}

% If the user wants single spacing, set baselinestretch=1.

\usepackage{setspace}

% Note - doublespace.sty has some float-related troubles in
% combination with graphics or color, and is not officially compliant
% with 2e.  setspace is a replacement which is 2e-compliant.

% Read the doublespace style that we got from Rochester:
%\input setdoublespace.sty 		

\def\baselinestretch{\mystretch}	% Double spacing hack

%%%%%%%  Set up margins and formatting params %%%

% Margins.
%  Note we want 1in top margin assuming no header line, so push header
%	into 1in margin.
%  Draft mode brings the header back down.

\setlength{\topmargin}{-25pt}
\setlength{\headsep}{35pt}
\setlength{\headheight}{16pt}
\setlength{\footskip}{45pt}
\setlength{\textheight}{660pt}
\setlength{\textwidth}{400pt}
\addtolength{\evensidemargin}{-10pt}
\setlength{\marginparsep}{8pt}
\setlength{\marginparwidth}{99pt}

% The next two macros compensate page style for headers and footers
% We only need them in page styles that USE headers and footers.
    % If we have a header, it must be 1in from top of page.
\def\pulldownheader{			% Shift header down 1in from top
    \addtolength{\topmargin}{\headheight}	
    \addtolength{\topmargin}{\headsep}	
    \addtolength{\textheight}{-\headheight}
    \addtolength{\textheight}{-\headsep}
}
    % If we have a footer, put it 1in up from bottom
\def\pullupfooter{				% Shift footer up
    \addtolength{\textheight}{-\footskip}
%    \addtolength{\textheight}{-\footheight}  %footheight doesn't
%    						exist in 2e
}

%%%%%%%  End of margins and formatting params %%%

%%%%%%%  Fix various header and footer problems %%%

% Draft mark on the right side of left pages (outside)
% this mark is also the only one visible on single sided.
\newcommand{\draftrmark}{**DRAFT**} 
% Draft mark on the left side of right pages (outside)
\newcommand{\draftlmark}{**DRAFT**} % 

% Macros to make changing the Draft easier
\newcommand{\drmark}[1]{\renewcommand{\draftrmark}{#1}}
\newcommand{\dlmark}[1]{\renewcommand{\draftlmark}{#1}}
\newcommand{\dmark}[1]{\drmark{#1}\dlmark{#1}}

% Format for draft of thesis.  Define our own PageStyle -
% Just like headings, but has foot lines with the date and warning

\if@twoside         % If two-sided printing.
\def\ps@drafthead{
    \let\@mkboth\markboth
    \def\@oddfoot{\rm \today \hfil \sc \draftrmark}
    \def\@evenfoot{\sc \draftlmark \hfil \rm \today }
    \def\@evenhead{\rm \thepage\hfil \sl \leftmark}
    \def\@oddhead{\hbox{}\sl \rightmark \hfil \rm\thepage}
    \def\chaptermark##1{\markboth {\uppercase{\ifnum \c@secnumdepth >\m@ne
	\@chapapp\ \thechapter. \ \fi ##1}}{}}
    \def\sectionmark##1{\markright {\uppercase{\ifnum \c@secnumdepth >\z@
	\thesection. \ \fi ##1}}}
    \pulldownheader				% Bring header down from edge
    \pullupfooter				% Bring footer up
}
\else               % If one-sided printing.
\def\ps@drafthead{
    \let\@mkboth\markboth
    \def\@oddfoot{\rm \today \hfil \sc \draftrmark}
    \def\@oddhead{\hbox{}\sl \rightmark \hfil \rm\thepage}
    \def\chaptermark##1{\markright {\uppercase{\ifnum \c@secnumdepth >\m@ne
	\@chapapp\ \thechapter. \ \fi ##1}}}
    \pulldownheader				% Bring header down from edge
    \pullupfooter				% Bring footer up
}
\fi

% I redefine these formats that were defined in report.sty
% Definition of 'headings' page style 
%  Note the use of ##1 for parameter of \def\chaptermark inside the
%  \def\ps@headings.
%

\if@twoside					% If two-sided printing.
\def\ps@headings{\let\@mkboth\markboth
    \def\@oddfoot{}
    \def\@evenfoot{}		% No feet.
    \def\@evenhead{\rm \thepage\hfil \sl \leftmark}	% Left heading.
    \def\@oddhead{\hbox{}\sl \rightmark \hfil \rm\thepage}	% Right heading.
    \def\chaptermark##1{\markboth {\uppercase{\ifnum \c@secnumdepth >\m@ne
	\@chapapp\ \thechapter. \ \fi ##1}}{}}	
    \def\sectionmark##1{\markright {\uppercase{\ifnum \c@secnumdepth >\z@
	\thesection. \ \fi ##1}}}
    \pulldownheader				% Bring header down from edge
}
\else						% If one-sided printing.
\def\ps@headings{\let\@mkboth\markboth
    \def\@oddfoot{}
    \def\@evenfoot{}		%     No feet.
    \def\@oddhead{\hbox {}\sl \rightmark \hfil \rm\thepage}	% Heading.
    \def\chaptermark##1{\markright {\uppercase{\ifnum \c@secnumdepth >\m@ne
	\@chapapp\ \thechapter. \ \fi ##1}}}
    \pulldownheader				% Bring header down from edge
}
\fi

% Redefinition of 'myheadings' page style.  
%
\def\ps@myheadings{
  \let\@mkboth\@gobbletwo
  \def\@oddfoot{}
  \def\@evenfoot{}
  \def\sectionmark##1{}
  \def\subsectionmark##1{}
  \def\@evenhead{\rm \thepage\hfil\sl\leftmark\hbox {}}	%
  \def\@oddhead{\hbox{}\sl\rightmark \hfil \rm\thepage}	%
  \pulldownheader				% Bring header down from edge
}

\pretolerance=10000

%%%%%%%%%  End of Style parameters %%%%

%%%%%%%%%  Default packages   %%%%%%%%%

% Better justification
\usepackage{ragged2e}
%\renewcommand{\RaggedLeft}{\raggedleft}
%\renewcommand{\RaggedRight}{\raggedright}

\usepackage{tocloft}
\renewcommand{\cftchapafterpnum}{\vspace{10pt}}
\setlength{\cftbeforesecskip}{7pt}
\renewcommand{\cftsecafterpnum}{\vspace{3pt}}

\usepackage{setspace}

% fancy headers and footers
\usepackage{fancyhdr}
\fancypagestyle{plain}{
	\fancyhf{}
	\fancyfoot[LE]{\thepage}
	\fancyfoot[RO]{\thepage}
	\renewcommand{\headrulewidth}{0pt}
}
\fancypagestyle{plainwheader}{
	\fancyhf{}
	\fancyhead[RE]{\slshape \rightmark}
	\fancyhead[LO]{\slshape \leftmark}
	\fancyfoot[LE]{\thepage}
	\fancyfoot[RO]{\thepage}
	\renewcommand{\headrulewidth}{0.4pt}
}

% Customize titles headings
\usepackage{titlesec}

\let\oldpart\part
\renewcommand{\part}[1]{
  \cleardoublepage
  \oldpart{#1}
  \cleardoublepage
}

% Customize chapter heading
\titleformat{\chapter}[display]
	{\normalfont\Large\RaggedLeft}
	{\MakeUppercase{\chaptertitlename}
		\rlap{\resizebox{!}{1.2cm}{\thechapter} \rule{15cm}{1.2cm}}
	}
	{10pt}{\Huge}
\titlespacing*{\chapter}{0pt}{30pt}{100pt}

% Redefine '/chapter' to always start on an odd page.
% Should make no difference in singleside mode.
\if@leftblank
% Prints "THIS PAGE INTENTIONALLY LEFT BLANK" on blank pages.
  \def\chapter{
    \clearpage\ifodd\c@page\else
  	\hbox{}\par\vfill\centerline%
  	{THIS PAGE INTENTIONALLY LEFT BLANK}%
  	\vfill\newpage\fi
  	\thispagestyle{plain}	% Page style of chapter page is 'plain'
  	\global\@topnum\z@		% Prevents figures from going at top of page.
  	\@afterindentfalse		% Suppresses indent in first paragraph.  Change
  	\secdef\@chapter\@schapter}	% to \@afterindenttrue to have indent.
\else
  \def\chapter{
    \cleardoublepage	% Starts new page.
  	\thispagestyle{plain}	% Page style of chapter page is 'plain'
  	\global\@topnum\z@		% Prevents figures from going at top of page.
  	\@afterindentfalse		% Suppresses indent in first paragraph.  Change
  	\secdef\@chapter\@schapter}	% to \@afterindenttrue to have indent.
\fi

% If using the report style, use - instead of . in the figure number.
%\@ifundefined{thechapter}{}{\def\thefigure{\thechapter-\arabic{figure}}}

%\titleclass{\section}{top}
%\newcommand{\sectionbreak}{\clearpage}
%\newcommand\mysection{\vfil\penalty-9999\vfilneg\section}

\titleformat{\section}
	{\normalfont\Large\bfseries\RaggedRight}{\thesection}{1em}{}

\titleformat{\subsection}
	{\normalfont\large\bfseries\RaggedRight}{\thesubsection}{0.5em}{}

\titleformat{\subsubsection}
	{\normalfont\bfseries\RaggedRight}{\thesubsubsection}{0.5em}{}


% New page on each section except first from chapter
\usepackage{etoolbox}
%\preto{\section} {
%	\ifnum\value{section}=0 \else\clearpage\fi
%}
% Separate figures by chapters in LOF
%\preto\figure{%
%  \ifnum\value{figure}=0\addtocontents{lof}{{\bfseries Chapitre \thechapter\vskip10pt}}\fi
%}
% Separate tables by chapters in LOT
%\preto\table{%
%  \ifnum\value{table}=0\addtocontents{lot}{{\bfseries Chapitre \thechapter\vskip10pt}}\fi
%}
\newtoggle{deadtree}

% Regional settings and encoding
\usepackage[french]{babel}
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage{fixltx2e}

% More math symbols
\usepackage{amsmath}
\usepackage{amssymb}

% Better figure placement
\usepackage{float}

% Side captions
\usepackage{sidecap}

% Split figures on multiple pages
%\usepackage[caption=false]{subfig}
\usepackage{subcaption}

% Better caption style
\usepackage[font=small,labelfont=bf]{caption}

% Insert pictures
\usepackage{graphicx}
%\usepackage[pdftex]{graphicx}

% Subfile
\usepackage{subfiles}

% For colors. Used in particular for the cover
%\usepackage{color}
%\usepackage{afterpage}% for "\afterpage"
%\usepackage[usenames,dvipsnames,svgnames,table]{xcolor}
%\usepackage{pagecolor}% With option pagecolor={somecolor or none}

% Show numbering up to depth level 3
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}

% Hyperlinks
\usepackage{hyperref}
\hypersetup{
    colorlinks,
    citecolor=black,
    filecolor=black,
    linkcolor=black,
    urlcolor=black,
    linktoc=all
}
%\def\chapterautorefname{Chapter \thechapter, Section}
%\def\sectionautorefname{Chapter \thechapter, Section}

% Enhanced bibliography
%\usepackage{refcheck}
\usepackage[round]{natbib}
\setlength{\bibsep}{0.5pt plus 0.3ex}
\def\bibfont{\footnotesize}

% List of abreviations (glossary)
\usepackage[nomain,acronym,nonumberlist]{glossaries}
%%%%%%%%%   Configure multi-lang glossaries   %%%%%%%%%
%% Based on http://tex.stackexchange.com/a/145765/45511
%%
%% Example usage:
%%
%%	\newacronym[
%%		longfr={transporteur d'ions monocarboxylate},
%%		longplfr={transporteurs d'ions monocarboxylate},
%%		longplural={monocarboxylate transporters}]
%%		{mct}
%%		{MCT}
%%		{monocarboxylate transporter}
%%
%% Output:
%%
%% [...] transporteurs d’ions monocarboxylate (MCTs, monocarboxylate transporters) [...]
%%

% Add new key for long french form:
\glsaddkey
{longfr}% key
{}% default value
{\glsentrylongfr}% new command analogous to \glsentrylong
{\Glsentrylongfr}% new command analogous to \Glsentrylong
{\acrlongfr}% new command analogous to \acrlong
{\Acrlongfr}% new command analogous to \Acrlong
{\ACRlongfr}% new command analogous to \ACRlong

% Add new key for plural long french form:
\glsaddkey
{longplfr}% key
{}% default value
{\glsentrylongplfr}% new command analogous to \glsentrylongpl
{\Glsentrylongplfr}% new command analogous to \Glsentrylongpl
{\acrlongplfr}% new command analogous to \acrlongpl
{\Acrlongplfr}% new command analogous to \Acrlongpl
{\ACRlongplfr}% new command analogous to \ACRlongpl

% Provide conditional to test if longfr/longplfr has been set
\newcommand*{\glsifhaslongfr}[3]{%
  \ifcsempty{glo@#1@longfr}{#3}{#2}%
}
\newcommand*{\glsifhaslongplfr}[3]{%
  \ifcsempty{glo@#1@longplfr}{#3}{#2}%
}

%% Define new acronym style:
%
%\newacronymstyle{french}
%{% base the display style on 'long-short'
%  \GlsUseAcrEntryDispStyle{long-short}%
%}%
%{% base the definitions on 'long-short'
%  \GlsUseAcrStyleDefs{long-short}%  
%% Make some custom modifications for the first use display.
%% Singular, no case change:
%  \renewcommand*{\genacrfullformat}[2]{%
%   \glsifhaslongfr{##1}%
%   {% has french version:
%      \glsentrylongfr{##1}##2\space
%      (\firstacronymfont{\glsentryshort{##1}}, \glsentrylong{##1})%
%   }%
%   {%
%     \glsentrylong{##1}##2\space
%     (\firstacronymfont{\glsentryshort{##1}})%
%   }%
%  }%
%% Singular, first letter upper case:
%  \renewcommand*{\Genacrfullformat}[2]{%
%   \glsifhaslongfr{##1}%
%   {% has french version:
%      \Glsentrylongfr{##1}##2\space
%      (\firstacronymfont{\glsentryshort{##1}}, \glsentrylong{##1})%
%   }%
%   {%
%     \Glsentrylong{##1}##2\space
%     (\firstacronymfont{\glsentryshort{##1}})%
%   }%
%  }%
%% Plural, no case change:
%  \renewcommand*{\genplacrfullformat}[2]{%
%   \glsifhaslongplfr{##1}%
%   {% has french version:
%      \glsentrylongplfr{##1}##2\space
%      (\firstacronymfont{\glsentryshortpl{##1}}, \glsentrylongpl{##1})%
%   }%
%   {%
%     \glsentrylongpl{##1}##2\space
%     (\firstacronymfont{\glsentryshortpl{##1}})%
%   }%
%  }%
%% Plural, first letter upper case:
%  \renewcommand*{\Genplacrfullformat}[2]{%
%    \glsifhaslongplfr{##1}%
%    {% has french version:
%      \Glsentrylongplfr{##1}##2\space
%      (\firstacronymfont{\glsentryshortpl{##1}}, \glsentrylongpl{##1})%
%    }%
%    {%
%      \Glsentrylongpl{##1}##2\space
%      (\firstacronymfont{\glsentryshortpl{##1}})%
%    }%
%  }%
%}
%

% Define new acronym style:

\newacronymstyle{french}
{% base the display style on 'long-short'
  \GlsUseAcrEntryDispStyle{long-short}%
}%
{% base the definitions on 'long-short'
  \GlsUseAcrStyleDefs{long-short}%  
% Make some custom modifications for the first use display.
% Singular, no case change:
  \renewcommand*{\genacrfullformat}[2]{%
   \glsifhaslongfr{##1}%
   {% has french version:
      \glsentryshort{##1}\space
      (\firstacronymfont{\glsentrylongfr{##1}##2}, ``\glsentrylong{##1}'')%
   }%
   {%
     \glsentryshort{##1}\space
     (\firstacronymfont{\glsentrylong{##1}##2})%
   }%
  }%
% Singular, first letter upper case:
  \renewcommand*{\Genacrfullformat}[2]{%
   \glsifhaslongfr{##1}%
   {% has french version:
      \Glsentryshort{##1}\space
      (\firstacronymfont{\glsentrylongfr{##1}##2}, ``\glsentrylong{##1}'')%
   }%
   {%
     \Glsentryshort{##1}\space
     (\firstacronymfont{\glsentrylong{##1}##2})%
   }%
  }%
% Plural, no case change:
  \renewcommand*{\genplacrfullformat}[2]{%
   \glsifhaslongplfr{##1}%
   {% has french version:
      \glsentryshortpl{##1}\space
      (\firstacronymfont{\glsentrylongplfr{##1}##2}, ``\glsentrylongpl{##1}'')%
   }%
   {%
     \glsentryshortpl{##1}\space
     (\firstacronymfont{\glsentrylongpl{##1}##2})%
   }%
  }%
% Plural, first letter upper case:
  \renewcommand*{\Genplacrfullformat}[2]{%
    \glsifhaslongplfr{##1}%
    {% has french version:
      \Glsentryshortpl{##1}\space
      (\firstacronymfont{\glsentrylongplfr{##1}##2}, ``\glsentrylongpl{##1}'')%
    }%
    {%
      \Glsentryshortpl{##1}\space
      (\firstacronymfont{\glsentrylongpl{##1}##2})%
    }%
  }%
}

% switch to the new style:
\setacronymstyle{french}

% Define a new glossary style that checks for the existence of
% the longfr field.
\newglossarystyle{listfr}{%
  \setglossarystyle{list}% base style on the list style
  \renewcommand*{\glossentry}[2]{%
  \item[\glsentryitem{##1}%
        \glstarget{##1}{\glossentryname{##1}}]
    \glossentrydesc{##1}%
    \glsifhaslongfr{##1}{\space(\glsentrylongfr{##1})}{}%
    \glspostdescription\space ##2}%
}
%%%%%%%   END glossaries multi-lang configuration   %%%%%%
\makeglossaries
\usepackage[xindy]{imakeidx}
\makeindex
\renewcommand*{\indexspace}{0pt}
\glossarystyle{listfr}
%\renewcommand{\glsnamefont}[1]{\textbf{#1}}
%\renewcommand*{\glsgroupskip}{}
%\renewcommand*{\indexspace}{}
%\setlength{\itemsep}{0pt} \setlength{\parsep}{0pt}
\renewcommand{\glsgroupskip}{}

% TODO
\usepackage[colorinlistoftodos]{todonotes}
\newcommand{\insertref}[1]{\todo[color=green!40]{#1}}
\renewcommand{\comment}[1]{\todo[color=yellow!40]{#1}}
\newcommand{\explainindetail}[1]{\todo[inline,color=red!40]{#1}}

% Better tables
\usepackage{longtable}
\usepackage{calc}
\usepackage{multicol}
\usepackage{tabularx}
\usepackage{tabu}
\usepackage{booktabs}

% Rotation
\usepackage[figuresright]{rotating}

% Insert PDF files for articles in annex
\usepackage{pdfpages}

% Fancy on-the-fly drawing
\usepackage{tikz}
\def\checkmark{
\begin{tikzpicture}
\fill[scale=0.4](0,.35) -- (.25,0) -- (1,.7) -- (.25,.15) -- cycle;
\end{tikzpicture}
}

\usepackage{layout}
\usepackage[final,babel]{microtype}
\usepackage{epigraph}
\usepackage{abstract}

\renewcommand{\thepart}{\Roman{part}}
\renewcommand{\thechapter}{\arabic{chapter}}
\renewcommand{\thesection}{\thechapter.\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}

%\makeatletter
%\@addtoreset{chapter}{part}
%\makeatother

%\renewcommand{\includegraphics}[2][]{\fbox{}}

%\usepackage[nameinlink]{cleveref}


%%%%%%%%%   End Default packages   %%%%%%%%%


% Here's Gildea's Boilerplate Stuff.
% Copyright (c) 1987 by Stephen Gildea
% Permission to copy all or part of this work is granted, provided
% that the copies are not made or distributed for resale, and that
% the copyright notice and this notice are retained.

%% Define all the pieces that go on the title page and the abstract.

% \title and \author already exist

\def\titleen#1{\gdef\@titleen{#1}}

\def\phdprogram#1{\gdef\@phdprogram{#1}}

\def\laboratory#1{\gdef\@laboratory{#1}}

\def\discipline#1{\gdef\@discipline{#1}}

\def\prevdegrees#1{\gdef\@prevdegrees{#1}}
\def\@prevdegrees{}

\def\department#1{\gdef\@department{#1}}

% If you are getting two degrees, use \and between the names.
\def\degree#1{\setbox0\hbox{#1}	 %for side effect of setting \@degreeword
  \gdef\@degree{#1}}

% \and is used inside the \degree argument to separate two degrees
\def\and{\gdef\@degreeword{degrees} \par and \par}
\def\@degreeword{degree}

% The copyright notice stuff is a tremendous mess.
%
% \@copyrightnotice is used by \ to actually put text on the
% page; it defaults to ``Copyright MIT 19xx.  All rights reserved.''
% \copyrightnoticetext takes an argument and defined \@copyrightnotice
% to that argument.  \copyrightnotice takes an argument, and calls
% \copyrightnoticetext with that argument, preceeded by a copyright
% symbol and followed by ``All rights reserved.'' and the standard
% permission notice.
% 
% If you use the 'vi' option, \copyrightnoticetext is used to set the
% copyright to ``(C) Your Name, Current Year in Roman Numerals.''
% followed by the permission notice.

% If there is no \copyrightnotice command, it is asssumed that MIT
% holds the copyright.  This commands adds the copyright symbol to the
% beginning, and puts the standard permission notice below.
%% ``All rights reserved'' added.  Krishna Sethuraman (1990)
\def\copyrightnotice#1{\copyrightnoticetext{\copyright\ #1.  All rights
reserved.\par\permission}}

% Occacionally you will need to exactly specify the text of the 
% copyright notice.  The \copyrightnoticetext command is then useful.
\long\def\copyrightnoticetext#1{\gdef\@copyrightnotice{#1}}
\def\@copyrightnotice{\copyright\ \Mit\ \@degreeyear.  All rights reserved.}

%% `vi' documentclass option: Specifying this option automatically
%% copyrights the thesis to the author and gives MIT permission to copy and
%% distribute the document.  If you want, you can still specify
%% \copyrightnotice{stuff} to copyright to someone else, or
%% \copyrightnoticetext{stuff} to specify the exact text of the copyright
%% notice.
\ifodd\vithesis \copyrightnoticetext{\copyright\ \@author,
\uppercase\expandafter{\romannumeral\@degreeyear}.  All rights reserved.\par\permission}
%% or just
%%\@degreeyear}}
\typeout{Copyright given to author,
	permission to copy/distribute given to MIT.}
\else \typeout{Thesis document copyright MIT unless otherwise (manually) specified}
\fi

\def\thesisdate#1{\gdef\@thesisdate{#1}}
\def\thesisdateen#1{\gdef\@thesisdateen{#1}}

% typically just a month and year
\def\degreemonth#1{\gdef\@degreemonth{#1}}
\def\degreeyear#1{\gdef\@degreeyear{#1}}

% Usage: \supervisor{name}{title}
%        \chairman{name}{title}

% since there can be more than one supervisor,
% we build the appropriate boxes for the titlepage and
% the abstractpage as the user makes multiple calls
% to \supervisor
\newbox\@titlesupervisor 	\newbox\@abstractsupervisor

\def\supervisor#1#2{\setbox\@titlesupervisor\vbox
  {\unvbox\@titlesupervisor \vskip 10pt% plus 1fil minus 1fil
  \def\baselinestretch{1}\large
  \signature{Certified by}{#1 \\ #2 \\ Thesis Supervisor}}
  \setbox\@abstractsupervisor\vbox{\unvbox\@abstractsupervisor
  \vskip\baselineskip \def\baselinestretch{1}\@normalsize 
  \par\noindent Thesis Supervisor: #1 \\ Title: #2}}

% department chairman, not thesis committee chairman
\def\chairman#1#2{\gdef\@chairmanname{#1}\gdef\@chairmantitle{#2}}

\def\fsupervisor#1#2{\gdef\@fsupervisorname{#1}\gdef\@fsupervisortitle{#2}}

\def\cosupervisor#1#2{\gdef\@cosupervisorname{#1}\gdef\@cosupervisortitle{#2}}

\def\thesischairman#1#2{\gdef\@thesischairmanname{#1}\gdef\@thesischairmantitle{#2}}

\def\firstreporter#1#2{\gdef\@firstreportername{#1}\gdef\@firstreportertitle{#2}}

\def\secondreporter#1#2{\gdef\@secondreportername{#1}\gdef\@secondreportertitle{#2}}

\def\firstexaminator#1#2{\gdef\@firstexaminatorname{#1}\gdef\@firstexaminatortitle{#2}}

\def\secondexaminator2#1#2{\gdef\@secondexaminatorname{#1}\gdef\@secondexaminatortitle{#2}}

%----------------------------------------------

\def\maketitle{\begin{titlepage}

\vspace*{-2.2cm}
%\logo{
    \includegraphics[height=3cm,keepaspectratio]{Logo_UPS.png}
    \hfill
    \includegraphics[height=3cm,keepaspectratio]{MNHN_alpha.png}
%  }
%}

\begin{center}
{\huge \textsc{\@department}}
\par
{\large \textsc{Ecole Doctorale : \@phdprogram}}
\\[15pt]
{\large \textsc{Laboratoire : \@laboratory}}
\\[15pt]
{\large \textsc{Discipline : \@discipline}}
\par
{\huge \textsc{\@degree}}
\par
\large{Soutenue le \@thesisdate \, par}
\par
\huge{\textbf{{\@author}}}
\par
\huge{\@title}
\end{center}

\begin{footnotesize}
\setlength{\extrarowheight}{5px}
\begin{tabularx}{\textwidth}{>{\setlength\hsize{0.3\textwidth}\raggedright}X X >{\setlength\hsize{0.39\textwidth}\raggedleft}X}

\textbf{Directeur de th\`ese} :
	& \@fsupervisorname			& \@fsupervisortitle \tabularnewline
\textbf{Co-directeur de th\`ese} :
	& \@cosupervisorname		& \@cosupervisortitle \tabularnewline

\tabularnewline

Composition du jury : & ~ & ~ \tabularnewline

Pr\'esident du jury :
	& \@thesischairmanname		& \@thesischairmantitle \tabularnewline
Rapporteurs :
	& \@firstreportername		& \@firstreportertitle \tabularnewline
 	& \@secondreportername		& \@secondreportertitle \tabularnewline
Examinateur :
	& \@firstexaminatorname		& \@firstexaminatortitle \tabularnewline

\end{tabularx}
\end{footnotesize}

\end{titlepage}}

%----------------------------------------------------

% this environment should probably be called abstract,
% but we want people to also be able to get at the more
% basic abstract environment
\def\abstractpage{
\begin{center}{\large{\bf \@title} \\
par \\
\@author \\[\baselineskip]}
\par
\def\baselinestretch{1}\@normalsize
\@department \\
\@thesisdate \\
\@degree
\end{center}
\par
\begin{abstractfr}}

\def\endabstractpage{\end{abstractfr}\noindent}


\def\abstractpageen{
\begin{center}{\large{\bf \@titleen} \\
by \\
\@author \\[\baselineskip]}
\par
\def\baselinestretch{1}\@normalsize
\@department \\
\@thesisdateen \\
Doctorate of Philosophy
\end{center}
\par
\begin{abstracten}}

\def\endabstractpageen{\end{abstracten}\noindent}
% \unvcopy\@abstractsupervisor \newpage}

%% This counter is used to save the page number for the second copy of
%% the abstract.
%\newcounter{savepage}

% You can use the titlepage environment to do it all yourself if you
% don't want to use \maketitle.  If the titlepage environment, the
% paragraph skip is infinitely stretchable, so if you leave a blank line
% between lines that you want space between, the space will stretch so
% that the title page fills up the entire page.
\def\titlepage{\cleardoublepage\centering
  \thispagestyle{empty}
  \parindent 0pt \parskip 10pt plus 1fil minus 1fil
  \def\baselinestretch{1}\@normalsize\vbox to \vsize\bgroup\vbox to 9in\bgroup}
% The \kern0pt pushes any depth into the height.  Thanks to Richard Stone.
\def\endtitlepage{\par\kern 0pt\egroup\vss\egroup\newpage}

\def\MIT{UNIVERSITE PARIS SUD (PARIS XI)}
\def\Mit{Universite Paris Sud (Paris XI)}

\def\permission{\par\noindent{\centering}\par}

\def\signature#1#2{\par\noindent#1\dotfill\null\\*
  {\raggedleft #2\par}}

\def\abstractfr{\subsection*{Résumé}\small\def\baselinestretch{1}\@normalsize}
\def\endabstractfr{\par}

\def\abstracten{\subsection*{Abstract}\small\def\baselinestretch{1}\@normalsize}
\def\endabstracten{\par}

