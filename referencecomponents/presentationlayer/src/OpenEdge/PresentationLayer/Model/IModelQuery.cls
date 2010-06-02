/*------------------------------------------------------------------------
    File        : IModelQuery
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jan 26 15:03:49 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.PresentationLayer.Model.*.
using OpenEdge.Core.System.*.
using Progress.Lang.*.

interface OpenEdge.PresentationLayer.Model.IModelQuery: /* inherits IQuery */

    define public property Model as IModel no-undo get. /* protected set */ 
    define public property QueryName as character no-undo get. /*protected set.*/
    define public property NumSelectedRows as integer no-undo get. /*protected set.*/
    
    /* Events */
    define public event QueryOpened       signature void (poQuery as IModelQuery, poArgs as EventArgs).
    define public event QueryClosed       signature void (poQuery as IModelQuery, poArgs as EventArgs).
    define public event QueryRepositioned signature void (poQuery as IModelQuery, poArgs as EventArgs).
        
    /* See notes in OpenEdge.PresentationLayer.Model.ModelQuery.cls */
    method public void SetQueryHandle(phQuery as handle).
    method public void ResetQueryHandle().

    /* parameter is number of row selection, not query ordinal */
    method public char extent GetSelectedRowKey(piRow as int).
        
    method public void ClearSelection().
    method public void SelectRow(pcRowKey as char extent).
    method public void SelectCurrentRow().    
    method public void DeselectRow(pcRowKey as char extent).
    method public void DeselectCurrentRow().
        
end interface.