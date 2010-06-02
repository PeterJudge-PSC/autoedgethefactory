/*------------------------------------------------------------------------
    File        : ComponentInfo
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Feb 23 13:56:35 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum.
using OpenEdge.Lang.EnumMember.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.ComponentInfo implements IComponentInfo: 
    /** Instance name for the running component. Optionally a unique value, although
        often (usually?) just the typename of the component instance  
      */
    define public property InstanceName as character no-undo get. private set.
    
    /** The component type (per ComponentTypeEnum) */
    define public property ComponentType as ComponentTypeEnum no-undo get. set.
    
    /** The Service type that this service implements. This could be 
        the concrete type, or one of the interfaces the component 
        implements.
        
        Typically defaults to the concrete type when the component is
        not started as a service (or interface by InjectABL). 
      */
    define public property Service as class Class no-undo get. private set.

    constructor public ComponentInfo(poService as class Class):
        this-object(poService,
                    poService:TypeName,
                    ComponentTypeEnum:ApplicationComponent).         
    end constructor.

    constructor public ComponentInfo(poService as class Class, pcInstanceName as character):
        this-object(poService,
                    pcInstanceName,
                    ComponentTypeEnum:ApplicationComponent).         
    end constructor.
    
    constructor public ComponentInfo(poService as class Class, pcInstanceName as character, poComponentType as ComponentTypeEnum):
        Assert:ArgumentNotNull(poService, 'Service').
        Assert:ArgumentNotNullOrEmpty(pcInstanceName, 'Instance name').
        Assert:ArgumentNotNull(poComponentType, 'Component type').
        
        assign InstanceName = pcInstanceName
               ComponentType = poComponentType
               Service = poService. 
    end constructor.
    
    method override public logical Equals(p0 as Object):
       define variable lEqual as logical no-undo.
       define variable oCompareTo as ComponentInfo no-undo.
       
       /* Either objects are identical, or they have the same
          component type and instance names. */
       lEqual = super:Equals(p0).
       
       if not lEqual then
            assign oCompareTo = cast(p0, ComponentInfo)
                   lEqual = this-object:ComponentType:Equals(oCompareTo:ComponentType)
                            and this-object:InstanceName eq oCompareTo:InstanceName
                            and this-object:Service:Equals(oCompareTo:Service).                                    
       return lEqual.
    end method.

end class.