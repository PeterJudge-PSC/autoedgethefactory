/** ------------------------------------------------------------------------
    File        : FillModeEnum
    Purpose     : Enumeration of ProDataSet fill modes 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 12 15:07:13 EDT 2009
    Notes       : * Based on the ABL documentation 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.Lang.FillModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.FillModeEnum final inherits EnumMember:
    
    define public static property Default as FillModeEnum no-undo get. private set.
    define public static property Append  as FillModeEnum no-undo get. private set.
    define public static property Empty   as FillModeEnum no-undo get. private set.
    define public static property Merge   as FillModeEnum no-undo get. private set.
    define public static property NoFill  as FillModeEnum no-undo get. private set.
    define public static property Replace as FillModeEnum no-undo get. private set.
    
    constructor static FillModeEnum():
        FillModeEnum:Append = new FillModeEnum('Append').
        FillModeEnum:Empty = new FillModeEnum('Empty').
        FillModeEnum:Merge = new FillModeEnum('Merge').
        FillModeEnum:NoFill = new FillModeEnum('No-Fill').
        FillModeEnum:Replace = new FillModeEnum('Replace').
        
        FillModeEnum:Default = FillModeEnum:Merge.
    end constructor.
    
    constructor public FillModeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method static public FillModeEnum StringToEnum(input pcName as character):
        define variable oEnum as FillModeEnum no-undo.
        
        case pcName:
            when FillModeEnum:Append:Name then oEnum = FillModeEnum:Append.
            when FillModeEnum:Empty:Name then oEnum = FillModeEnum:Empty.
            when FillModeEnum:Merge:Name then oEnum = FillModeEnum:Merge.
            when FillModeEnum:NoFill:Name then oEnum = FillModeEnum:NoFill.
            when FillModeEnum:Replace:Name then oEnum = FillModeEnum:Replace.  
        end case.
        
        return oEnum.
    end method.
    
end class.