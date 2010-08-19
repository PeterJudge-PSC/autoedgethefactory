@todo(task="question", action="should this be deprecated?").
@deprecated(version="0.0").

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
 
    define static public property None    as ModelActionEnum no-undo get. private set.
    define static public property Fetch   as ModelActionEnum no-undo get. private set.
    define static public property Add     as ModelActionEnum no-undo get. private set.
    define static public property Delete  as ModelActionEnum no-undo get. private set.
    define static public property Save    as ModelActionEnum no-undo get. private set.
    define static public property Commit  as ModelActionEnum no-undo get. private set.
    
    constructor static ModelActionEnum():
        ModelActionEnum:None = new ModelActionEnum('none').
        ModelActionEnum:Fetch = new ModelActionEnum('fetch').
        ModelActionEnum:Add = new ModelActionEnum('add').
        ModelActionEnum:Delete = new ModelActionEnum('delete').
        ModelActionEnum:Save = new ModelActionEnum('save').
        ModelActionEnum:Commit = new ModelActionEnum('commit').
    end constructor.

	constructor public ModelActionEnum ( input pcName as character ):
		super (input pcName).
	end constructor.
    
end class.