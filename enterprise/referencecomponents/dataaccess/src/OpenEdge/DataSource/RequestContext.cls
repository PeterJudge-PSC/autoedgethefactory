/*------------------------------------------------------------------------
    File        : RequestContext
    Purpose     : Context for the DataSource a request (this is a simple parameter/value
                  object) 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 09 13:58:23 EST 2012
    Notes       : * this is not the request itself: this is a short-lived construct
                    that is only around for the lifetime of the Fetch or Save
                    request, and that is contained within a DataSource's request.
  ----------------------------------------------------------------------*/
using OpenEdge.DataSource.IDataSource.
using OpenEdge.DataAccess.IDataAccess.
using OpenEdge.DataSource.DataSourceQuery.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Core.System.IQuery.
using OpenEdge.Lang.Assert.

class OpenEdge.DataSource.RequestContext:
    
    /** (mandatory) The DataAccess object making the request. */
    define public property DataAccessObject as IDataAccess no-undo get. private set.

    /** (mandatory) The DataSource object servicing making the request. */
    define public property DataSourceObject as IDataSource no-undo get. private set.
    
    /** The table response object that's being processed. */
    define public property TableResponse as ITableResponse no-undo get. set.

    /** The type of request underway making the current request. */ 
    define public property ActionType as ServiceMessageActionEnum no-undo get. set.
    
    /** A table request defines a query; this property holds that query for this request. */
    define public property RequestQuery as IQuery no-undo get. set.
    
    /** The DataSourceQuery contains the means to find the DB record(s) necessary to fetch or save
        the request data. */
    define public property DataSourceQuery as DataSourceQuery no-undo get. set.
    
    constructor public RequestContext(input poDataAccess as IDataAccess,
                                      input poDataSource as IDataSource):
        super().
        
        Assert:ArgumentNotNull(poDataAccess, 'Data Access Object').
        Assert:ArgumentNotNull(poDataSource, 'Data Source Object').
        
        assign this-object:DataAccessObject = poDataAccess
               this-object:DataSourceObject = poDataSource.
    end constructor.
    
    destructor public RequestContext():
        if valid-object(RequestQuery) then
        do:
            RequestQuery:Reset().
            if RequestQuery:IsOpen then
                RequestQuery:Close().
            RequestQuery = ?.
        end.

        if valid-object(DataSourceQuery) then
        do:
            DataSourceQuery:Reset().
            if DataSourceQuery:IsOpen then
                DataSourceQuery:Close().
            DataSourceQuery= ?.
        end.
    end destructor.
    
end class.