/** ------------------------------------------------------------------------
    File        : FactoryModule
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 16:15:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.

using Progress.Lang.Class.

class AutoEdge.Factory.InjectABL.FactoryModule inherits InjectionModule: 
    
    define private variable moIWorkStepType as class Class no-undo.
    define private variable moWorkStepServiceInterfaceType as class Class no-undo.
    define private variable moBizLogicWorkStepType as class Class no-undo.
    define private variable moIBizLogicServerParametersType as class Class no-undo.
    define private variable moIBusinessEntityType as class Class no-undo.
    define private variable moBusinessEntityServiceInterfaceType as class Class no-undo.
    define private variable moIDataAccessType as class Class no-undo.
    define private variable moIDataSourceType as class Class no-undo.
    define private variable moIServiceProviderType as class Class no-undo.
    define private variable moIServiceManagerType as class Class no-undo.
    define private variable moInjectABLServiceProviderType as class Class no-undo.
		
	constructor public FactoryModule (  ):
		super ().
		
        /* do this one per type, for readability and possibly performance too */
        assign moIBusinessEntityType = Class:GetClass('OpenEdge.BusinessComponent.Entity.IBusinessEntity')
               moBusinessEntityServiceInterfaceType  = Class:GetClass('OpenEdge.BusinessComponent.Entity.ServiceInterface')
               moIDataAccessType = Class:GetClass('OpenEdge.DataAccess.IDataAccess')
               moIDataSourceType = Class:GetClass('OpenEdge.DataSource.IDataSource')

               moIServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider')
               moIServiceManagerType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager')
               
               moIWorkStepType = Class:GetClass('OpenEdge.BusinessComponent.WorkFlow.IWorkStep')
               moWorkStepServiceInterfaceType = Class:GetClass('OpenEdge.BusinessComponent.WorkFlow.WorkStepServiceInterface') 
               moBizLogicWorkStepType = Class:GetClass('OpenEdge.BusinessComponent.WorkFlow.BizLogic.BizLogicWorkStep')
               
               moIBizLogicServerParametersType = Class:GetClass('OpenEdge.BusinessComponent.WorkFlow.BizLogic.IBizLogicServerParameters')
               
               moInjectABLServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider').
        
	end constructor.

    /** BUSINESS WORKFLOWS **/
    method public void LoadWorkflows():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        define variable oArgs as IParameter extent no-undo.

        /* binding for webservices exposure */
        oBindingSyntax = Bind(moIServiceProviderType).
        oBindingSyntax
            :Named("BuildVehicle")
            :To("AutoEdge.Factory.Build.StandardBuild")
            :WithConstructorArgument(oArgs)
            :Using(moInjectABLServiceProviderType).
        
        /* internal binding (for sub-IWorkFlow exposure) */
        oBindingSyntax = Bind(moIWorkStepType).
        oBindingSyntax
            :Named("BuildVehicle")
            :To("AutoEdge.Factory.Build.StandardBuild")
            :WithConstructorArgument(oArgs)
            :Using(moInjectABLServiceProviderType). 
        
        /** BUSINESS WORKSTEPS **/
        /*BindWorkStep(workstepname, concrete type, is bizlogic step)*/
        BindWorkStep("BuildVehicle::ProcessComponents", "AutoEdge.Factory.Build.ProcessComponents", false).
        BindWorkStep("BuildVehicle::AssembleChassis", "AutoEdge.Factory.Build.AssembleChassis", false).
        BindWorkStep("BuildVehicle::AssembleBody", "AutoEdge.Factory.Build.AssembleBody", false).
        BindWorkStep("BuildVehicle::PaintVehicle", "AutoEdge.Factory.Build.PaintVehicle", false).
        BindWorkStep("BuildVehicle::AssembleInterior", "AutoEdge.Factory.Build.AssembleInterior", false).
        BindWorkStep("BuildVehicle::MateAssembledComponents", "AutoEdge.Factory.Build.MateAssembledComponents", false).
        BindWorkStep("BuildVehicle::CompleteVehicleBuild", "AutoEdge.Factory.Build.CompleteVehicleBuild", true).
    end method.
    
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
        define variable oArgs as IParameter extent 2 no-undo.
        
        /* bind as a service interface */
        oBindingSyntax = Bind(moIServiceProviderType).
        oBindingSyntax
            :Named(pcBindingName)
            :To(moBusinessEntityServiceInterfaceType).
        
        assign oArgs[1] = new Parameter(moIBusinessEntityType, pcBindingName)
               oArgs[2] = new Parameter(pcBindingName).
        oBindingSyntax
            :WithConstructorArgument(oArgs).
        
        /* Bind actual Business Entity */
        oBindingSyntax = Bind(moIBusinessEntityType).
        oBindingSyntax
            :Named(pcBindingName)
            :To(pcConcreteBEType).
        
        oBindingSyntax
            :WithConstructorArgument(moIDataAccessType, pcDAName)
            :Using(moInjectABLServiceProviderType)
            :InAgentRequestScope().
        
        /* bind data access */
        oBindingSyntax = Bind(moIDataAccessType).
        oBindingSyntax
            :Named(pcDAName)
            :To(pcConcreteDAType).
        
        iMax = extent(pcDataSourceName).
        do iLoop = 1 to iMax:
            /* Add datasource to dataaccess binding. use this one loop
               for efficiency's sake */
            assign oArgs[1] = new Parameter(pcDataSourceTableName[iLoop])
                   oArgs[2] = new Parameter(moIDataSourceType, pcDataSourceName[iLoop]).
            oBindingSyntax
                :WithMethodValue('AddDataSource', oArgs).
            
            /* bind datasources */
            oDataSourceBindingSyntax = Bind(moIDataSourceType).
            oDataSourceBindingSyntax
                :Named(pcDataSourceName[iLoop])
                :To(pcConcreteDataSourceType[iLoop]).
        end.

    end method.

    method protected void LoadEntities():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        define variable oArgs as IParameter extent no-undo.
        define variable cBindingName as character no-undo.

        define variable cDSName as character extent no-undo.
        define variable cConcreteDS as character extent no-undo.
        define variable cDSTableName as character extent no-undo.                

        assign extent(cDSName) = 1
               extent(cConcreteDS) = 1
               extent(cDSTableName) = 1
               
               cDSName[1] = 'OrderDataSource'
               cConcreteDS[1] = 'AutoEdge.Factory.Order.OrderTableDS'
               cDSTableName[1] = 'Order'
               .
               
        BindBusinessEntity(
            'OrderUpdate', 'AutoEdge.Factory.Order.OrderUpdateBE',
            'OrderDA', 'AutoEdge.Factory.Order.OrderDA',
            cDSName, cDSTableName, cConcreteDS).
    end method.
    
	method override public void Load(  ):
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        define variable oArgs as IParameter extent no-undo.
        
        LoadWorkflows().
        LoadEntities().

        /* other */
        /* savvion parameters */        
        oBindingSyntax = Bind(moIBizLogicServerParametersType).
        oBindingSyntax
            :To('AutoEdge.Factory.Build.SavvionParameters').
	end method.
	
    /* Workstep binding to service interface, workstep */
    method protected void BindWorkStep(input pcBindingName as character,
                                       input pcConcreteType as character,
                                       input plIsBizLogicStep as logical     ):
        
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        define variable oSIArgs as IParameter extent 2 no-undo.
        define variable oBLArgs as IParameter extent 1 no-undo.
        
        /* Use a service interface to bind the service to the workstep */
        oBindingSyntax = Bind(moIServiceProviderType).
        oBindingSyntax
            :Named(pcBindingName)
            :To(moWorkStepServiceInterfaceType).
        
        /* parameters for passing into constructor */
        oSIArgs[1] = new Parameter(moIWorkStepType, pcBindingName).
        oSIArgs[2] = new Parameter(pcBindingName).
        oBindingSyntax            
            :WithConstructorArgument(oSIArgs).
        
        /* Internal/Standard exposure as IWorkStep */
        oBindingSyntax = Bind(moIWorkStepType).
        oBindingSyntax
            :Named(pcBindingName)
            :To(pcConcreteType)
            :Using(moInjectABLServiceProviderType).

        if plIsBizLogicStep then
        do:
            /* Bizlogic workstep. */
            oBLArgs[1] = new Parameter(moIBizLogicServerParametersType).
            oBindingSyntax
                :WithConstructorArgument(oBLArgs).
        end.
    end method.

end class.