/** ------------------------------------------------------------------------
    File        : routinelevel.i
    Purpose     : Toggles all ROUTINE-LEVEL ON ERROR UNDO, THROW statements on or off.  
                  Use an include in leiu of a switch on the AVM command line (since that
                  doesn't exist).
    @author pjudge
    Created     : Fri Jan 21 14:02:16 EST 2011
    Notes       : * Default is to use ROUTINE-LEVEL
  ---------------------------------------------------------------------- */

/* ********************  Preprocessor Definitions  ******************** */
&if defined(USE-ROUTINE-LEVEL) eq 0 &then
    &global-define USE-ROUTINE-LEVEL true
&endif 

&if "{&USE-ROUTINE-LEVEL}" eq "true" &then
routine-level on error undo, throw.
&endif 