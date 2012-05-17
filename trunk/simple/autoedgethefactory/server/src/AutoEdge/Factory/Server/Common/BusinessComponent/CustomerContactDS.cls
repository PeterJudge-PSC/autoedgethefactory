/** ------------------------------------------------------------------------
    File        : CustomerContactDS
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Jun 16 11:16:51 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataSource.StandardDataSource.
using OpenEdge.DataSource.DataSourceQuery.

using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Core.System.IQuery.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.String.

class AutoEdge.Factory.Server.Common.BusinessComponent.CustomerContactDS inherits StandardDataSource: 
    
    define override protected property PrimaryTable as handle no-undo
        get():
            if not valid-handle(PrimaryTable) then
                create buffer PrimaryTable for table buffer ContactDetail:handle.
            
            return PrimaryTable.
        end get.
        set.
    
	constructor public CustomerContactDS(input poComponentInfo as IComponentInfo):
		super (input poComponentInfo).
	end constructor.

    method override protected void CreateDataStore():
        define variable hABLDataSource as handle no-undo.
        define variable oDSQuery as IQuery no-undo.
        define variable hXrefBuffer as handle no-undo.
        define variable hDetailBuffer as handle no-undo.
        define variable hTypeBuffer as handle no-undo.
        define variable hParentBuffer as handle no-undo.

        create data-source hABLDataSource.
        oDSQuery = new DataSourceQuery(hABLDataSource).
        ABLDataSources:Put(ServiceMessageActionEnum:FetchData, oDSQuery).
        
    /** FETCH **/        
        /* Make sure we have a uniquely-named buffer, for those cases where this datasource object's instances' 
           lifecycles overlap. The ABL requires only a single named buffer/data-source set at a time. */
        create buffer hXrefBuffer for table buffer CustomerContact:handle
            buffer-name substitute('CustomerContact_&1-&2',
                         string(hABLDataSource),
                         string(int(ServiceMessageActionEnum:FetchData))).
        hABLDataSource:add-source-buffer(hXrefBuffer, hXrefBuffer:keys).
        
        create buffer hDetailBuffer for table buffer ContactDetail:handle
            buffer-name substitute('ContactDetail_&1-&2',
                         string(hABLDataSource),
                         string(int(ServiceMessageActionEnum:FetchData))).

        hABLDataSource:add-source-buffer(hDetailBuffer, hDetailBuffer:keys).
        oDSQuery:Definition:AddJoin(hXrefBuffer:name, 'ContactDetailId',
                                    OperatorEnum:IsEqual,
                                    hDetailBuffer:name, 'ContactDetailId',
                                    JoinEnum:And).

        create buffer hTypeBuffer for table buffer ContactType:handle
            buffer-name substitute('ContactType_&1-&2',
                         string(hABLDataSource),
                         string(int(ServiceMessageActionEnum:FetchData))).

        hABLDataSource:add-source-buffer(hTypeBuffer, hTypeBuffer:keys).
        oDSQuery:Definition:AddJoin(hXrefBuffer:name, 'ContactType',
                                    OperatorEnum:IsEqual,
                                    hTypeBuffer:name, 'Name',
                                    JoinEnum:And).
        
        create buffer hParentBuffer for table buffer Customer:handle
            buffer-name substitute('Customer_&1-&2',
                         string(hABLDataSource),
                         string(int(ServiceMessageActionEnum:FetchData))).

        hABLDataSource:add-source-buffer(hParentBuffer, hParentBuffer:keys).
        oDSQuery:Definition:AddJoin(hXrefBuffer:name, 'CustomerId',
                                    OperatorEnum:IsEqual,
                                    hParentBuffer:name, 'CustomerId',
                                    JoinEnum:And).
        
        /* We're ready to parse the ABLDatasource and construct the query definition.
           
           This is the query definition we'll always use. There should not be any user- or request- specific
           filtering/joining in this definition, since we don't know what the lifespan of this datasource object 
           is. The SaveData or FetchData request will be done on the behest of a user and so will add it's own 
           filters (like tenancy) to the query that is used to service the request. */
        cast(oDSQuery, DataSourceQuery):Initialize().
        
    /** SAVE **/
        /* The save mapping differs from the fetch, since we are potentially saving to 2 tables (not 3). */
        create data-source hABLDataSource.
        oDSQuery = new DataSourceQuery(hABLDataSource).
        ABLDataSources:Put(ServiceMessageActionEnum:SaveData, oDSQuery).
        
        /* Make sure we have a uniquely-named buffer, for those cases where this datasource object's instances' 
           lifecycles overlap. The ABL requires only a single named buffer/data-source set at a time. */
        create buffer hXrefBuffer for table buffer CustomerContact:handle
            buffer-name substitute('CustomerContact_&1-&2',
                         string(hABLDataSource),
                         string(int(ServiceMessageActionEnum:SaveData))).
        hABLDataSource:add-source-buffer(hXrefBuffer, hXrefBuffer:keys).
        
        create buffer hDetailBuffer for table buffer ContactDetail:handle
            buffer-name substitute('ContactDetail_&1-&2',
                         string(hABLDataSource),
                         string(int(ServiceMessageActionEnum:FetchData))).

        hABLDataSource:add-source-buffer(hDetailBuffer, hDetailBuffer:keys).
        oDSQuery:Definition:AddJoin(hXrefBuffer:name, 'ContactDetailId',
                                    OperatorEnum:IsEqual,
                                    hDetailBuffer:name, 'ContactDetailId',
                                    JoinEnum:And).

        /* We're ready to parse the ABLDatasource and construct the query definition.
           
           This is the query definition we'll always use. There should not be any user- or request- specific
           filtering/joining in this definition, since we don't know what the lifespan of this datasource object 
           is. The SaveData or FetchData request will be done on the behest of a user and so will add it's own 
           filters (like tenancy) to the query that is used to service the request. */
        cast(oDSQuery, DataSourceQuery):Initialize().        
        
        super:CreateDataStore().
    end method.
    
    method override protected void AttachDataStoreToTarget(input poAction as ServiceMessageActionEnum):
        define variable oDSQuery as DataSourceQuery no-undo.
        define variable hABLDataSource as handle no-undo.
        define variable hDetailBuffer as handle no-undo.
        define variable hTypeBuffer as handle no-undo.
        define variable cPairsList as character no-undo.
        
        case poAction:
            when ServiceMessageActionEnum:SaveData then
            do:
                oDSQuery = cast(ABLDataSources:Get(poAction), DataSourceQuery).
                hDetailBuffer = oDSQuery:GetTableBuffer('ContactDetail').
                cPairsList = '&1.ContactDetail,&2.Detail'.
                
                hABLDataSource = oDSQuery:ABLDataSource.
                hABLDataSource:prefer-dataset = true.
                this-object:TargetBuffer:attach-data-source(hABLDataSource,
                            substitute(cPairsList,
                                       TargetBuffer:name,
                                       hDetailBuffer:name)).
                AttachedActions:Add(poAction).
            end.
            when ServiceMessageActionEnum:FetchData then            
            do:
                oDSQuery = cast(ABLDataSources:Get(poAction), DataSourceQuery).
                hDetailBuffer = oDSQuery:GetTableBuffer('ContactDetail').
                hTypeBuffer = oDSQuery:GetTableBuffer('ContactType').
                cPairsList = '&1.ContactType,&2.Name'
                           + ',&1.ContactDetail,&3.Detail'.
                
                hABLDataSource = oDSQuery:ABLDataSource.
                hABLDataSource:prefer-dataset = true.
                this-object:TargetBuffer:attach-data-source(hABLDataSource,
                            substitute(cPairsList,
                                       TargetBuffer:name,
                                       hTypeBuffer:name,
                                       hDetailBuffer:name)).
                AttachedActions:Add(poAction).
            end.
            otherwise
                /* on save we're just updating the Customer table */
                super:AttachDataStoreToTarget(poAction).
        end case.
    end method.    
    
    method override protected void AddRow(input phABLDatasource as handle,
                                          input piBufferIndex as integer,
                                          input poDataSourceQuery as DataSourceQuery,
                                          input phSourceBuffer as handle):
		define variable hDbBuffer as handle no-undo.
        define buffer lbDetail for ContactDetail.
		
		hDbBuffer = phABLDatasource:get-source-buffer(piBufferIndex).
		
		case hDbBuffer:table:
		    when 'ContactDetail' then
		    do:
            	/* If the detail record already exists, then don't add a new one. */
                find first lbDetail where
                           lbDetail.Detail eq phSourceBuffer:after-buffer::ContactDetail
                           no-lock no-error.
                if not available lbDetail then
                    super:AddRow(input phABLDatasource, input piBufferIndex, input poDataSourceQuery, input phSourceBuffer).
            end.
		    otherwise
		        super:AddRow(input phABLDatasource, input piBufferIndex, input poDataSourceQuery, input phSourceBuffer).
	    end case.
	end method.
	
    /** Add any primary key values that aren't in the source dataset/temp-table
        
        @param handle The DB buffer being operated on        
        @param handle The source (typically before-image) buffer handle. */
    method override protected void AddPrimaryKeys(input phDbBuffer as handle,
                                                  input phSourceBuffer as handle):
        define buffer lbCustomer for Customer.
        
        super:AddPrimaryKeys(phDbBuffer, phSourceBuffer).
        
        case phDbBuffer:table:
            when 'ContactDetail' then phDbBuffer::ContactDetailId = GetNextOpaqueId(phDbBuffer:name).
        end case.
    end method.
    
end class.