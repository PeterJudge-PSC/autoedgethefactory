/*------------------------------------------------------------------------
    File        : ComponentItemTableDS
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Mar 02 08:49:27 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataSource.StandardDataSource.
using OpenEdge.DataSource.DataSourceQuery.
using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Core.System.IQuery.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.OperatorEnum.

class AutoEdge.Factory.Server.Order.BusinessComponent.ComponentItemTableDS inherits StandardDataSource: 
    
    define override protected property PrimaryTable as handle no-undo
        get():
            if not valid-handle(PrimaryTable) then
                create buffer PrimaryTable for table buffer Component:handle.
            
            return PrimaryTable.
        end get.
        set.
    
    constructor public ComponentItemTableDS(input poComponentInfo as IComponentInfo ):
        super (input poComponentInfo).
    end constructor.
    
    method override protected void AttachDataStoreToTarget(input poAction as ServiceMessageActionEnum):
        define variable hABLDataSource as handle no-undo.
        define variable hComponentItemBuffer as handle no-undo.
        define variable oDSQuery as DataSourceQuery no-undo.
        define variable cPairsList as character no-undo.
        
        case poAction:
            when ServiceMessageActionEnum:FetchData then
            do:
                assign oDSQuery = cast(ABLDataSources:Get(poAction), DataSourceQuery)
                       hABLDataSource = oDSQuery:ABLDataSource
                       hABLDataSource:prefer-dataset = true
                       hComponentItemBuffer = oDSQuery:GetTableBuffer('ComponentItem').
                cPairsList  = '&1.Quantity,&2.Qty'.
                TargetBuffer:attach-data-source(hABLDataSource,
                                substitute(cPairsList,
                                           TargetBuffer:name,
                                           hComponentItemBuffer:name)).
                AttachedActions:Add(poAction).
            end.
            otherwise
                super:AttachDataStoreToTarget(poAction).
        end case.
    end method.    
    
end class.