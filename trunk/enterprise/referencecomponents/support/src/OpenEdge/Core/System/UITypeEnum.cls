@deprecated(version="0.0").
/** ------------------------------------------------------------------------
    File        : UITypeEnum
    Purpose     : Lists the supported UI types  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Apr 23 15:08:30 EDT 2010
    Notes       : * This class is not final since implementers could have their
                    own names for UI types.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.UITypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.System.UITypeEnum inherits EnumMember:
    /** Character-mode UI */
    define static public property Chui as UITypeEnum no-undo get. private set.
    /** 'Classic' ABL GUI */
    define static public property AblGui as UITypeEnum no-undo get. private set.
    /* OpenEdge GUI for .NET */
    define static public property DotNetGui as UITypeEnum no-undo get. private set.
    /** RIA/Web UI */
    define static public property RiaGui as UITypeEnum no-undo get. private set.
    
    constructor static UITypeEnum():
        assign UITypeEnum:Chui = new UITypeEnum('Chui')
               UITypeEnum:AblGui = new UITypeEnum('AblGui')
               UITypeEnum:DotNetGui = new UITypeEnum('DotNetGui')
               UITypeEnum:RiaGui = new UITypeEnum('RiaGui').
    end constructor.
    
    constructor public UITypeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
end class.