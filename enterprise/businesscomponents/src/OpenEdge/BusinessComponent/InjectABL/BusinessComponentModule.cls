/** ------------------------------------------------------------------------
    File        : BusinessComponentModule
    Purpose     : Standard business components module - contains generic code for 
                  loading business entities etc.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 01 16:15:19 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.Entity.BusinessEntity.
using OpenEdge.BusinessComponent.Task.BusinessTask.
using OpenEdge.DataSource.DataSource.

using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.BusinessComponent.InjectABL.BusinessComponentModule abstract inherits InjectionModule: 
    
    define protected property IWorkStepType as class Class no-undo get. set.
    define protected property WorkStepServiceInterfaceType as class Class no-undo get. set.
    define protected property BusinessEntityServiceInterfaceType as class Class no-undo get. set.
    define protected property BusinessEntityDataContainerType as class Class no-undo get. set.
    define protected property BusinessTaskServiceInterfaceType as class Class no-undo get. set.
    define protected property IDataAccessType as class Class no-undo get. set.
    define protected property IServiceProviderType as class Class no-undo get. set.
    define protected property InjectABLServiceProviderType as class Class no-undo get. set.
    define protected property InjectABLComponentProviderType as class Class no-undo get. set.
    
    constructor public BusinessComponentModule():
        super ().
        
        /* do this one per type, for readability and possibly performance too */
        assign BusinessEntityServiceInterfaceType = Class:GetClass('OpenEdge.BusinessComponent.Entity.ServiceInterface')
               BusinessEntityDataContainerType = Class:GetClass('OpenEdge.BusinessComponent.Entity.DataContainerEntity')
               BusinessTaskServiceInterfaceType = Class:GetClass('OpenEdge.BusinessComponent.Task.BusinessTaskServiceInterface')
               IDataAccessType = Class:GetClass('OpenEdge.DataAccess.IDataAccess')
               IServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceProvider')
               IWorkStepType = Class:GetClass('OpenEdge.BusinessComponent.WorkFlow.IWorkStep')
               WorkStepServiceInterfaceType = Class:GetClass('OpenEdge.BusinessComponent.WorkFlow.WorkStepServiceInterface')
               InjectABLServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.InjectABL.ServiceProvider')
               InjectABLComponentProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.InjectABL.ComponentProvider').
    end constructor.

    /** BUSINESS WORKFLOWS **/
/*
    method protected void BindBusinessEntity(input pcBindingName as character,
                                             input pcConcreteBEType as character,
                                             input pcDAName as character,
                                             input pcConcreteDAType as character,
                                             input pcDataSourceName as character extent,
                                             input pcDataSourceKey as character extent,
                                             input pcConcreteDataSourceType as character extent):
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        define variable oDataSourceBindingSyntax as IBindingSyntax no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oArgs as IParameter extent no-undo.
        
        /* bind as a service interface */
        oBindingSyntax = Bind(IServiceProviderType).
        oBindingSyntax
            :Named(pcBindingName)
            :To(BusinessEntityServiceInterfaceType)
            :OnServerSession()
            :WithPropertyValue('Service', pcBindingName).
        
        assign extent(oArgs) = 1 
               oArgs[1] = new Parameter(BusinessEntity:IBusinessEntityType, pcBindingName).
        oBindingSyntax
            :WithConstructorArgument(oArgs).
        
        /* Bind actual Business Entity */
        oBindingSyntax = Bind(BusinessEntity:IBusinessEntityType).
        oBindingSyntax
            :Named(pcBindingName)
            :To(pcConcreteBEType).
        
        oBindingSyntax
            :WithConstructorArgument(IDataAccessType, pcDAName)
            :Using(InjectABLServiceProviderType)
            :InAgentRequestScope().
        
        /* bind data access */
        oBindingSyntax = Bind(IDataAccessType).
        oBindingSyntax
            :Named(pcDAName)
            :To(pcConcreteDAType).
        
        assign extent(oArgs) = ?
               iMax = extent(pcDataSourceName)
               extent(oArgs) = 2.
        do iLoop = 1 to iMax:
            /* Add datasource to dataaccess binding. use this one loop
               for efficiency's sake */
            assign oArgs[1] = new Parameter(pcDataSourceKey[iLoop])
                   oArgs[2] = new Parameter(DataSource:IDataSourceType, pcDataSourceName[iLoop]).
            oBindingSyntax
                :WithMethodValue('AddDataSource', oArgs).
            
            /* bind datasources */
            oDataSourceBindingSyntax = Bind(DataSource:IDataSourceType).
            oDataSourceBindingSyntax
                :Named(pcDataSourceName[iLoop])
                :To(pcConcreteDataSourceType[iLoop])
                :Using(InjectABLComponentProviderType).
        end.
    end method.
*/        
    method protected void BindBusinessEntity(input pcBindingName as character,
                                             input pcConcreteBEType as character,
                                             input pcDAName as character,
                                             input pcConcreteDAType as character,
                                             input pcDataSourceName as character extent,
                                             input pcDataSourceKey as character extent,
                                             input pcConcreteDataSourceType as character extent):
        BindBusinessEntity(pcBindingName,
                           '',
                           pcConcreteBEType,
                           pcDAName,
                           pcConcreteDAType,
                           pcDataSourceName,
                           pcDataSourceKey,
                           pcConcreteDataSourceType).                                                 
    end method.
    
    method protected void BindBusinessEntity(input pcBindingName as character,
                                             input pcBEServiceName as character,
                                             input pcConcreteBEType as character,
                                             input pcDAName as character,
                                             input pcConcreteDAType as character,
                                             input pcDataSourceName as character extent,
                                             input pcDataSourceKey as character extent,
                                             input pcConcreteDataSourceType as character extent):
        /* Use local variables oBS as bug workaround */
        define variable cServiceName as character no-undo.
        define variable oBEServiceType as class Class no-undo.
        define variable oBindingSyntax as IBindingSyntax no-undo.
        define variable oDataSourceBindingSyntax as IBindingSyntax no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oArgs as IParameter extent no-undo.
        
        /* If we have a specialised interface, no need to bind the generic IBusinessEntity with a name */
        if pcBEServiceName ne '' and pcBEServiceName ne ? then
        do:
            Assert:ArgumentIsValidType(pcBEServiceName).
            oBEServiceType = Class:GetClass(pcBEServiceName).
            cServiceName = ''.
        end.
        else
            assign oBEServiceType = BusinessEntity:IBusinessEntityType
                   cServiceName = pcBindingName.
        
        assign extent(oArgs) = 1 
               oArgs[1] = new Parameter(oBEServiceType, cServiceName).
        
        /* Bind as a service interface. This is always tied to the 
           binding name (not servicename), since we're binding to a generic interface. */
        oBindingSyntax = Bind(IServiceProviderType).
        oBindingSyntax
            :Named(pcBindingName)
            :To(BusinessEntityServiceInterfaceType)
            :OnServerSession()
            :WithPropertyValue('Service', pcBindingName)
            /* use the BE binding from above */
            :WithConstructorArgument(oArgs).
        
        /* Bind actual Business Entity */
        oBindingSyntax = Bind(oBEServiceType).
        oBindingSyntax
            :Named(cServiceName)
            :To(pcConcreteBEType).
        
        oBindingSyntax
            :WithConstructorArgument(IDataAccessType, pcDAName)
            :Using(InjectABLServiceProviderType)
            :InAgentRequestScope().
        
        /* bind data access */
        oBindingSyntax = Bind(IDataAccessType).
        oBindingSyntax
            :Named(pcDAName)
            :To(pcConcreteDAType).
        
        assign extent(oArgs) = ?
               iMax = extent(pcDataSourceName)
               extent(oArgs) = 2.
        do iLoop = 1 to iMax:
            /* Add datasource to dataaccess binding. use this one loop
               for efficiency's sake */
            assign oArgs[1] = new Parameter(pcDataSourceKey[iLoop])
                   oArgs[2] = new Parameter(DataSource:IDataSourceType, pcDataSourceName[iLoop]).
            oBindingSyntax
                :WithMethodValue('AddDataSource', oArgs).
            
            /* bind datasources */
            oDataSourceBindingSyntax = Bind(DataSource:IDataSourceType).
            oDataSourceBindingSyntax
                :Named(pcDataSourceName[iLoop])
                :To(pcConcreteDataSourceType[iLoop])
                :Using(InjectABLComponentProviderType).
        end.
    end method.

    /** Workstep binding to service interface, workstep 
    
        A Workstep can be decorated as BizLogic workstep. In that case, we                        
            IWorkStep -> SomeBizLogicWorkStep decorates SomeWorkStep
        If not, then the we use bormal binding
            IWorkStep -> SomeWorkStep
        
        This possible decorated workstep now also needs to be exposed 
        as a service interface
            WorkStepServiceInterfaceType decorates IWorkStep (whih is either 
                    SomeWorkStep or SomeBizLogicWorkStep)
    */
    method protected void BindWorkStep(input pcBindingName as character,
                                       input pcConcreteType as character,
                                       input pcDecoratedType as character): 
        
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        define variable oSIArgs as IParameter extent 1 no-undo.
        define variable oBLArgs as IParameter extent 2 no-undo.
        
        /* Use a service interface to bind the service to the workstep */
        oBindingSyntax = Bind(IServiceProviderType).
        oBindingSyntax
            :Named(pcBindingName)
            :To(WorkStepServiceInterfaceType)
            :OnServerSession().
        
        /* parameters for passing into constructor */
        oSIArgs[1] = new Parameter(IWorkStepType, pcBindingName).
        oBindingSyntax
            :WithConstructorArgument(oSIArgs)
            :WithPropertyValue('Service', pcBindingName).
        
        /* Internal/Standard exposure as IWorkStep */
        
        oBindingSyntax = Bind(IWorkStepType).
        oBindingSyntax:Named(pcBindingName)
            :WithPropertyValue('Name', pcBindingName).
        
        /* if this is a plain workstep, then it's a service and we simply bind to the concrete type */
        if pcDecoratedType eq '' then
            oBindingSyntax
                :To(pcConcreteType)
                :Using(InjectABLServiceProviderType).
        else
        /* if it is a decorated type, then bind the decorated type to itself, and the */
        do:
            oBindingSyntax = Bind(pcDecoratedType).
            oBindingSyntax
                :Named(pcBindingName)
                :ToSelf()
                :Using(InjectABLServiceProviderType).
            
            /* Bizlogic workstep: pass in the decorated type (the ABL workstep) and the BPM server name */
            oBLArgs[1] = new Parameter(Class:GetClass(pcDecoratedType)).
            oBLArgs[2] = new Parameter('AutoEdgeTheFactory').
            oBindingSyntax
                :WithConstructorArgument(oBLArgs).
        end.
    end method.
    method protected void BindBusinessTask(input pcBindingName as character,
                                           input pcBTType as character,
                                           input pcConcreteBTType as character,
                                           input pcBusinessEntityName as character extent):
        
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        define variable oDataSourceBindingSyntax as IBindingSyntax no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oBTArgs as IParameter extent no-undo.
        define variable oBEArgs as IParameter extent 1 no-undo.
        define variable oTypeArray as class Class extent no-undo.
        define variable cEntityArray as character extent no-undo.
        define variable oTaskServiceType as class Class no-undo.
        define variable oEntityServiceType as class Class no-undo.
        define variable cServiceName as character no-undo.
        
        /* If we have a specialised interface, no need to bind the generic IBusinessTask with a name */
        if pcBTType ne '' and pcBTType ne ? then
        do:
            Assert:ArgumentIsValidType(pcBTType).
            oTaskServiceType = Class:GetClass(pcBTType).
            cServiceName = ''.
        end.
        else
            assign oTaskServiceType = BusinessTask:IBusinessTaskType
                   cServiceName = pcBindingName.
        
        /* Bind as a service interface. This is always tied to the 
           binding name (not servicename), since we're binding to a generic interface. */
        assign extent(oBTArgs) = 1 
               oBTArgs[1] = new Parameter(oTaskServiceType, cServiceName).
        
        oBindingSyntax = Bind(IServiceProviderType).
        oBindingSyntax
            :Named(pcBindingName)
            :To(BusinessTaskServiceInterfaceType)
            :OnServerSession()
            :WithPropertyValue('Service', pcBindingName)
            :WithConstructorArgument(oBTArgs).
        
        /* Bind actual Business Task. */
        assign iMax = extent(pcBusinessEntityName)
               extent(oTypeArray) = iMax
               extent(cEntityArray) = iMax.
        
        do iLoop = 1 to iMax:
            /* If the BE name is an interface/type, then use that as the binding without a name.
               If the BE name is not an interface, assume that it's an instance of a IBusinessEntity */
            oEntityServiceType = Class:GetClass(pcBusinessEntityName[iLoop]) no-error.
            if valid-object(oEntityServiceType) then
                assign oTypeArray[iLoop] = oEntityServiceType
                       cEntityArray[iLoop] = ''.
            else
                assign oTypeArray[iLoop] = BusinessEntity:IBusinessEntityType
                       cEntityArray[iLoop] = pcBusinessEntityName[iLoop].
        end.
        
        oBTArgs[1] = new Parameter(oTypeArray, cEntityArray, BusinessEntity:IBusinessEntityType).
        
        oBindingSyntax = Bind(oTaskServiceType).
        oBindingSyntax
            :Named(cServiceName)
            :To(pcConcreteBTType)
            :OnServerSession()
            :WithConstructorArgument(oBTArgs)
            :Using(InjectABLServiceProviderType)
            :InAgentRequestScope().
            
    end method.
    
end class.