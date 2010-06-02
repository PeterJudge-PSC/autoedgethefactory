/*------------------------------------------------------------------------
    File        : QueryDefinitionEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Sep 02 14:50:19 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.*.
using OpenEdge.Lang.*.

class OpenEdge.Core.System.QueryDefinitionEventArgs inherits EventArgs: 

    define public property Element   as EnumMember no-undo get. set.       /* OpenEdge.Core.System.QueryElementEnum */
    define public property Operation as EnumMember no-undo get. set.       /* OpenEdge.Core.System.OperationEnum */
    define public property Value     as character no-undo get. set.
            
    constructor public QueryDefinitionEventArgs():
        super().
    end constructor.
    
    constructor public QueryDefinitionEventArgs(poElement as EnumMember, poOperation as EnumMember):
        this-object(poElement, poOperation, ?).
    end constructor.
        
    constructor public QueryDefinitionEventArgs(poElement as EnumMember, poOperation as EnumMember, pcValue as char):
        this-object().
        
        this-object:Element = poElement.
        this-object:Operation = poOperation.        
        this-object:Value = pcValue.
    end constructor.
    
end class.