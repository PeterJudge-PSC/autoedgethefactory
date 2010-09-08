/** ------------------------------------------------------------------------
    File        : DataSourceEventEnum
    Purpose     : Enumeration of datasource events. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Aug 27 16:59:30 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataSource.DataSourceEventEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.DataSource.DataSourceEventEnum inherits EnumMember: 
    
    /* DataSource Fetch/Fill events */
    define static public property BeforeFill    as DataSourceEventEnum no-undo get. private set.
    define static public property BeforeRowFill as DataSourceEventEnum no-undo get. private set.
    define static public property AfterRowFill  as DataSourceEventEnum no-undo get. private set.
    define static public property AfterFill     as DataSourceEventEnum no-undo get. private set.
    
    /* DataSource Save/Commit events */
    define static public property BeforeSaveTransaction as DataSourceEventEnum no-undo get. private set.
    define static public property BeforeSave            as DataSourceEventEnum no-undo get. private set.
    define static public property AfterSave             as DataSourceEventEnum no-undo get. private set.
    define static public property AfterSaveTransaction  as DataSourceEventEnum no-undo get. private set.		
		
	constructor public DataSourceEventEnum ( input pcName as character ):
		super (input pcName).
	end constructor.
	
	constructor static DataSourceEventEnum():
        /* DataSource Fetch/Fill events */
        DataSourceEventEnum:BeforeFill    = new DataSourceEventEnum('BeforeFill').
        DataSourceEventEnum:BeforeRowFill = new DataSourceEventEnum('BeforeRowFill').
        DataSourceEventEnum:AfterRowFill  = new DataSourceEventEnum('AfterRowFill').
        DataSourceEventEnum:AfterFill     = new DataSourceEventEnum('AfterFill').
        
        /* DataSource Save/Commit events */
        DataSourceEventEnum:BeforeSaveTransaction = new DataSourceEventEnum('BeforeSaveTransaction').
        DataSourceEventEnum:BeforeSave            = new DataSourceEventEnum('BeforeSave').
        DataSourceEventEnum:AfterSave             = new DataSourceEventEnum('AfterSave').
        DataSourceEventEnum:AfterSaveTransaction  = new DataSourceEventEnum('AfterSaveTransaction').	    
	end constructor.

end class.