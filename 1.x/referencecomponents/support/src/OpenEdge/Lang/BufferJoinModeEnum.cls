/** ------------------------------------------------------------------------
    File        : BufferJoinModeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Feb 25 09:47:34 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BufferJoinModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.BufferJoinModeEnum final inherits EnumMember:
     
    define public static property Default as BufferJoinModeEnum no-undo get. private set.
    define public static property Inner as BufferJoinModeEnum no-undo get. private set.
    define public static property Outer as BufferJoinModeEnum no-undo get. private set.
    define public static property LeftOuter as BufferJoinModeEnum no-undo get. private set.
    
    constructor static BufferJoinModeEnum():
        BufferJoinModeEnum:Inner = new BufferJoinModeEnum('').
        BufferJoinModeEnum:Outer  = new BufferJoinModeEnum('outer-join').
        BufferJoinModeEnum:LeftOuter = new BufferJoinModeEnum('left outer-join').
        
        BufferJoinModeEnum:Default  = BufferJoinModeEnum:Inner.
    end constructor.

    constructor public BufferJoinModeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.

    method static public BufferJoinModeEnum EnumFromString (input pcName as character):
        define variable oEnum as BufferJoinModeEnum no-undo.
        
        case pcName:
            when BufferJoinModeEnum:Inner:ToString() then oEnum = BufferJoinModeEnum:Inner.
            when BufferJoinModeEnum:Outer:ToString() then oEnum = BufferJoinModeEnum:Outer.
            when BufferJoinModeEnum:LeftOuter:ToString() then oEnum = BufferJoinModeEnum:LeftOuter.
        end case.
        
        return oEnum.
    end method.
    
end class.