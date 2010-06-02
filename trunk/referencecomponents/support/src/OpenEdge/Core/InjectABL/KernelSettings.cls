 /*------------------------------------------------------------------------
    File        : KernelSettings
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 11 12:05:46 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.KernelSettings.
using OpenEdge.Lang.DateTimeAddIntervalEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.InjectABL.KernelSettings:
    define static public property NO_PRUNE_INTERVAL as integer init -1 no-undo get. private set.
        
    define public property CachePruningInterval as integer no-undo get. set.    
    define public property CachePruningUnit as DateTimeAddIntervalEnum no-undo get. set.
    
    constructor public KernelSettings():
        CachePruningInterval = KernelSettings:NO_PRUNE_INTERVAL.
        CachePruningUnit = DateTimeAddIntervalEnum:Default.
    end constructor.
    
end class.