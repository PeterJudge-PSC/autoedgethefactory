/*------------------------------------------------------------------------
    File        : IInjectionModuleCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 14:07:31 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule.
using OpenEdge.Lang.Collections.TypedCollection.
using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection inherits TypedCollection: 
    
    constructor public IInjectionModuleCollection():
        super(Class:GetClass('OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule')).
    end constructor.
    
end class.