/** ------------------------------------------------------------------------
    File        : Component
    Purpose     : OERA Base component
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 07 16:44:04 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.Component.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.Component implements IComponent:
        
    define static public property IComponentType as class Class no-undo
        get():
            if not valid-object(Component:IComponentType) then
                Component:IComponentType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.IComponent').
                
            return Component:IComponentType.
        end get.
        private set.
    
    /** (mandatory) Stores information about the component, such as a developer-defined instance name
        so as to be able to uniquely identify the component.   */
    define public property ComponentInfo as IComponentInfo no-undo get. private set.
    
    constructor public Component(poComponentInfo as IComponentInfo):
        Assert:ArgumentNotNull(poComponentInfo, 'Component info').
        
        ComponentInfo = poComponentInfo.
    end constructor.
    
    destructor public Component():
        DestroyComponent().
    end destructor.
    
    /** General creation code; constructors should only be used for property setting, not
        for any more complex wiring.  */
    @method(virtual="True").
    method public void CreateComponent(  ):
    end method.
    
    /** Not InitializeComponent, since the Gui for .NET uses that name already, 
       as a PRIVATE member, and we want to have only 1 IComponent interface. */    
    @method(virtual="True").
    method public void Initialize(  ):
    end method.
    
    /** General destruction code that can be called outside of the destructor
        if needed (but will also be called from within the dtor). */
    @method(virtual="True").
    method public void DestroyComponent():
    end method.
    
    method override public logical Equals(p0 as Object):
        /** reference equality (since we're at the top here) OR
           matching component info. */
        return (super:Equals(input p0) or this-object:ComponentInfo:Equals(cast(p0, Component):ComponentInfo)).
    end method.    

end class.