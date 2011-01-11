/* *------------------------------------------------------------------------
    File        : ITableOwner
    Purpose     :        
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Aug 04 11:28:51 EDT 2009
    Notes       : * An implementation of this interface is required by an IQuery object
                    in order to create a buffer (or buffers) for the query to use. 
  ---------------------------------------------------------------------- */

interface OpenEdge.Core.System.ITableOwner:
    
    /** @param character A table or buffer name. The implementer will
        know how to interpret the name. The name passed in is the name
        that the query will use together with its IQueryDefinition.
        
        @return A buffer handle corresponding to the requested name. */
    method public handle GetTableHandle (input pcTableName as character).
    
end interface.
