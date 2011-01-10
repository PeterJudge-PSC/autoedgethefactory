/** ------------------------------------------------------------------------
    File        : IComponentInfo
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Feb 23 13:49:11 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.IComponentInfo.
using OpenEdge.CommonInfrastructure.IComponent.
using OpenEdge.CommonInfrastructure.CommonComponentTypeEnum.
using Progress.Lang.Class.

interface OpenEdge.CommonInfrastructure.IComponentInfo:
    /** The Service type that this service implements. This could be 
        the concrete type, or one of the interfaces the component 
        implements.
        
        Typically defaults to the concrete type when the component is
        not started as a service (or interface by InjectABL).   */
    define public property Service as class Class no-undo get.
    
    /** Whether the component is auto-started when it is requested, or whether
        it should be explicitly started first.  */
    define public property AutoStart as logical no-undo get.
    
    /** Instance name for the running component. Optionally a unique value, although
        often (usually?) just the typename of the component instance . */
    define public property InstanceName as character no-undo get.
    
    /** The component type (per ComponentTypeEnum) */
    define public property ComponentType as CommonComponentTypeEnum no-undo get. set.
    
end interface.