/** ------------------------------------------------------------------------
    File        : QueryElementEnum
    Purpose     : Enumeration of elements/component parts of a query 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Sep 02 15:01:39 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.QueryElementEnum.
using OpenEdge.Lang.FlagsEnum.

class OpenEdge.Core.System.QueryElementEnum final inherits FlagsEnum:
    
    define public static property Buffer    as QueryElementEnum no-undo get. private set.
    define public static property Join      as QueryElementEnum no-undo get. private set.
    define public static property Filter    as QueryElementEnum no-undo get. private set.
    define public static property Sort      as QueryElementEnum no-undo get. private set.
    
    constructor static QueryElementEnum():
        QueryElementEnum:Buffer = new QueryElementEnum(1).
        QueryElementEnum:Join = new QueryElementEnum(2).
        QueryElementEnum:Filter = new QueryElementEnum(4).
        QueryElementEnum:Sort = new QueryElementEnum(8).
    end constructor.

	constructor public QueryElementEnum ( input piValue as integer ):
		super (input piValue).
	end constructor.
    
end class.