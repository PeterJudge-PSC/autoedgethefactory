/** ------------------------------------------------------------------------
    File        : UserTableDS
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 22 10:08:26 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataSource.StandardDataSource.
using OpenEdge.DataSource.DataSourceQuery.
using OpenEdge.DataAccess.IDataAccess.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.System.IQuery.
using OpenEdge.Core.System.IQueryDefinition.

using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.String.

class AutoEdge.Factory.Common.Server.BusinessComponents.UserTableDS use-widget-pool inherits StandardDataSource: 
	define override protected property PrimaryTable as handle no-undo 
        get():
            if not valid-handle(PrimaryTable) then
                PrimaryTable = buffer ApplicationUser:handle.
            return PrimaryTable.
        end get.
	set.
	
	constructor public UserTableDS(input poComponentInfo as IComponentInfo):
		super (input poComponentInfo).
	end constructor.
	
	method override protected void CreateDataStore():
        define variable hABLDataSource as handle no-undo.
        define variable oDSQuery as IQuery no-undo.
        
        create data-source hABLDataSource.
        hABLDataSource:add-source-buffer(buffer ApplicationUser:handle, buffer ApplicationUser:keys).
        hABLDataSource:add-source-buffer(buffer Locale:handle, buffer Locale:keys).
        
        oDSQuery = new DataSourceQuery(hABLDataSource).
        oDSQuery:Definition:AddJoin('ApplicationUser', 'LocaleId',
                                    OperatorEnum:IsEqual,
                                    'Locale', 'LocaleId',
                                    JoinEnum:And).
        /* This is the query definition we'll always use. There should not be any user- or request- specific
           filtering/joining in this definition, since we don't know what the lifespan of this datasource object 
           is. The SaveData or FetchData request will be done on the behest of a user and so will add it's own 
           filters (like tenancy) to the query that is used to service the request. */
        oDSQuery:Rebase().
        
        ABLDataSources:Put(ServiceMessageActionEnum:FetchData, oDSQuery).
        
        /* test with multiple tables */
        ABLDataSources:Put(ServiceMessageActionEnum:SaveData, oDSQuery).
        
        /**
        create data-source hABLDataSource.
        hABLDataSource:add-source-buffer(PrimaryTable, PrimaryTable:keys).
        
        oDSQuery = new DataSourceQuery(hABLDataSource).
        oDSQuery:Definition:AddJoin('ApplicationUser', 'LocaleId',
                                    OperatorEnum:IsEqual,
                                    'Locale', 'LocaleId',
                                    JoinEnum:And).
        /* this is the query definition we'll always use */
        oDSQuery:Rebase().
        **/
        
        ABLDataSources:Put(ServiceMessageActionEnum:SaveData, oDSQuery).
        
        super:CreateDataStore().
	end method.

	method override protected void AttachDataStoreToTarget(input poServiceMessageAction as ServiceMessageActionEnum):
        define variable hABLDataSource as handle no-undo.
        
        case poServiceMessageAction:
            when ServiceMessageActionEnum:FetchData or when ServiceMessageActionEnum:SaveData then
            do:
                hABLDataSource = cast(ABLDataSources:Get(poServiceMessageAction), DataSourceQuery):ABLDataSource. 
                hABLDataSource:prefer-dataset = true.
                ConvertTargetToHandle():attach-data-source(
                        hABLDataSource, 'eUserLogin.LocaleName,Locale.Name').
                
                AttachedActions:Add(poServiceMessageAction).
            end.
            otherwise
                super:AttachDataStoreToTarget(poServiceMessageAction).
        end case.
	end method.
	
end class.