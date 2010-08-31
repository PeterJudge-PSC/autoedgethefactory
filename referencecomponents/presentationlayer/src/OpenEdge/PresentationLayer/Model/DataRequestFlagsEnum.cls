@todo(task="question", action="deprecated?").
/** ------------------------------------------------------------------------
    File        : DataRequestFlagsEnum
    Purpose     : Enumeration of data request flags for deciding when to fetch/operate
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon May 18 09:58:06 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Model.DataRequestFlagsEnum.
using OpenEdge.Lang.FlagsEnum.

class OpenEdge.PresentationLayer.Model.DataRequestFlagsEnum inherits FlagsEnum final:
    
    define public static property Default as DataRequestFlagsEnum no-undo get. private set.
    
    /* Always refetch data, even when request context is the same. */
    define public static property IgnoreContextForFetch as DataRequestFlagsEnum no-undo get. private set.
    /* Only fetch new data when the context has changed. */
    define public static property FetchOnChangedContextOnly as DataRequestFlagsEnum no-undo get. private set.
           
    constructor static DataRequestFlagsEnum():
        DataRequestFlagsEnum:IgnoreContextForFetch = new DataRequestFlagsEnum(1).
        DataRequestFlagsEnum:FetchOnChangedContextOnly = new DataRequestFlagsEnum(2). 
        
        DataRequestFlagsEnum:Default = DataRequestFlagsEnum:IgnoreContextForFetch. 
    end constructor.

    constructor public DataRequestFlagsEnum ( input piValue as integer ):
        super (input piValue).
    end constructor.

end class.