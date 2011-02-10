/** ------------------------------------------------------------------------
    File        : Service
    Purpose     : General OERA service  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 19 16:29:36 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.CommonInfrastructure.Common.Service.
using OpenEdge.CommonInfrastructure.Common.IService.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IServiceManager. 
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.Component.

using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.Service inherits Component
        implements IService:

    define static public property IServiceType as class Class no-undo
        get():
            if not valid-object(Component:IComponentType) then
                Service:IServiceType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.IService').
            
            return Service:IServiceType.
        end get.
        private set.
    
    /** (mandatory) Stores a reference to the session's Service Manager */
    define public property ServiceManager as IServiceManager no-undo
        get():
            if not valid-object(ServiceManager) then
                ServiceManager = cast(ABLSession:Instance:SessionProperties:Get(OpenEdge.CommonInfrastructure.Common.ServiceManager:IServiceManagerType)
                                   , IServiceManager).
            return ServiceManager.
        end get.
        private set.
    
    constructor public Service (poComponentInfo as IComponentInfo):
        super(poComponentInfo).
    end constructor.
    
    @todo(task="refactor", action="remove this ctor").
    constructor public Service (poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(cast(poComponentInfo, IComponentInfo)).
        
        Assert:ArgumentNotNull(poServiceManager, 'Service Manager').
        ServiceManager = poServiceManager. 
    end constructor.
    
end class.