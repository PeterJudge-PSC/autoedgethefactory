/** ------------------------------------------------------------------------
    File        : DataSourceEventArgs
    Purpose     : Event Args for Datasource events (fill, save, etc).
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Aug 27 16:52:41 EDT 2010
    Notes       : * These event args are unlikely to be used for cases
                    where built-in ProDataSet callbacks are used, but the 
                    DataSource does support manual fill/fetch operations too.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataSource.IDataSource.
using OpenEdge.DataSource.DataSourceEventEnum.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.DataFormatEnum.

using OpenEdge.Core.System.EventArgs.
using OpenEdge.Lang.DataTypeEnum.

using OpenEdge.Lang.Assert.

class OpenEdge.DataSource.DataSourceEventArgs inherits EventArgs:
    
    /* (Mandatory) the datasource being operated upon */
    define public property DataSource as IDataSource no-undo get. private set. 
    
    /** The data format type fpr the DataTarget data.  */
    define public property DataTargetFormat as DataFormatEnum no-undo get. set.
    
    /** The data type of the data stored in the DataTarget */
    define public property DataTargetType as DataTypeEnum no-undo get. set.
    
    /** Handle of the buffer/dataset being operated on, and to which the even applies. */
    define public property DataTarget as longchar no-undo get. set.
    
    /** The event that caused this argument to be fired. */    
    define public property DataSourceEvent as DataSourceEventEnum no-undo get. private set.
    
    /** The row key used to identify the row being operated on in the data target. */
    define public property RowKey as character extent no-undo get. set.
    
    constructor public DataSourceEventArgs(input poDataSource as IDataSource):
        super().
        
        Assert:ArgumentNotNull(poDataSource, 'Data Source').
        
        DataSource = poDataSource.
    end constructor.
            
    constructor public DataSourceEventArgs(input poDataSource as IDataSource,
                                           input poEvent as DataSourceEventEnum,
                                           input poFormat as DataFormatEnum,
                                           input poDataType as DataTypeEnum,
                                           input pcData as longchar,
                                           input pcRowKey as character extent):
        this-object(poDataSource).        
        assign DataSourceEvent = poEvent
               DataTargetFormat = poFormat
               DataTargetType = poDataType
               DataTarget = pcData
               RowKey = pcRowKey.
    end constructor.

end class.