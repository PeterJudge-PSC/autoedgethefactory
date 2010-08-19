/** ------------------------------------------------------------------------
    File        : FindTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.FindTypeEnum. 
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.FindTypeEnum final inherits EnumMember: 
    
    define public static property First    as FindTypeEnum no-undo get. private set.
    define public static property Next     as FindTypeEnum no-undo get. private set.
    define public static property Prev     as FindTypeEnum no-undo get. private set.
    define public static property Last     as FindTypeEnum no-undo get. private set.    
    define public static property Unique   as FindTypeEnum no-undo get. private set.
    
    constructor static FindTypeEnum():
         FindTypeEnum:First  = new FindTypeEnum('first').
         FindTypeEnum:Next   = new FindTypeEnum('next').
         FindTypeEnum:Prev   = new FindTypeEnum('prev').
         FindTypeEnum:Last   = new FindTypeEnum('last').
         FindTypeEnum:Unique = new FindTypeEnum('unique').        
    end constructor.
		
	constructor public FindTypeEnum (input pcName as character ):
		super (input pcName).
	end constructor.
    
end class.