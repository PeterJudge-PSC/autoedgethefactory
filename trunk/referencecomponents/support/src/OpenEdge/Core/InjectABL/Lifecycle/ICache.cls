/*------------------------------------------------------------------------
    File        : ICache
    Purpose     : 
    Syntax      : Tracks instances for re-use in certain scopes. 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 04 17:03:02 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.InjectABL.Lifecycle.*.
using Progress.Lang.*.

interface OpenEdge.Core.InjectABL.Lifecycle.ICache:
    /** Gets the activation pipeline in use for this kernel **/
    define public property Pipeline as IPipeline no-undo get.
    
    /** Gets the number of entries currently stored in the cache. **/
    define public property Count as integer no-undo get.

    /** Stores the specified instance in the cache. 
        <param name="context">The context to store.</param>
        <param name="reference">The instance reference.</param>
     **/
    method public void Remember(poContext as ILifecycleContext, poReference as Object).
    
    /** Tries to retrieve an instance to re-use in the specified context. 
        <param name="context">The context that is being activated.</param>
        <returns>The instance for re-use, or unknown if none has been stored.</returns>
     **/
    method public Object TryGet(poContext as ILifecycleContext).
    
    /** Tries to get an instance's Context for use with additional decoration/injection. **/
    method public ILifecycleContext TryGetContext(poInstance as Object).
    
    /** Deactivates and releases the specified instance from the cache. 
        <param name="instance">The instance to release.</param>
        <returns>true if the instance was found and released. otherwise false.</returns>
     **/
    method public logical Release(poInstance as Object).

    /** Removes instances from the cache which should no longer be re-used. **/
    method public void Prune().

    /** Immediately deactivates and removes all instances in the cache that are owned by
        the specified scope.
        <param name="scope">The scope whose instances should be deactivated.</param>
     **/
    method public void Clear(poScope as Object).
    
    /** Immediately deactivates and removes all instances in the cache, regardless of scope. **/
    method public void Clear().
    
end interface.