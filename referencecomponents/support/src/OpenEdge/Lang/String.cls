@todo(task="implement", action="complete this shadow object").
/*------------------------------------------------------------------------
    File        : String
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Aug 11 13:08:46 EDT 2009
    Notes       : * Named 'String' because of keyword/namespace conflicts with
                  ABL Primitive 'character'
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.String.
using OpenEdge.Lang.ABLPrimitive.

class OpenEdge.Lang.String inherits ABLPrimitive:
    define static variable moEmptyString as String no-undo.
    define public property Value as longchar no-undo get. private set.
    
    constructor public String(pcString as longchar):
        super().
        this-object:Value = pcString.
    end constructor.

    constructor public String(pcString as char):
        super().
        this-object:Value = pcString.
    end constructor.
    
    method public void Trim():
        /* we can't use the ABL TRIM keyword, since we run into 
           name conflicts, so do a left- and right-trim instead. */
        right-trim(left-trim(this-object:Value)).
    end method.
    
    method static public String Empty ():
        if not valid-object(moEmptyString) then
            moEmptyString = new String('').
        
        return moEmptyString.
    end method.

end class.