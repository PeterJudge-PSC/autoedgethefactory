/*------------------------------------------------------------------------
    File        : IInjectionRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 19 15:58:31 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection.
using Progress.Lang.Class.

interface OpenEdge.Core.InjectABL.IInjectionRequest:
    /** The
      */         
    define public property ServiceType as class Class no-undo get.
    
    /** (optional) If a service is named in the binding, allow specification of the name
        for the request.  */
    define public property Name as character no-undo get.
    
    /** (optional) Gets the parameters that were passed to manipulate the activation process. **/
    define public property Parameters as IParameterCollection no-undo get. set.
  
end interface.