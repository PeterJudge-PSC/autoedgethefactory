/** ------------------------------------------------------------------------
    File        : OperatorEnum
    Purpose     : Enumeration of ABL operators 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 12 15:05:08 EDT 2009
    Notes       : * IsEqual property should be 'Equals' but compiler barfs. 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.OperatorEnum final inherits EnumMember :
    
    define public static property IsEqual       as OperatorEnum no-undo get. private set.
    define public static property GreaterThan   as OperatorEnum no-undo get. private set.
    define public static property GreaterEqual  as OperatorEnum no-undo get. private set.
    define public static property LessThan      as OperatorEnum no-undo get. private set.
    define public static property LessEqual     as OperatorEnum no-undo get. private set.
    define public static property NotEqual      as OperatorEnum no-undo get. private set.
    define public static property Matches       as OperatorEnum no-undo get. private set.
    define public static property Begins        as OperatorEnum no-undo get. private set.
    define public static property Contains      as OperatorEnum no-undo get. private set.
    define public static property None          as OperatorEnum no-undo get. private set.
    
    constructor static OperatorEnum():
        OperatorEnum:IsEqual = new OperatorEnum('eq').
        OperatorEnum:GreaterThan = new OperatorEnum('gt').
        OperatorEnum:GreaterEqual = new OperatorEnum('ge').
        OperatorEnum:LessThan = new OperatorEnum('lt').
        OperatorEnum:LessEqual = new OperatorEnum('le').
        OperatorEnum:NotEqual = new OperatorEnum('ne').
        OperatorEnum:Matches = new OperatorEnum('matches').
        OperatorEnum:Begins = new OperatorEnum('begins').
        OperatorEnum:Contains = new OperatorEnum('contains').
        OperatorEnum:None = new OperatorEnum('').
    end constructor.
    
    constructor public OperatorEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method static public logical Equals (pcOperator as char, poOperator as OperatorEnum):
        define variable lEqual as logical no-undo.
        
        lEqual = poOperator:ToString() eq pcOperator.
        
        /* Alternate */
        if not lEqual then
        case pcOperator:
            when '=' then lEqual = poOperator eq OperatorEnum:IsEqual.
            when '>' then lEqual = poOperator eq OperatorEnum:GreaterThan.
            when '>=' then lEqual = poOperator eq OperatorEnum:GreaterEqual.
            when '<' then lEqual = poOperator eq OperatorEnum:LessThan.
            when '<=' then lEqual = poOperator eq OperatorEnum:LessEqual.
            when '<>' then lEqual = poOperator eq OperatorEnum:NotEqual.
        end case.
        
        return lEqual.
    end method.
    
end class.