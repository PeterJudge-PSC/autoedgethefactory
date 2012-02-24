/** ------------------------------------------------------------------------
    File        : DealerEntity
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 25 14:26:45 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.Entity.StandardBusinessEntity.
using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.

class AutoEdge.Factory.Server.Common.BusinessComponent.DealerEntity inherits StandardBusinessEntity: 
    
    define private temp-table eDealer no-undo
        field DealerId as character
        field Code as character
        field Name as character
        field SalesEmail as character
        field InfoEmail as character
        field StreetAddress as character
        field PhoneNumber as character
        index idx1 as primary unique DealerId
        index idx2 as unique Code.
    
    define private temp-table eSalesrep no-undo
        field DealerId as character
        field Code as character
        field Quota as decimal
        field Region as character
        index idx1 as primary unique DealerId Code.
        .
    
    define dataset dsDealer for eDealer, eSalesrep
	   /*data-relation for eDealer, eSalesrep relation-fields(DealerId, DealerId)*/ .
    
    define override protected property DatasetHandle as handle no-undo
        get():
            if not valid-handle(DatasetHandle) then
               DatasetHandle = dataset dsDealer:handle.
            
            return DatasetHandle.
        end get.
        set.
    
	constructor public DealerEntity(input poComponentInfo as IComponentInfo,
	                                input poDAO as IDataAccess ):
		super(input poComponentInfo, input poDAO).
	end constructor.
	
	constructor public DealerEntity(input poComponentInfo as IComponentInfo):
		super(input poComponentInfo).
	end constructor.
	
    method protected void BindReceivedDataset( input dataset dsDealer bind):
        /* no body needed. the parameter passing does what we need. */
    end method.

    method override protected void ReceiveDataset(input phDataset as handle):
        BindReceivedDataset(dataset-handle phDataset).
    end method.
    
end class.