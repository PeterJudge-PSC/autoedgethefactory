/** ------------------------------------------------------------------------
    File        : QueryDefinitionEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Sep 02 14:50:19 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.Core.System.EventArgs.
using OpenEdge.Core.System.QueryElementEnum.
using OpenEdge.Core.System.QueryDefinitionOperationEnum.

class OpenEdge.Core.System.QueryDefinitionEventArgs inherits EventArgs: 

    define public property Element   as QueryElementEnum no-undo get. set.
    define public property Operation as QueryDefinitionOperationEnum no-undo get. set.
    define public property Value     as character no-undo get. set.
    
    @todo(task="implement", action="add querybuffer/filter that changed?").
    
    constructor public QueryDefinitionEventArgs():
        super().
    end constructor.
    
    constructor public QueryDefinitionEventArgs(poElement as QueryElementEnum, poOperation as QueryDefinitionOperationEnum):
        this-object(poElement, poOperation, ?).
    end constructor.
        
    constructor public QueryDefinitionEventArgs(poElement as QueryElementEnum, poOperation as QueryDefinitionOperationEnum, pcValue as char):
        this-object().
        
        this-object:Element = poElement.
        this-object:Operation = poOperation.        
        this-object:Value = pcValue.
    end constructor.
    
end class.