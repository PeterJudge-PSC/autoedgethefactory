/** ------------------------------------------------------------------------
    File        : RegisterCustomerTask
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jun 17 11:54:19 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using AutoEdge.Factory.Server.Common.BusinessComponent.IRegisterCustomerTask.
using AutoEdge.Factory.Server.Common.BusinessComponent.ICustomerEntity.
using AutoEdge.Factory.Server.Common.BusinessComponent.IUserLoginEntity.

using AutoEdge.Factory.Common.CommonInfrastructure.UserTypeEnum.

using OpenEdge.BusinessComponent.Entity.IBusinessEntity.
/*using OpenEdge.BusinessComponent.Entity.DataContainerEntity.*/
using OpenEdge.BusinessComponent.Task.BusinessTask.
/*using OpenEdge.BusinessComponent.Task.TaskParameter.*/

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.TaskResponse.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

/*using OpenEdge.Core.DataContainer.IDataContainer.     */
/*using OpenEdge.Core.DataContainer.IDataContainerQuery.*/
using OpenEdge.Core.System.IQuery.
using OpenEdge.Core.Util.ISerializable.

using OpenEdge.Lang.IOModeEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.Collections.IList.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.String.
using Progress.Lang.Object.


class AutoEdge.Factory.Server.Common.BusinessComponent.RegisterCustomerTask inherits BusinessTask
        implements IRegisterCustomerTask:
    
	constructor public RegisterCustomerTask(input poComponentInfo as IComponentInfo, input poEntities as IBusinessEntity extent):
		super (input poComponentInfo, input poEntities).
	end constructor.
		
	constructor public RegisterCustomerTask(input poComponentInfo as IComponentInfo, input poEntities as IList):
		super (input poComponentInfo, input poEntities).
	end constructor.
		
	constructor public RegisterCustomerTask( input poComponentInfo as IComponentInfo):
		super (input poComponentInfo).
	end constructor.
	
    method override public ITaskResponse PerformTask( input poRequest as ITaskRequest):
	end method.

    /** Register a customer.
    
        This method currently uses output parameters; the inputs and outputs could be
        generalised but we choose not to do this here, for clarity.
        
        
        @param character The customer name
        @param character The user name
        @param character The password
        @param character The email address
        @param character The customer's dealer code
        @param integer-output The customer num
        @param character-output The salesrep for this customer. */
    method public void RegisterCustomer(input pcCustomerName as character,
                                        input pcUserName as character,
                                        input pcPassword as character,
                                        input pcCustomerEmail as character,
                                        input pcDealerCode as character,
                                        output piCustNum as integer,
                                        output pcSalesRep as character):
                                            
        define variable oCustomerEntity as ICustomerEntity no-undo.
        define variable oUserLoginEntity as IUserLoginEntity no-undo.
        define variable iCustNum as integer no-undo.
        define variable cName as character no-undo.
        define variable cPassword as character no-undo.
        define variable cEmailAddress as character no-undo.
        define variable cSalesRep as character no-undo.
        
        oCustomerEntity = cast(BusinessEntities:Get(1), ICustomerEntity).
        oUserLoginEntity = cast(BusinessEntities:Get(2), IUserLoginEntity).

        /* build save request and commit data for the user login record */
        piCustNum = oCustomerEntity:RegisterCustomer(pcCustomerName, pcCustomerEmail, pcDealerCode).
        pcSalesRep = oCustomerEntity:GetCustomerSalesrep(piCustNum).

        oUserLoginEntity:RegisterCustomer(pcUserName, pcPassword, piCustNum).
    end method.
	
end class.