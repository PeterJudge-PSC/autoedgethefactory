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

using OpenEdge.DataSource.DataSourceEventEnum.
using OpenEdge.Core.System.EventArgs.

class OpenEdge.DataSource.DataSourceEventArgs inherits EventArgs: 
    /** The event that caused this argument to be fired. */    
    define public property DataSourceEvent as DataSourceEventEnum no-undo get. set.
    
    /** Handle of the buffer/dataset being operated on, and to which the even applies. */
    define public property Handle as handle no-undo get. set.
    
	constructor public DataSourceEventArgs(input poEvent as DataSourceEventEnum,
	                                       input phHandle as handle):
		super().
		
		DataSourceEvent = poEvent.
		this-object:Handle = phHandle.
	end constructor.

end class.