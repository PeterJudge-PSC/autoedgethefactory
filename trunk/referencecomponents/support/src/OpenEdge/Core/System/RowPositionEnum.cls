/** ------------------------------------------------------------------------
    File        : RowPositionEnum
    Purpose     : Enumerates the relative position of a row within a query. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 20 16:53:01 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.RowPositionEnum. 
using OpenEdge.Lang.EnumMember. 

class OpenEdge.Core.System.RowPositionEnum final inherits EnumMember: 
    
    /** None means no records in the query. */
    define public static property None           as RowPositionEnum no-undo get. private set.
    define public static property IsFirst        as RowPositionEnum no-undo get. private set.
    define public static property IsLast         as RowPositionEnum no-undo get. private set.
    define public static property IsFirstAndLast as RowPositionEnum no-undo get. private set.
    define public static property NotFirstOrLast as RowPositionEnum no-undo get. private set.
    
    constructor static RowPositionEnum():
        RowPositionEnum:None = new RowPositionEnum('None').
        RowPositionEnum:IsFirst = new RowPositionEnum('IsFirst').
        RowPositionEnum:IsLast = new RowPositionEnum('IsLast').
        RowPositionEnum:IsFirstAndLast = new RowPositionEnum('IsFirstAndLast').
        RowPositionEnum:NotFirstOrLast = new RowPositionEnum('NotFirstOrLast').        
    end constructor.

	constructor public RowPositionEnum ( input pcName as character ):
		super (input pcName).
	end constructor.
	
end class.