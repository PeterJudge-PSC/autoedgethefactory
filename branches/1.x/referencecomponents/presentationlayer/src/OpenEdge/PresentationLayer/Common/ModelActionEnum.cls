/** ------------------------------------------------------------------------
    File        : ModelActionEnum
    Purpose     : Enumeration of actions a model can perform.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Oct 28 12:27:03 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Common.ModelActionEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.PresentationLayer.Common.ModelActionEnum final inherits EnumMember:
    
    /* Local Actions */ 
    define static public property Add    as ModelActionEnum no-undo get. private set.
    define static public property Save   as ModelActionEnum no-undo get. private set.
    define static public property Delete as ModelActionEnum no-undo get. private set.
    
    define static public property Navigate as ModelActionEnum no-undo get. private set.
    
    /* Service actions */
    define static public property Fetch  as ModelActionEnum no-undo get. private set.
    define static public property Commit as ModelActionEnum no-undo get. private set.
    
    constructor static ModelActionEnum():
        ModelActionEnum:Add = new ModelActionEnum('Add').
        ModelActionEnum:Save = new ModelActionEnum('Save').
        ModelActionEnum:Delete = new ModelActionEnum('Delete').
        
        ModelActionEnum:Navigate = new ModelActionEnum('Navigate').
        
        ModelActionEnum:Fetch = new ModelActionEnum('Fetch').
        ModelActionEnum:Commit = new ModelActionEnum('Commit').
    end constructor.

    constructor public ModelActionEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
end class.