/*------------------------------------------------------------------------
    File        : Routine
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Nov 18 14:31:22 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Lang.RoutineTypeEnum.
using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.Binding.Parameters.Routine:
    /** The InjectABL service that's a parent for this routine  */
    define public property Service as class Class no-undo get. private set.
    /** The name of the routine */     
    define public property RoutineName as character no-undo get. private set.    
    /** Is the routine a Constructor, Method or Property (setter) */
    define public property RoutineType as RoutineTypeEnum no-undo get. private set.
    
    /** The parameter to be passed to the routine */
    define public property Parameters as IParameter extent no-undo get. set.
    
    constructor public Routine(input poService as class Class,
                               input pcRoutineName as character,
                               input poRoutineType as RoutineTypeEnum ):
        Service = poService.
        RoutineName = pcRoutineName.
        RoutineType = poRoutineType.
    end method.
    
end class.