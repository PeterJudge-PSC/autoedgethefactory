/*------------------------------------------------------------------------
    File        : IComponentInfo
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Feb 23 13:49:11 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Class.

interface OpenEdge.CommonInfrastructure.Common.IComponentInfo:
    /** The Service type that this service implements. This could be 
        the concrete type, or one of the interfaces the component 
        implements.
        
        Typically defaults to the concrete type when the component is
        not started as a service (or interface by InjectABL). 
      */
    define public property Service as class Class no-undo get.
    
    /** Instance name for the running component. Optionally unique. */
    define public property InstanceName as character no-undo get.
    
    /** The component type (per ComponentTypeEnum) */
    define public property ComponentType as ComponentTypeEnum no-undo get. set.
    
end interface.