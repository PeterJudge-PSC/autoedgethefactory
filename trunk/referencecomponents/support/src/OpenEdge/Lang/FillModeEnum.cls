/** ------------------------------------------------------------------------
    File        : FillModeEnum
    Purpose     : Enumeration of ProDataSet fill modes 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 12 15:07:13 EDT 2009
    Notes       : * Based on the ABL documentation 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.FillModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.FillModeEnum final inherits EnumMember:
    
    define public static property Default       as FillModeEnum no-undo get. private set.
    define public static property Append        as FillModeEnum no-undo get. private set.
    define public static property Empty         as FillModeEnum no-undo get. private set.
    define public static property Merge         as FillModeEnum no-undo get. private set.
    define public static property NoFill        as FillModeEnum no-undo get. private set.
    define public static property Replace       as FillModeEnum no-undo get. private set.
    
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
    
end class.