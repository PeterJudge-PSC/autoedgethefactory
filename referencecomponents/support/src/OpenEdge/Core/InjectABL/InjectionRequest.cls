/*------------------------------------------------------------------------
    File        : InjectionRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 19 14:39:18 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection.
using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.InjectionRequest:
    
    @todo(task="implement", action="implement this, so that a request can be made (pass into KernelBase:Inject() ").
    
    define public property ServiceType as class Class no-undo get. private set.
    define public property Name as character no-undo get. private set.
    
    /** (optional) Gets the parameters that were passed to manipulate the activation process. **/
    define public property Parameters as IParameterCollection no-undo get. set.
    
    constructor public InjectionRequest(poService as class Class, pcName as char):        
        assign this-object:Name = pcName
               this-object:ServiceType = poService.
    end constructor.

    constructor public InjectionRequest(poService as class Class, pcName as char, poParameters as IParameterCollection):
        this-object(poService, pcName).        
        assign this-object:Parameters = poParameters.
    end constructor.
    
end class.