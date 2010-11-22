/*------------------------------------------------------------------------
    File        : EmployeeDS
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 15 09:20:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataSource.StandardDataSource.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.DataAccess.IDataAccess.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.Query.
using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.

using OpenEdge.Core.System.InvalidValueSpecifiedError.

class OpenEdge.Test.Roundtrip1.BusinessComponents.EmployeeDS use-widget-pool inherits StandardDataSource:
     
    define private property EmployeeBuffer as handle no-undo
        get():
            if not valid-handle(EmployeeBuffer) then
                EmployeeBuffer = buffer Employee:handle.
            return EmployeeBuffer.
        end get.
        set.
    
	constructor public EmployeeDS (  ):
		super ().
	end constructor.
	
    /** Prepare with query, batchsize and more.
        
        @param ITableRequest Parameters for the fetch (query modifications, page size etc).
        @param IDataAccess The DataAccess object making this request. The DAO can be used to
               resolve table- or field name mappings (from the Business Entity names to the 
               Data Source names.           */
    method override public void Prepare(input poAction as ServiceMessageActionEnum,
                                        input poRequest as ITableRequest,
                                        input poDAO as IDataAccess ):
        define variable oQD as IQueryDefinition no-undo.
        define variable oRequestQD as IQueryDefinition no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable cRequestBuffers as character extent no-undo.
        
        super:Prepare(poAction, poRequest, poDAO).
        
        case poAction:
            when ServiceMessageActionEnum:Fetch then
            do:        
                oRequestQD = cast(poRequest, IQueryDefinition).
                /*
                message this-object this-object:GetClass():TypeName program-name(1) program-name(2) skip(2)
                    oRequestQD:GetQueryString() skip
                    'DataSourceHandle=' DataSourceHandle
                view-as alert-box error title '[PJ DEBUG]'.
                */                                  
            end.
        end case.
                
        /**
        /* Here we transform the query on the ITableRequest and map from (say)
                eSalesrep.QuoteJanuary to sports2000.SalesRep.MonthQuota[1] */
        CurrentQuery = new Query(this-object, oRequestQD).
        
        /*CurrentQuery:Prepare(). */        
        iMax = oRequestQD:NumBuffers.
        
        cRequestBuffers = oRequestQD:GetBufferList().
        do iLoop = 1 to iMax:
            oRequestQD:SetBufferTable(cRequestBuffers[iLoop],
                                      poDAO:ResolveTableName(cRequestBuffers[iLoop])).
        end.                                  
        
        /*output cRequestTables,output oRequestQueryTypes,output oRequestLockModes).
        
        oQD = new QueryDefinition().
        do iLoop = 1 to iMax:
            oQD:AddBuffer(cRequestBuffers[iloop],
                          cRequestTables[iloop],
                          oRequestQueryTypes[iLoop],
                          oRequestLockModes[iLoop]).
        end.
        */	
        **/
	end method.
	
	method override public handle GetTableHandle( input pcTableName as character ):
        if pcTableName ne 'Employee' then
            undo, throw new InvalidValueSpecifiedError('table',': must be "Employee"').
        
		return EmployeeBuffer.
	end method.

	method override protected void CreateDataStore(  ):
 	  create data-source DataSourceHandle.
 	  
 	  DataSourceHandle:add-source-buffer(EmployeeBuffer, EmployeeBuffer:keys).	
	end method.

	method override protected void DeleteDataStore(  ):
	    delete object DataSourceHandle no-error.
	end method.

	method override protected void AttachDataStoreToTarget(  ):
        DataSourceHandle:prefer-dataset = true.
        ConvertTargetToHandle():attach-data-source(DataSourceHandle).
        DataSourceAttached = true.
	end method.

	method override protected void DetachDataStoreFromTarget():
	    if DataSourceAttached then	    
	       ConvertTargetToHandle():detach-data-source().
        DataSourceAttached = false.
	end method.

end class.