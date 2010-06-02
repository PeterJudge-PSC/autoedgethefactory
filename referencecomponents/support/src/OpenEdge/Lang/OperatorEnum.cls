/*------------------------------------------------------------------------
    File        : OperatorEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 12 15:05:08 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.*.

class OpenEdge.Lang.OperatorEnum final: 
        
    define public static property Equals        as EnumMember no-undo get. private set.
    define public static property GreaterThan   as EnumMember no-undo get. private set.
    define public static property GreaterEqual  as EnumMember no-undo get. private set.
    define public static property LessThan      as EnumMember no-undo get. private set.
    define public static property LessEqual     as EnumMember no-undo get. private set.
    define public static property NotEqual      as EnumMember no-undo get. private set.
    define public static property Matches       as EnumMember no-undo get. private set.
    define public static property Begins        as EnumMember no-undo get. private set.
    define public static property Contains      as EnumMember no-undo get. private set.
    define public static property None          as EnumMember no-undo get. private set.
    
    constructor static OperatorEnum():
        OperatorEnum:Equals = new EnumMember(1, 'eq').
        OperatorEnum:GreaterThan = new EnumMember(2, 'gt').
        OperatorEnum:GreaterEqual = new EnumMember(3, 'ge').
        OperatorEnum:LessThan = new EnumMember(4, 'lt').
        OperatorEnum:LessEqual = new EnumMember(5, 'le').
        OperatorEnum:NotEqual = new EnumMember(6, 'ne').
        OperatorEnum:Matches = new EnumMember(7, 'matches').
        OperatorEnum:Begins = new EnumMember(8, 'begins').
        OperatorEnum:Contains = new EnumMember(9, 'contains').
        OperatorEnum:None = new EnumMember(10, '').
    end constructor.
    
    method static public logical Equals (pcOperator as char, poOperator as EnumMember):
        define variable lEqual as logical no-undo.
        
        lEqual = poOperator:ToString() eq pcOperator.
        
        /* Alternate */
        if not lEqual then
        case pcOperator:
            when '=' then lEqual = poOperator eq OperatorEnum:Equals.
            when '>' then lEqual = poOperator eq OperatorEnum:GreaterThan.
            when '>=' then lEqual = poOperator eq OperatorEnum:GreaterEqual.
            when '<' then lEqual = poOperator eq OperatorEnum:LessThan.
            when '<=' then lEqual = poOperator eq OperatorEnum:LessEqual.
            when '<>' then lEqual = poOperator eq OperatorEnum:NotEqual.
        end case.
        
        return lEqual.
    end method.
        
end class.