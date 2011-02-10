/** ------------------------------------------------------------------------
    File        : ServiceManager
    Purpose     : The ServiceManager provides access into a session's services.
                  Services are things that are exposed internally to the application
                  - such as a ContextManager - and also externally such as to a WebService.
                  These services can be composed of Components (and are in fact specialised
                  Components).
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 18 14:41:08 EST 2010
    Notes       : * The ServiceManager bootstraps the session.
                  * The ServiceManager is a special type, and is not itself a service
                    or component (even though other services/components usually are).
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.Common.InjectABL.ManagerScopeEnum.
using OpenEdge.CommonInfrastructure.Common.ServiceTypeEnum.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.IService.
using OpenEdge.CommonInfrastructure.Common.Service.
using OpenEdge.CommonInfrastructure.Common.Component.
using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.Common.IComponentCollection.
using OpenEdge.CommonInfrastructure.Common.ComponentInfo.
using OpenEdge.CommonInfrastructure.Common.Component.
using OpenEdge.CommonInfrastructure.Common.IManager.

using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.IBindingCollection.
using OpenEdge.Core.InjectABL.Binding.Parameters.Routine.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Lifecycle.ICache.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext. 
using OpenEdge.Core.InjectABL.IKernel.

using OpenEdge.Core.System.NotFoundError.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.Collection.
using OpenEdge.Lang.RoutineTypeEnum.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.ServiceManager
        implements IServiceManager, IManager:
    
    /** Use this property in lieu of having to say Class:GetClass('....IServiceManager') every time */
    define static public property IServiceManagerType as class Class no-undo get. private set.
    define static public property IServiceProviderType as class Class no-undo get. private set.
    
    define private variable moAppStart as IService no-undo.
    
    define private temp-table Service no-undo
        field ServiceType  as Object        /* ServiceTypeEnum */
        field Service       as Object       /* Progress.Lang.Class */
        field Instance      as Object       /* IComponent or IService */
        /* Order added, per component type */
        index idx1 as primary ServiceType Service
        index idx2 Instance
        index idx3 Service.
    
    /** InjectABL Dependency injection/Inversion of Control container. */
    define public property Kernel as IKernel no-undo get. private set.
    
    constructor static ServiceManager():
        ServiceManager:IServiceManagerType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager').
        ServiceManager:IServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceProvider').
    end constructor.

    constructor public ServiceManager(input poKernel as IKernel):
        super().
        
        this-object:Kernel = poKernel.
    end constructor.
    
    destructor public ServiceManager():
        DestroyComponent().
        
        this-object:Kernel = ?.
    end destructor.
    
    /** General creation code; constructors should only be used for property setting, 
        not for any more complex wiring.  */
    method public void CreateComponent():
    end method.
    
    /** Not InitializeComponent, since the Gui for .NET uses that name already, 
       as a PRIVATE member, and we want to have only 1 IComponent interface. */
    method public void Initialize():
        StartServices().
/*        moAppStart = StartService(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IApplicationStart')).*/
    end method.
    
    /** General destruction code that can be called outside of the destructor
        if needed (but will also be called from within the dtor). */
    method public void DestroyComponent():
        StopServices().
        
        /* Also stop objects that are scoped to the Service Manager, although  
           any registered services should be stopped already anyway. */
        cast(Kernel:Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ICache')), ICache):Clear(this-object).        
    end method.

    method protected logical RegisterService(input poServiceType as ServiceTypeEnum,
                                             input pcServiceName as character):
        Assert:ArgumentIsValidType(pcServiceName).
        return RegisterService(poServiceType, Class:GetClass(pcServiceName)).
    end method.
        
    method protected logical RegisterService(input poServiceType as ServiceTypeEnum,
                                             input poService as class Class):
        define variable lNew as logical no-undo.
        define buffer lbService for Service.
        
        lNew = not can-find(lbService where 
                            lbService.Service     = poService and
                            lbService.ServiceType = poServiceType ).
        if lNew then
        do:
            create lbService.
            assign lbService.Service = poService
                   lbService.ServiceType = poServiceType.
        end.
        
        return lNew.
    end method.
    
    method public void ResetManager():
        @todo(task="implement", action="").
    end method.
    
    method public void StartServices():
        define variable oService as IService no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oScopedInstance as Object extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oServiceType as class Class no-undo.
        
        define buffer lbService for Service.
        
        /** Components can be added via RegisterService() or via a custom Scope in the Kernel of ManagerScope:ServiceManager.
        RegisterService(ServiceTypeEnum:Manager, 'OpenEdge.CommonInfrastructure.Common.ISecurityManager').
        */
        
        /* Get running instances of all scoped objects. */
        oScopedInstance = Kernel:Get(ManagerScopeEnum:ServiceManager,
                                     Class:GetClass('OpenEdge.CommonInfrastructure.Common.InjectABL.ManagerScope')).
        
        if extent(oScopedInstance) ge 1 then
        do:
            iMax = extent(oScopedInstance).
            do iLoop = 1 to iMax:
                oServiceType = oScopedInstance[iLoop]:GetClass(). 
                
                /* we don't know what we've got here, so use generic AppComponent */
                RegisterService(ServiceTypeEnum:Manager, oServiceType).
                
                find lbService where
                     lbService.Service     = oServiceType and
                     lbService.ServiceType = ServiceTypeEnum:Manager.
                lbService.Instance = oScopedInstance[iLoop].
            end.
        end.
        
        for each lbService where lbService.Instance = ?:
            oService = StartService(cast(lbService.Service, Class)).
        end.
    end method.
    
    method public void StopServices():
        define buffer lbService for Service.
        
        /* first stop the appstart object*/
        StopService(moAppStart).
        
        for each lbService:
            StopService(cast(lbService.Instance, IService)).
            lbService.Instance = ?.
            delete lbService.
        end.
    end method.
    
    /** Starts a service
        @param poServiceType component type; ignored when InjectABL used, since we work off interfaces, which are
               unique within the application.
        @param pcComponentName 
        @return An IComponent instance of the requested service */
    method public IService StartService(input poServiceType as ServiceTypeEnum,
                                        input pcServiceName as character):
        /* Register the component */
        RegisterService(poServiceType, pcServiceName).
        
        return StartService(Class:GetClass(pcServiceName)).
    end method.
    
    /** Starts a service using the InjectABL dependency injection container.
        @param poComponent The class of the service to start 
        @return An IComponent instance of the requested service */
    method public IService StartService(input poService as class Class):
        return StartService(poService, ''). 
    end method.
    
    /** Starts and returns a service as specified by a type/class. Typically
        an interface type name.
                
        @param Class The class of the service to start
        @param character An instance name for the service. InjectABL allows us
               to have mulitple bindings for a single type, specialised by instance name. 
        @return IService The running instance of the requested service */    
    method public IService StartService(input poService as class Class,
                                        input pcInstanceName as character):
        define variable oService as IService no-undo.
        define variable lCache as logical no-undo.
        define buffer lbService for Service.
        
        if pcInstanceName eq '' then
            find lbService where
                 lbService.Service     = poService and
                 lbService.ServiceType = ServiceTypeEnum:Manager
                 no-error.
        lCache = available lbService. 
        if lCache then
            oService = cast(lbService.Instance, IService).
        
        /* check for validity rather than availability in case the cache has
           gone stale. */
        if not valid-object(oService) then
        do:
            oService = cast(StartComponent(poService, pcInstanceName), IService).
            if lCache then
                lbService.Instance = oService. 
        end.
        
        return oService.
    end method.
    
    /** Returns an instance of a service, if one exists. May AutoStart
        an instance.
        @param poService The class of the service to start 
        @return An IService instance of the requested service */    
    method public IService GetService(input poService as class Class):
        return StartService(poService, '').
    end method.
    
    /** Returns an instance of a service, if one exists.
        
        @param Class The class of the service to start
        @param character An instance name for the service. InjectABL allows us
               to have mulitple bindings for a single type, specialised by instance name. 
        @return IService The running instance of the requested service */
    method public IService GetService(input poService as class Class,
                                      input pcInstanceName as character).
        return StartService(poService, pcInstanceName).
    end method.
    
    /** Stops a running service.
        @param poComponent A running component instance */
    method public void StopService(input poServiceInstance as IService):
        if valid-object(poServiceInstance) then
            StopComponent(cast(poServiceInstance, IComponent)).
    end method.
    
    method protected IComponent StartComponent(input poComponent as class Class,
                                               input pcInstanceName as character ):
        return cast(Kernel:Get(poComponent, pcInstanceName), IComponent).
    end method. 
    
    method protected void StopComponent(input poComponentInstance as IComponent):
        define variable lReleased as logical no-undo.
        
        /* Component only released if cached. If it's not cached, we need to
           manually 'deactivate' it (aka DestroyComponent). */
        if valid-object(poComponentInstance) then
        do:
            lReleased = Kernel:Release(poComponentInstance).
            
            if not lReleased then
                poComponentInstance:DestroyComponent().
        end.
    end method.
    
    /** Finds (and starts if needed) an IServiceProvider which applies to the service name passed as 
        an argument. 
    
        The client-side service provider is typically a service adapter, which talks across a session boundary
        to a service interface. That service interface talks to the server-side service provider and asks it 
        to perform a task ("service a request").
       
        The server-side service provider is typically a business component such as a business entity, task or 
        workflow.
        
        @param character The name of the service for which we need to perform a request.
        @return IServiceProvider An object capable of serviving that request.   */
    method public IServiceProvider GetServiceProvider(input pcService as character):
        define variable oServiceProvider as IServiceProvider no-undo.
        
        oServiceProvider = cast(Kernel:Get(ServiceManager:IServiceProviderType, pcService), IServiceProvider).
        
        /* Make sure we've set the service name correctly. */
        if valid-object(oServiceProvider) then
            oServiceProvider:SetService(pcService).
        
        return oServiceProvider.
    end method.
    
end class.