/*------------------------------------------------------------------------
    File        : DataSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Feb 11 20:09:22 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataSource.IDataSource.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
using OpenEdge.Core.System.Query.
using OpenEdge.Core.System.IQueryDefinition.

class OpenEdge.DataSource.DataSource inherits Query implements IDataSource: 
    define public property PageSize as integer no-undo get. set.
    
    define protected property BufferHandle as handle no-undo get. set.
    
    define public property FillMode as character no-undo 
        get():
            if FillMode = "" and valid-handle(BufferHandle) then
                return BufferHandle:fill-mode.
            else 
                return FillMode.    
        end. 
        set(cValue as char):
            if valid-handle(BufferHandle) then 
                BufferHandle:fill-mode = cValue.
            FillMode = cValue.            
        end.    
    
    constructor public DataSource (poQueryDefinition as IQueryDefinition,pcMapping as char):
        super (?, input poQueryDefinition).    
    end constructor.
    
    method public void PrepareForFetch(phBuffer as handle):
        PrepareForFetch(phBuffer,?).
    end method.
    
    method public void PrepareForFetch(phBuffer as handle, poRequest as ITableRequest):
        BufferHandle:fill-mode = FillMode.
    end method.
        
    method public ITableContext GetData():
        
    end method.    
    
    @todo(task="figure out signature?"). 
    /*method public void AddCallBack() */  
end class.