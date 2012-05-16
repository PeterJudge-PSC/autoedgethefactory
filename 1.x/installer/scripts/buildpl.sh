#!/bin/sh

###########################################################################
#+ NAME
#+    buildpl.sh - Builds PL files from r-code in AutoEdge
#+
#+ SYNOPSYS
#+    buildpl [dlc=102b,1100] [apps=<application list>]
#+
#+ DESCRIPTION
#+    buildpl creates and populates ABL procedure libraries
#+
#+    Arguments:
#+    dlc=location of OE install (root; eg c:/progress/openedge/11.0)
#+
#+    component=<AETF components>. The component serves as the name for the PL.
#+            Comma-delimited list of AutoEdge|TheFactory components, per list below (taken from installer/autoedgethefactorysetup.iss)
#+            Name: AETF_SERVER; Description: AutoEdge|TheFactory Server Components
#+            Name: AETF_CLIENT; Description: AutoEdge|TheFactory Client Components
#+            Name: OERA_PRESENTATION_LAYER; Description: OERA Presentation Layer Components
#+            Name: OERA_ENTERPRISE_SERVICES; Description: OERA Enterprise Services Layer Components
#+            Name: OERA_CI_CLIENT; Description: OERA Common Infrastructure Client Layer Components
#+            Name: OERA_CI_SERVER; Description: OERA Common Infrastructure Server Layer Components
#+            Name: OERA_BUSINESS_COMPONENTS; Description: OERA Business Components Layer Components
#+            Name: OERA_DATA_ACCESS; Description: OERA Data Access Layer Components (incl. Data Source Layer)
#+            Name: SUPPORT; Description: General Support Libraries

#+    The apps=<application list> option identifies a specific list of
#+    application directories to compile.  If this parameter is missing,
#+    all appropriate source directories are processed for the user
#+    interface being compiled (see uimode parameter).  The special
#+    identifier "wrappers" is used to compile all wrapper procedures.

# Build and install ADE tools r-code procedure libraries


                 echo "$PROG: Installing $j ... `date`"
                 cd "$WORK"
                 find $j -type f -name \*.r -depth -print | \
                   sed -e 's,^\./,,' > ${j}prolib.pf
                 if [ -f $j.pl ] ; then
                   rm -f $j.pl
                 fi
                 if $PLBUILD
                 then
                   prolib $j.pl -create -codepage undefined
                   prolib $j.pl -add -pf ${j}prolib.pf
                   cp $j.pl "$POSSEDST"
                 else
                   rm -f "$POSSEDST/$j.pl"
                   $MKDIR "$POSSEDST/$j"
                   cp -r $j "$POSSEDST"
                 fi