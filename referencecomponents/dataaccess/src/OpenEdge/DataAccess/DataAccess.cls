/*------------------------------------------------------------------------
    File        : DataAccess
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Wed Feb 10 03:01:11 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAccess.IDataAccess.
using OpenEdge.DataSource.IDataSource.
using OpenEdge.DataSource.DataSource.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetFetchResponse.

using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.
using Progress.Lang.*.

class OpenEdge.DataAccess.DataAccess implements IDataAccess: 
    
    define protected property DatasetHandle as handle no-undo get. set.
           
       /* private - sub classes should not have access to the TT. 
          There is protected methods for DataSource access
         (the use of TT is "preliminary" and there could easily be 100s of subclasses) */
       define private temp-table ttDataSource no-undo
        field TempTableName   as character
        field Instance as Object          /* OpenEdge.DataSource.DataSource */
        index idx1 as primary unique TempTableName
        .
       
    constructor public DataAccess (  ):
        super ().
    end constructor.
    
    method public void Create():
        StartDataSources().
    end method.  
      
    method protected void StartDataSources():
    end method.         
    
    method protected IDataSource CreateDataSource(pcTTName as char, pcTable as character):
        return this-object:CreateDataSource(pcTTName,pcTable,"").
    end method.
    
    method protected IDataSource CreateDataSource(pcTTName as char, pcTable as character,pcMap as char):
        define variable cTable as character extent 1 no-undo.
        cTable[1] = pcTable.
        return this-object:CreateDataSource(pcTTName,cTable[1],pcMap).
    end method.
    
    method protected IDataSource CreateDataSource(pcTTName as char, pcTables as character extent):
        return this-object:CreateDataSource(pcTTName,pcTables,"").
    end method.
    
    method protected IDataSource CreateDataSource(pcTTName as char, pcTables as character extent, pcMap as char):
        define variable oDef as IQueryDefinition no-undo.
        oDef = new QueryDefinition().   
        
        @todo(task="add tables to the default QueryDefintion"). 
        
        return this-object:CreateDataSource(pcTTName,oDef,pcMap).
    end method.
    
    method protected IDataSource CreateDataSource(pcTTName as char, poQueryDefinition as IQueryDefinition, pcMap as char ):
        define variable oDataSource as IDataSource no-undo. 
        oDataSource = new DataSource(poQueryDefinition,pcMap). 
        RegisterDataSource(pcTTName,oDataSource). 
        return oDataSource.
    end method.
    
    method protected IDataSource GetDataSource(pcTTName as char):       
        find ttDataSource where ttDataSource.TempTableName = pcTTName no-error.
        if avail ttDataSource then 
            return cast(ttDataSource.Instance,IDataSource).
        return ?.
    end method.
    
    method protected void RegisterDataSource(pcTTName as char, poSource as IDataSource):
        /* buffer... really not needed. only access is here and GetDataSource */
        create ttDataSource.
        assign 
            ttDataSource.TempTableName = pcTTName
            ttDataSource.Instance = poSource.
    end method.
    
    method public void FetchData(poRequest as IFetchRequest):
        define variable i       as integer no-undo.
        define variable hBuffer as handle no-undo.
        define variable oTableRequest as ITableRequest no-undo.
        define variable oDataSource as IDataSource no-undo.
        DatasetHandle = cast(poRequest,IDatasetFetchRequest):Handle.
        do i = 1 to DatasetHandle:num-buffers:           
            hBuffer = DatasetHandle:get-buffer-handle(i). 
            hBuffer:fill-mode = "NO-FILL".
            if poRequest:TableRequests:Size > 0 then
                oTableRequest = poRequest:GetTableRequest(hBuffer:name). 
             /* no tableRequests = all tables */        
            if valid-object(oTableRequest) or poRequest:TableRequests:Size = 0 then
            do:
                oDataSource = GetDataSource(hBuffer:name).
                    
                if valid-object(oDataSource) then
                do:
                    oDataSource:FillMode = "APPEND".
                    oDataSource:PrepareForFetch(hBuffer,oTableRequest).
                end.    
            end.   
         end.   
        FillData().  
    end method.
    
    method protected void FillData( ):
         DatasetHandle:fill().  
    end method.
    
    method public IFetchResponse GetData(  ):
    end method.
    
    method public ISaveResponse SaveData(poChanges as ISaveRequest ):        
    end method.

end class.