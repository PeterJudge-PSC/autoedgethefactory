/** ------------------------------------------------------------------------
    File        : IDataContainerQuery
    Purpose     : A query that's specialised fore use by a DataContainer
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 26 15:03:49 EST 2010
    Notes       : * This may be further specialised by a Presentation Layer ModelQuery 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.DataContainer.IDataContainerQuery.
using OpenEdge.Core.DataContainer.IDataContainer.
using OpenEdge.Core.System.EventArgs.

interface OpenEdge.Core.DataContainer.IDataContainerQuery: /* inherits IQuery */

    /** (mandatory) The DataContainer on which this query operates. */
    define public property DataContainer as IDataContainer no-undo get. /* protected set */
     
    /** (mandatory) A user-friendly name of the query */
    define public property QueryName as character no-undo get. /*protected set.*/
    
    /** (derived) The number of selected rows */
    define public property NumSelectedRows as integer no-undo get. /*protected set.*/
    
    /** Does this query object require a Reopen() call? A query might be flagged as such 
        by a Model when new data is added from a busines entity (or even locally) in 
        batch/bundle mode. */
    define public property RequiresReopen  as logical no-undo get. set.
    
    /* parameter is number of row selection, not query ordinal */
    method public char extent GetSelectedRowKey(input piRow as integer).
    
    method public void ClearSelection().
    method public void SelectRow(input pcRowKey as character extent).
    method public void SelectCurrentRow().
    method public void DeselectRow(input pcRowKey as character extent).
    method public void DeselectCurrentRow().

end interface.