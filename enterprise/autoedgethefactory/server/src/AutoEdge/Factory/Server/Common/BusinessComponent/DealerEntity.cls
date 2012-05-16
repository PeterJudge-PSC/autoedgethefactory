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

using AutoEdge.Factory.Server.Common.BusinessComponent.IDealerEntity.
using OpenEdge.BusinessComponent.Entity.StandardBusinessEntity.
using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.

class AutoEdge.Factory.Server.Common.BusinessComponent.DealerEntity inherits StandardBusinessEntity
        implements IDealerEntity: 
    
    define private temp-table eDealer no-undo before-table eDealerBefore
        field DealerId as character
        field Code as character
        field Name as character
        field SalesEmail as character
        field InfoEmail as character
        field StreetAddress as character
        field PhoneNumber as character
        index idx1 as primary unique DealerId
        index idx2 as unique Code.
    
    define private temp-table eSalesrep no-undo before-table eSalesrepBefore
        field DealerId as character
        field Code as character
        field Quota as decimal
        field Region as character
        index idx1 as primary unique DealerId Code.
        .
    
    define dataset dsDealer for eDealer, eSalesrep
	   data-relation for eDealer, eSalesrep relation-fields(DealerId, DealerId).
    
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
    
    method public void GetDealerDetail (input pcDealerCode as character,
                                        output pcName as character,
                                        output pcSalesEmail as character,
                                        output pcInfoEmail as character,
                                        output pcStreetAddress as character,
                                        output pcPhoneNumber as character,
                                        output pcSalesRep as character extent):
        define variable oFetchRequest as IFetchRequest no-undo.
        define variable cTableName as character no-undo.
        define variable oTableRequest as ITableRequest no-undo.
        define query qrySalesrep for eSalesrep.

        oFetchRequest = new FetchRequest('Dealer').

        cTableName = 'eDealer'.
        oTableRequest = new TableRequest(cTableName).
        oTableRequest:TableRequestType = TableRequestTypeEnum:NoChildren.
        oFetchRequest:TableRequests:Put(cTableName, oTableRequest).
        
        oTableRequest:AddFilter(cTableName,
                                'Code',
                                OperatorEnum:IsEqual,
                                new String(pcDealerCode),
                                DataTypeEnum:Character,
                                JoinEnum:And).
        
        FetchData(oFetchRequest).
        
        find eDealer where 
             eDealer.Code eq pcDealerCode
             no-error.
        Assert:ArgumentIsAvailable(buffer eDealer:handle, 'Dealer').
        
        assign pcName = eDealer.Name
               pcSalesEmail = eDealer.SalesEmail
               pcInfoEmail = eDealer.InfoEmail
               pcStreetAddress = eDealer.StreetAddress
               pcPhoneNumber = eDealer.PhoneNumber.

        open query qrySalesrep 
            preselect each eSalesrep where eSalesrep.DealerId eq eDealer.DealerId.
        
        extent(pcSalesRep) = query qrySalesrep:num-results.
        
        query qrySalesrep:get-first().
        do while available eSalesrep:
            pcSalesRep[query qrySalesrep:current-result-row] = eSalesrep.Code.
            query qrySalesrep:get-next().
        end.
        close query qrySalesrep.
    end method.
    
end class.