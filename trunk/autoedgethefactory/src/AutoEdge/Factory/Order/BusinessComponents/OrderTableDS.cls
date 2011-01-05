/** ------------------------------------------------------------------------
    File        : OrderTableDS
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 08 16:23:04 EST 2010
    Notes       : 
  ----------------------------------------------------------------- ---- */
routine-level on error undo, throw.

using OpenEdge.DataSource.StandardDataSource.
using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.

using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.QueryFilter.

using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.String.

class AutoEdge.Factory.Order.BusinessComponents.OrderTableDS use-widget-pool inherits StandardDataSource: 
    
    define override protected property PrimaryTable as handle no-undo
        get():
            if not valid-handle(PrimaryTable) then
                PrimaryTable = buffer Order:handle.
            return PrimaryTable.
        end get.
        set.
    
	constructor public OrderTableDS ( input poComponentInfo as OpenEdge.CommonInfrastructure.Common.IComponentInfo ):
		super (input poComponentInfo).
	end constructor.
    
    method override protected void AttachDataStoreToTarget(input poServiceMessageAction as ServiceMessageActionEnum):
        define variable hABLDataSource as handle no-undo.
        
        case poServiceMessageAction:
            when ServiceMessageActionEnum:FetchData then
            do:
                hABLDataSource = cast(ABLDataSources:Get(poServiceMessageAction), String):ToHandle(). 
                hABLDataSource:prefer-dataset = true.
                ConvertTargetToHandle():attach-data-source(hABLDataSource,
                    'eUserLogin.LocaleName,Locale.Name').
                
                AttachedActions:Add(poServiceMessageAction).
            end.
            otherwise super:AttachDataStoreToTarget(poServiceMessageAction).
        end case.
    end method.
	
end class.