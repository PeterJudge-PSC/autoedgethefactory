/*------------------------------------------------------------------------
    File        : Component
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Apr 07 16:44:04 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.Component.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using Progress.Lang.Class. 
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.Component implements IComponent: 
    define public property ComponentInfo as IComponentInfo no-undo get. private set.
    
    constructor public Component(poComponentInfo as IComponentInfo):
        ComponentInfo = poComponentInfo.
    end constructor.
    
    destructor public Component():
        DestroyComponent().
    end destructor.
    
    @method(virtual="True").
    method public void CreateComponent(  ):
    end method.
    
    @method(virtual="True").
    method public void Initialize(  ):
    end method.
    
    @method(virtual="True").
    method public void DestroyComponent():
    end method.
    
    method override public logical Equals(p0 as Object):
        /** reference equality (since we're at the top here) OR
           matching component info. */
        return (super:Equals(input p0) or this-object:ComponentInfo:Equals(cast(p0, Component):ComponentInfo)).
    end method.    

end class.