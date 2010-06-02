/*------------------------------------------------------------------------
    File        : DataRequestFlagsEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon May 18 09:58:06 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Model.*.
using OpenEdge.Lang.*.

class OpenEdge.PresentationLayer.Model.DataRequestFlagsEnum inherits FlagsEnum final:
    
    define public static property Default as EnumMember no-undo get. private set.
    
    /* Always refetch data, even when request context is the same. */
    define public static property IgnoreContextForFetch as EnumMember no-undo get. private set.
    /* Only fetch new data when the context has changed. */
    define public static property FetchOnChangedContextOnly as EnumMember no-undo get. private set.
           
    constructor static DataRequestFlagsEnum():
        DataRequestFlagsEnum:IgnoreContextForFetch = new EnumMember(1).
        DataRequestFlagsEnum:FetchOnChangedContextOnly = new EnumMember(2). 
        
        DataRequestFlagsEnum:Default = DataRequestFlagsEnum:IgnoreContextForFetch. 
    end constructor.
    
end class.