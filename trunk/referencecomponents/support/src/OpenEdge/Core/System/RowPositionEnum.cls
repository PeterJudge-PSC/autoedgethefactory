/*------------------------------------------------------------------------
    File        : RowPositionEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Mar 20 16:53:01 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.*. 
using OpenEdge.Lang.*. 

class OpenEdge.Core.System.RowPositionEnum final inherits EnumMember: 
    
    /* None means no records in the query. */
    define public static property None           as RowPositionEnum no-undo get. private set.
    define public static property IsFirst        as RowPositionEnum no-undo get. private set.
    define public static property IsLast         as RowPositionEnum no-undo get. private set.
    define public static property IsFirstAndLast as RowPositionEnum no-undo get. private set.
    define public static property NotFirstOrLast as RowPositionEnum no-undo get. private set.
    
    constructor static RowPositionEnum():
        RowPositionEnum:None = new RowPositionEnum().
        RowPositionEnum:IsFirst = new RowPositionEnum().
        RowPositionEnum:IsLast = new RowPositionEnum().
        RowPositionEnum:IsFirstAndLast = new RowPositionEnum().
        RowPositionEnum:NotFirstOrLast = new RowPositionEnum().        
    end constructor.
    
    constructor public RowPositionEnum():
    end constructor.
    
end class.