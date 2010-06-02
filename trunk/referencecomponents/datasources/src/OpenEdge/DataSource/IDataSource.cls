
/*------------------------------------------------------------------------
    File        : IDataSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Wed Feb 10 01:30:45 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
 
interface OpenEdge.DataSource.IDataSource: /* implements IQuery */ 
    define property PageSize as integer no-undo get. set.
    define property FillMode as character no-undo get. set.
     /* simple default prepare */
    method public void PrepareForFetch(phBuffer as handle).
    /* prepare with query, batchsize and more.. */
    method public void PrepareForFetch(phBuffer as handle, poRequest as ITableRequest).
    method public ITableContext GetData().
    
    @todo(task="figure out signature").
    /* method public void AddCallBack() */  
end interface.