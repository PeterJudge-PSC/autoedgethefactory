/** ------------------------------------------------------------------------
    File        : ICache
    Purpose     : 
    Syntax      : Tracks instances for re-use in certain scopes. 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 17:03:02 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Lifecycle.IPipeline.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Lang.DateTimeAddIntervalEnum.
using Progress.Lang.Object.

interface OpenEdge.Core.InjectABL.Lifecycle.ICache:
    define public property PruningInterval as integer no-undo get. set.
    define public property PruningUnit as DateTimeAddIntervalEnum no-undo get. set.

    /** Gets the activation pipeline in use for this kernel **/
    define public property Pipeline as IPipeline no-undo get.
    
    /** Gets the number of entries currently stored in the cache. **/
    define public property Count as integer no-undo get.

    /** Stores the specified instance in the cache. 
        @param context The context to store.
        @param reference The instance reference.
     **/
    method public void Remember(poContext as ILifecycleContext, poReference as Object).
    
    /** Tries to retrieve an instance to re-use in the specified context. 
        @param context The context that is being activated.
        @returns The instance for re-use, or unknown if none has been stored.</returns>
     **/
    method public Object TryGet(poContext as ILifecycleContext).
    
    /** Tries to get an instance's Context for use with additional decoration/injection. **/
    method public ILifecycleContext TryGetContext(poInstance as Object).
    
    /** Deactivates and releases the specified instance from the cache. 
        @param instance The instance to release.
        @return true if the instance was found and released. otherwise false.</returns>
     **/
    method public logical Release(poInstance as Object).

    /** Removes instances from the cache which should no longer be re-used. **/
    method public void Prune().

    /** Immediately deactivates and removes all instances in the cache that are owned by
        the specified scope.
        @param scope The scope whose instances should be deactivated.
     **/
    method public void Clear(poScope as Object).
    
    /** Immediately deactivates and removes all instances in the cache, regardless of scope. **/
    method public void Clear().
    
end interface.