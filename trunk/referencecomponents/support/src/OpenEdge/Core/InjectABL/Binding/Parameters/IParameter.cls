/** ------------------------------------------------------------------------
    File        : IParameter
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 09:26:12 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Lang.DataTypeEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.Core.InjectABL.Binding.Parameters.IParameter:
    /** Gets the name of the parameter. */
    define public property Name as character no-undo get.    
    define public property Type as DataTypeEnum no-undo get.
    
    /** Specify a declared type for cases where the parameter an object or array thereof. ABL doesn't currently (10.2B)
        allow us to discover either the declared type of the array, or the signature of the callee (method, property, ctor),
        and so we need to specify the type for the InjectABL kernel. */
    define public property DeclaredType as class Class no-undo get.
    
    /** Gets the value for the parameter within the specified context.
        @param context The context.
        @return The value for the parameter. */
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object).
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object extent).
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character).
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character extent).
    
end interface.