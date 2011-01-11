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

using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.

using Progress.Lang.Class.

class OpenEdge.BusinessComponent.InjectABL.BusinessComponentModule abstract inherits InjectionModule: 
    
    define protected property IWorkStepType as class Class no-undo get. set.
    define protected property WorkStepServiceInterfaceType as class Class no-undo get. set.
    define protected property BizLogicWorkStepType as class Class no-undo get. set.
    define protected property IBizLogicServerParametersType as class Class no-undo get. set.
    define protected property IBusinessEntityType as class Class no-undo get. set.
    define protected property BusinessEntityServiceInterfaceType as class Class no-undo get. set.
    define protected property IDataAccessType as class Class no-undo get. set.
    define protected property IDataSourceType as class Class no-undo get. set.
    define protected property IServiceProviderType as class Class no-undo get. set.
    define protected property InjectABLServiceProviderType as class Class no-undo get. set.
    define protected property InjectABLComponentProviderType as class Class no-undo get. set.
    
    constructor public BusinessComponentModule (  ):
        super ().
        
        /* do this one per type, for readability and possibly performance too */
        assign IBusinessEntityType = Class:GetClass('OpenEdge.BusinessComponent.Entity.IBusinessEntity')
               BusinessEntityServiceInterfaceType  = Class:GetClass('OpenEdge.BusinessComponent.Entity.ServiceInterface')
               IDataAccessType = Class:GetClass('OpenEdge.DataAccess.IDataAccess')
               IDataSourceType = Class:GetClass('OpenEdge.DataSource.IDataSource')

               IServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider')
               
               IWorkStepType = Class:GetClass('OpenEdge.BusinessComponent.WorkFlow.IWorkStep')
               WorkStepServiceInterfaceType = Class:GetClass('OpenEdge.BusinessComponent.WorkFlow.WorkStepServiceInterface') 
               BizLogicWorkStepType = Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.BizLogicWorkStep')
               
               IBizLogicServerParametersType = Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.IBizLogicServerParameters')

               InjectABLServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider')
               InjectABLComponentProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ComponentProvider').
    end constructor.

    /** BUSINESS WORKFLOWS **/
    method protected void BindBusinessEntity(input pcBindingName as character,
                                             input pcConcreteBEType as character,
                                             input pcDAName as character,
                                             input pcConcreteDAType as character,
                                             input pcDataSourceName as character extent,
                                             input pcDataSourceTableName as character extent,
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
               oArgs[1] = new Parameter(IBusinessEntityType, pcBindingName).
        oBindingSyntax
            :WithConstructorArgument(oArgs).
        
        /* Bind actual Business Entity */
        oBindingSyntax = Bind(IBusinessEntityType).
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
            assign oArgs[1] = new Parameter(pcDataSourceTableName[iLoop])
                   oArgs[2] = new Parameter(IDataSourceType, pcDataSourceName[iLoop]).
            oBindingSyntax
                :WithMethodValue('AddDataSource', oArgs).
            
            /* bind datasources */
            oDataSourceBindingSyntax = Bind(IDataSourceType).
            oDataSourceBindingSyntax
                :Named(pcDataSourceName[iLoop])
                :To(pcConcreteDataSourceType[iLoop])
                :Using(InjectABLComponentProviderType).
        end.
    end method.

    /* Workstep binding to service interface, workstep */
    method protected void BindWorkStep(input pcBindingName as character,
                                       input pcConcreteType as character,
                                       input plIsBizLogicStep as logical  ): 
        
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        define variable oSIArgs as IParameter extent 2 no-undo.
        define variable oBLArgs as IParameter extent 1 no-undo.
        
        /* Use a service interface to bind the service to the workstep */
        oBindingSyntax = Bind(IServiceProviderType).
        oBindingSyntax
            :Named(pcBindingName)
            :To(WorkStepServiceInterfaceType)
            :OnServerSession().
        
        /* parameters for passing into constructor */
        oSIArgs[1] = new Parameter(IWorkStepType, pcBindingName).
        oSIArgs[2] = new Parameter(pcBindingName).
        oBindingSyntax            
            :WithConstructorArgument(oSIArgs).
        
        /* Internal/Standard exposure as IWorkStep */
        oBindingSyntax = Bind(IWorkStepType).
        oBindingSyntax
            :Named(pcBindingName)
            :To(pcConcreteType)
            :Using(InjectABLServiceProviderType).
        
        if plIsBizLogicStep then
        do:
            /* Bizlogic workstep. */
            oBLArgs[1] = new Parameter(IBizLogicServerParametersType).
            oBindingSyntax
                :WithConstructorArgument(oBLArgs).
        end.
        
    end method.

end class.