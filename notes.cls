\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{Notes}
\RequirePackage{ifthen, polynom}
\RequirePackage[nodayofweek]{datetime}

%%% Options
% Language (english,italian)
\DeclareOption{english}{
  \newcommand{\notes@lang}{english}
  \newdateformat{usvardate}{\monthname[\THEMONTH] \ordinal{DAY}, \THEYEAR}
  \usvardate
  \newcommand{\notes@lecturename}{Lecture}
  \newcommand{\notes@theoremname}{theorem}
  \newcommand{\notes@propositionname}{proposition}
  \newcommand{\notes@lemmaname}{lemma}
  \newcommand{\notes@corollaryname}{corollary}
  \newcommand{\notes@definitionname}{definition}
  \newcommand{\notes@examplename}{example}
  \newcommand{\notes@exercisename}{exercise}
  \newcommand{\notes@remarkname}{remark}
  \newcommand{\notes@factname}{fact}
  \newcommand{\notes@problemname}{problem}
  \newcommand{\notes@conjecturename}{conjecture}
  \newcommand{\notes@claimname}{claim}
  \newcommand{\notes@notationname}{notation}}
  \newcommand\defn[2]{\begin{definition}{\textbf{#1} {#2}}\end{definition}}
 \newcommand\nota[1]{\begin{notation}#1\end{notation}}
 \newcommand\rem[1]{\begin{remark} #1 \end{remark}}
 \newcommand\ex[1]{\begin{example} #1\end{example}}
 \newcommand\lem[1]{\begin{lemma} #1 \end{lemma}}
 \newcommand\prop[2]{\begin{proposition}{\textbf{#1}}{#2}\footnotesize{ (see proof below)}\end{proposition}}
 \newcommand\extra[1]{\shadowbox{
\parbox{\textwidth}{\textbf{EXTRA MATERIAL} \\ #1}}}
\newcommand\proofs[1]{\begin{proof} \hphantom{.} #1\end{proof}}

% Header (headertitle,headersection,headersubsection, headerno)
%   headertitle displays speaker on left and title on right.
%   headersection displays section on left and right
%   headersubsection displays section on left and subsection on right
%   headerno does not display headers
\DeclareOption{headertitle}{\newcommand{\notes@header}{title}}
\DeclareOption{headersection}{\newcommand{\notes@header}{section}}
\DeclareOption{headersubsection}{\newcommand{\notes@header}{section}} %modified to show section in header always
\DeclareOption{headerno}{\newcommand{\notes@header}{no}}
% Theorem (theoremnosection,theoremsection,theoremsubsection)
%   theoremnosection numbers theorem continuously in the document
%   theoremsection reset theorem numbering on section changes
%   theoremsubsection reset theorem numbering on subsection changes
\DeclareOption{theoremnosection}{\newcommand{\notes@theorem}{nosection}}
\DeclareOption{theoremsection}{\newcommand{\notes@theorem}{section}}
\DeclareOption{theoremsubsection}{\newcommand{\notes@theorem}{subsection}}
% Clear double page before sections (cleardoublepage,nocleardoublepage)
\DeclareOption{cleardoublepage}{\newcommand{\notes@cleardoublepage}{true}}
\DeclareOption{nocleardoublepage}{\newcommand{\notes@cleardoublepage}{false}}
% Number of sides (oneside,twoside)
\DeclareOption{oneside}{\newcommand{\notes@side}{oneside}}
\DeclareOption{twoside}{\newcommand{\notes@side}{twoside}}
% Number of columns (onecolumn,twocolumn)
\DeclareOption{onecolumn}{\newcommand{\notes@columns}{onecolumn}}
\DeclareOption{twocolumn}{\newcommand{\notes@columns}{twocolumn}}
% Type (course, seminar, talk)
%   Course is a medium-length document (tens of pages)
%     structured in sections, subsections and optionally paragraphs;
%     if subsections are short, one can ask for headersection not to display
%     subsections in headers; if subsections are long, one can ask for
%     theoremsubsection to number theorems inside subsection. It has lectures
%     number as a margin note.
%   Seminar is a short unstructured document (maybe with paragraph or small
%     subsections).
%   Talk is to prepare a speech - with the same structure as seminar, but is
%     designed to write only the things one will write at the blackboard.
\DeclareOption{course}{%
  \newcommand{\notes@type}{course}%
  \ifthenelse{\isundefined{\notes@header}}{\ExecuteOptions{headersubsection}}{}%
  \ifthenelse{\isundefined{\notes@theorem}}{\ExecuteOptions{theoremsection}}{}%
  \ifthenelse{\isundefined{\notes@cleardoublepage}}{\ExecuteOptions{nocleardoublepage}}{}%
  \ifthenelse{\isundefined{\notes@columns}}{\ExecuteOptions{onecolumn}}{}%
  \ifthenelse{\isundefined{\notes@side}}{\ExecuteOptions{twoside}}{}%
  \PassOptionsToPackage{fleqn}{amsmath}%
}
\DeclareOption{seminar}{%
  \newcommand{\notes@type}{seminar}%
  \ifthenelse{\isundefined{\notes@header}}{\ExecuteOptions{headertitle}}{}%
  \ifthenelse{\isundefined{\notes@theorem}}{\ExecuteOptions{theoremnosection}}{}%
  \ifthenelse{\isundefined{\notes@cleardoublepage}}{\ExecuteOptions{nocleardoublepage}}{}%
  \ifthenelse{\isundefined{\notes@columns}}{\ExecuteOptions{onecolumn}}{}%
  \ifthenelse{\isundefined{\notes@side}}{\ExecuteOptions{twoside}}{}%
  \PassOptionsToPackage{fleqn}{amsmath}%
}
\DeclareOption{talk}{%
  \newcommand{\notes@type}{talk}%
  \ifthenelse{\isundefined{\notes@header}}{\ExecuteOptions{headerno}}{}%
  \ifthenelse{\isundefined{\notes@theorem}}{\ExecuteOptions{theoremnosection}}{}%
  \ifthenelse{\isundefined{\notes@cleardoublepage}}{\ExecuteOptions{nocleardoublepage}}{}
  \ifthenelse{\isundefined{\notes@columns}}{\ExecuteOptions{twocolumn}}{}%
  \ifthenelse{\isundefined{\notes@side}}{\ExecuteOptions{oneside}}{}%
  \hbadness=10000%
  \vbadness=10000%
  \tolerance=10000%
}

\ProcessOptions

%%% Load default class
\LoadClass[a4paper,10pt,\notes@columns,\notes@side]{article}

%%% Load default arguments if empty
\ifthenelse{\isundefined{\notes@type}}{\ExecuteOptions{course}}{}
\ifthenelse{\isundefined{\notes@lang}}{\ExecuteOptions{english}}{}

%%% Common macroes
\RequirePackage[\notes@lang]{babel}
\RequirePackage[pdftex,colorlinks,linkcolor=black,urlcolor=black,citecolor=black]{hyperref}
\RequirePackage{fancyhdr}
\RequirePackage{tikz}
\usetikzlibrary{arrows}
\usetikzlibrary{patterns}
\usetikzlibrary{shapes}
\RequirePackage[utf8x]{inputenc}
\RequirePackage[intlimits,leqno]{amsmath}
\RequirePackage[osf,sc]{mathpazo}
\linespread{1.05} % Palatino
\RequirePackage{amsfonts}
\RequirePackage{amsthm}
\RequirePackage{amsxtra}
\RequirePackage{amssymb}
\RequirePackage{mathdots}
\RequirePackage{mathrsfs}
\RequirePackage{stmaryrd}
\RequirePackage{titlesec}
\newcommand{\contentsfinish}{}
\RequirePackage[titles]{tocloft}
\RequirePackage{textcase}
\RequirePackage{setspace}
\RequirePackage{xfrac}
\RequirePackage{mathtools}
\RequirePackage{faktor}
\RequirePackage{cancel}
\RequirePackage{mparhack}
\RequirePackage{booktabs}
\RequirePackage{multirow}
\RequirePackage[fixlanguage]{babelbib}
\RequirePackage{Commons}

\SetUnicodeOption{mathletters}
\SetUnicodeOption{autogenerated}

\delimitershortfall=5pt

\frenchspacing
\DeclareRobustCommand{\smallcaps}[1]{\scshape{#1}}%\MakeTextLowercase{#1}}
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
    \hbox{}
    \vspace*{\fill}
    \vspace{\fill}
    \thispagestyle{empty}
    \newpage
    \if@twocolumn\hbox{}\newpage\fi\fi\fi}
\newcommand{\mymarginpar}[1]{\marginpar{\setstretch{0.7}\textit{\scriptsize{#1}}}}
\newcommand{\separator}{\begin{center}\rule{\columnwidth}{\arrayrulewidth}\end{center}}
\newcommand{\tosay}[1]{\begin{center}\text{\fbox{\scriptsize{#1}}}\end{center}}
\newcounter{notes@lecture}
\newcommand{\lecture}[4][]{%
  \addtocounter{notes@lecture}{1}%
  \newdate{@datelecture#2#3#4}{#2}{#3}{#4}%
  \mymarginpar{\notes@lecturename{}\ \arabic{notes@lecture} \ifthenelse{\equal{#1}{}}{}{\ (#1)}\\ \displaydate{@datelecture#2#3#4}}%
}
\newcommand{\TODO}{\mymarginpar{TODO}}%

%%% Theorems and sections style
\swapnumbers
\newtheoremstyle{plainsc}{10pt}{10pt}{\normalfont\itshape}{}{\bfseries\smallcaps}{.}{.5em}{}
\newtheoremstyle{definitionsc}{10pt}{10pt}{\normalfont}{}{\bfseries\smallcaps}{.}{.5em}{}
\newtheoremstyle{remarksc}{10pt}{10pt}{\normalfont}{}{\bfseries\smallcaps}{.}{.5em}{}

\theoremstyle{plainsc}
\ifthenelse{\equal{\notes@theorem}{nosection}}{\newtheorem{theorem}{\notes@theoremname}}{}
\ifthenelse{\equal{\notes@theorem}{section}}{\newtheorem{theorem}{\notes@theoremname}[section]}{}
\ifthenelse{\equal{\notes@theorem}{subsection}}{\newtheorem{theorem}{\notes@theoremname}[subsection]}{}
\newtheorem{proposition}[theorem]{\notes@propositionname}
\newtheorem{lemma}[theorem]{\notes@lemmaname}
\newtheorem{corollary}[theorem]{\notes@corollaryname}
\newtheorem{conjecture}[theorem]{\notes@conjecturename}
\newtheorem{claim}[theorem]{\notes@claimname}
\theoremstyle{definitionsc}
\newtheorem{definition}[theorem]{\notes@definitionname}
\theoremstyle{remarksc}
\newtheorem{example}[theorem]{\notes@examplename}
\newtheorem{exercise}[theorem]{\notes@exercisename}
\newtheorem{remark}[theorem]{\notes@remarkname}
\newtheorem{fact}[theorem]{\notes@factname}
\newtheorem{problem}[theorem]{\notes@problemname}
\newtheorem{notation}[theorem]{\notes@notationname}

\newcommand{\notes@opensection}{}
\ifthenelse{\equal{\notes@cleardoublepage}{true}}{\renewcommand{\notes@opensection}{\cleardoublepage\thispagestyle{plain}}}{}
\titleformat{\subsection}{\relax\centering}{\thesubsection}{1em}{\normalsize\itshape}
\titleformat{\paragraph}[runin]{}{}{}{\normalsize\smallcaps}
\renewcommand{\section}{\notes@opensection%
  \@startsection {section}{1}{\z@}%
  {-3.5ex \@plus -1ex \@minus -.2ex}%
  {2.3ex \@plus.2ex}%
  {\centering\large\smallcaps}}

\renewcommand{\cftsecfont}{\normalfont}%
\renewcommand{\cftsecpagefont}{\normalfont}%
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{2}
\ifthenelse{\equal{\notes@type}{seminar}}{\renewcommand{\thesubsection}{\arabic{subsection}}}{}  
\ifthenelse{\equal{\notes@type}{talk}}{\renewcommand{\thesubsection}{\arabic{subsection}}}{}  

\renewcommand{\descriptionlabel}[1]{\hspace*{\labelsep}\smallcaps{#1}}


%%% Preamble commands (as title, author, ...)
\renewcommand{\date}[3]{\newdate{@date}{#1}{#2}{#3}}
\newcommand{\dateend}[3]{\newcommand{\notes@dateenddef}{}\newdate{@dateend}{#1}{#2}{#3}}
\newcommand{\email}[1]{\newcommand{\notes@email}{#1}}
\newcommand{\speaker}[1]{\newcommand{\notes@speaker}{#1}}
\newcommand{\smalltitle}[1]{\newcommand{\notes@smalltitle}{#1}}
\newcommand{\place}[1]{\newcommand{\notes@place}{#1}}
\newcommand{\conference}[1]{\newcommand{\notes@conference}{#1}}
\newcommand{\subject}[1]{\newcommand{\notes@subject}{#1}}

\AtBeginDocument{
  \ifthenelse{\equal{\notes@columns}{twocolumn}}
             {%
               \setlength{\abovedisplayskip}{0mm}%
               \setlength{\belowdisplayskip}{0mm}%
               \setlength{\parskip}{0mm}%
               \setlength{\topsep}{0mm}%
             }{}
  \pagestyle{fancy}
  \ifthenelse{\equal{\notes@header}{title}}%
             {%
               \renewcommand{\sectionmark}[1]{}%
               \renewcommand{\subsectionmark}[1]{}%
             }{}
  \ifthenelse{\equal{\notes@header}{section}}%
             {%
               \renewcommand{\sectionmark}[1]{\markboth{\thesection.\ \smallcaps{#1}}{\thesection.\ \smallcaps{#1}}}%
               \renewcommand{\subsectionmark}[1]{}%
             }{}
  \ifthenelse{\equal{\notes@header}{subsection}}%
             {
               \renewcommand{\sectionmark}[1]{\markboth{\thesection.\ \smallcaps{#1}}{}}%\thesection.\ \smallcaps{#1}}}
               \renewcommand{\subsectionmark}[1]{\markright{\thesubsection.\ \smallcaps{#1}}}%
             }{}
  \fancyhf{}
  \ifthenelse{\equal{\notes@header}{title}}{%
    \ifthenelse{\isundefined{\notes@smalltitle}}{%
      \fancyhead[LE]{\smallcaps\@title}}{%
      \fancyhead[LE]{\smallcaps\notes@smalltitle}}
    \ifthenelse{\isundefined{\notes@speaker}}{%
      \fancyhead[RO]{\smallcaps\@author}}{%
      \fancyhead[RO]{\smallcaps\notes@speaker}}
  }
             {
               \fancyhead[LE]{\smallcaps\leftmark}
               \fancyhead[RO]{\smallcaps\rightmark}
             }
  \fancyfoot[RO,LE]{\smallcaps\thepage}
  \ifthenelse{\equal{\notes@header}{no}}%
    {\renewcommand{\headrulewidth}{0pt}}%
    {\renewcommand{\headrulewidth}{0.5pt}}

  \ifthenelse{\isundefined{\notes@subject}}{\subject{}}{}
  \ifthenelse{\isundefined{\notes@email}}{\email{}}{}
  \ifthenelse{\isundefined{\notes@speaker}}{\speaker{}}{}
  \ifthenelse{\isundefined{\notes@conference}}{\conference{}}{}
  \ifthenelse{\isundefined{\notes@place}}{\place{}}{}  
  \hypersetup{
    pdftitle={\@title},
    pdfsubject={\notes@subject},
    pdfauthor={\@author},
    pdfkeywords={\notes@speaker{}:\notes@conference{}:\notes@place{}},
  }
  \pdfinfo{/ModDate (D:\pdfdate)}
  \maketitle
  \ifthenelse{\equal{\notes@type}{course}}{\tableofcontents}{}
}

%%% Common structures

\renewcommand\maketitle{\par
  \begingroup
  \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
  \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
  \long\def\@makefntext##1{\parindent 1em\noindent
    \hb@xt@1.8em{%
      \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
  \@maketitle
  \thispagestyle{plain}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
}

\renewcommand{\@maketitle}{
  \newpage
  \null
  \vskip 4ex%
  \begin{center}%
    \let \footnote \thanks
    {\Large\smallcaps\@title}%
    {\ifthenelse{\isundefined{\notes@speaker}}{}{{\vskip 1ex\large\smallcaps\notes@speaker}\par}}%
    \vskip 1.5em%
    {\large
    \begin{tabular}[t]{c}%
      \ifthenelse{\equal{\notes@email}{}}{%
        {\small\itshape\@author}%
      }{%
        {\small\itshape\@author}\footnote{\href{mailto:\notes@email}{\notes@email}}%
      }
    \end{tabular}\par}%
    \vskip 2ex%
    \ifthenelse{\equal{\notes@conference}{}}%
    {%
      \ifthenelse{\equal{\notes@place}{}}{}%
      {%
        {\small\itshape\notes@place}%
        \vskip 1ex%
      }%
    }%
    {%
      \ifthenelse{\equal{\notes@place}{}}%
      {%
        {\small\itshape\notes@conference}%
        \vskip 1ex%
      }%
      {%
        {\small\itshape\notes@conference, \notes@place}%
        \vskip 1ex%
      }%
    }
    \ifthenelse{\isundefined{\notes@dateenddef}}{%
    {\small\itshape\displaydate{@date}}}{%
    {\small\itshape\displaydate{@date} -- \displaydate{@dateend}}}%
  \end{center}%
  \par
  \vskip 3ex
}

\newcommand{\makedefaultsection}[2][true]{
  \ifthenelse{\equal{\notes@type}{course}}{
    \ifthenelse{\equal{#1}{true}}{\addcontentsline{toc}{section}{#2}}{}
    \section*{#2}
    \ifthenelse{\equal{\notes@header}{section}}{\markboth{\smallcaps{#2}}{\smallcaps{#2}}}{}
    \ifthenelse{\equal{\notes@header}{subsection}}{\markboth{\smallcaps{#2}}{}}{}}{}
  \ifthenelse{\equal{\notes@type}{seminar}}{
    \ifthenelse{\equal{#1}{true}}{\addcontentsline{toc}{subsection}{#2}}{}
    \subsection*{#2}
    \ifthenelse{\equal{\notes@header}{subsection}}{\markright{\smallcaps{#2}}}{}}{}
  \ifthenelse{\equal{\notes@type}{talk}}{
    \ifthenelse{\equal{#1}{true}}{\addcontentsline{toc}{subsection}{#2}}{}
    \subsection*{#2}
    \ifthenelse{\equal{\notes@header}{subsection}}{\markright{\smallcaps{#2}}}{}}{}
}

\renewcommand{\tableofcontents}{%
  \makedefaultsection[false]{\contentsname}
  \@starttoc{toc}%
}

\renewenvironment{thebibliography}[1]{
  \makedefaultsection{\refname}
  \list{\@biblabel{\@arabic\c@enumiv}}%
       {\settowidth\labelwidth{\@biblabel{#1}}%
         \leftmargin\labelwidth
         \advance\leftmargin\labelsep
         \@openbib@code
         \usecounter{enumiv}%
         \let\p@enumiv\@empty
         \renewcommand\theenumiv{\@arabic\c@enumiv}}%
       \sloppy
       \clubpenalty4000
       \@clubpenalty \clubpenalty
       \widowpenalty4000%
       \sfcode`\.\@m%
}{
  \def\@noitemerr
      {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
