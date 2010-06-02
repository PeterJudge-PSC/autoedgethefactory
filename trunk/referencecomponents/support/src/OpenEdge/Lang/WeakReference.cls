/*------------------------------------------------------------------------
    File        : WeakReference
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Mar 12 11:31:59 EST 2010
    Notes       : * Based on http://msdn.microsoft.com/en-us/library/ms404247(v=VS.90).aspx
                  * Performance of ResolveWeakReference() will probably suck.
                  * The usefulness of WeakReference as an instance is not very
                    much as it stands, since any integer variable will suffice.
                    However, we get some typing here, and this could potentially
                    be extended at some point. An ABL statement "OBJECT-REFERENCE(int)"
                    would entirely replace this class.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.WeakReference.
using Progress.Lang.Object.

class OpenEdge.Lang.WeakReference:    
    define public property Reference as integer no-undo get. private set.
    
    constructor public WeakReference(poObject as Object):
        Reference = integer(poObject).
    end constructor.
    
    method public logical IsAlive():
        return valid-object(Resolve()).
    end method.
    
    method public Object Resolve():
        return WeakReference:ResolveWeakReference(Reference).
    end method.
    
    method static public Object ResolveWeakReference(piReference as integer):
        define variable oInstance as Object no-undo.
        define variable oReference as Object no-undo.
        
        oInstance = session:first-object.
        do while valid-object(oInstance) and not valid-object(oReference):
            if piReference = int(oInstance) then
                oReference = oInstance.
            oInstance = oInstance:Next-Sibling.
        end.
        
        return oReference.        
    end method.
    
end class.