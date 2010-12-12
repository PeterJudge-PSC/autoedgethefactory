/** ------------------------------------------------------------------------
    File        : String
    Purpose     : Primitive class for character/longchar variables
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Aug 11 13:08:46 EDT 2009
    Notes       : * Named 'String' because of keyword/namespace conflicts with
                    ABL Primitive 'character'. There's no built-in class for this.
                  * Initial requirement for collections; having a class for the
                    primitive value means that we don't have to distinguish between
                    primitives and types, which makes the code more readable.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectInputStream.

using OpenEdge.Lang.String.
using Progress.Lang.Object.

class OpenEdge.Lang.String
        implements IExternalizable:
    
    define static private variable moEmptyString as String no-undo.
    define public property Value as longchar no-undo get. private set.
    
    constructor public String():
        super().        
    end constructor.
    
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
    
    method override public logical Equals(input p0 as Object):
        if type-of(p0, String) then
            return (this-object:Value eq cast(p0, String):Value).
        else
    
        return super:Equals(p0).    
	end method.
	
/** IExternalizable **/
    method public void WriteObject(po as ObjectOutputStream):
        po:WriteLongChar(this-object:Value).
    end method.
    
    method public void ReadObject(po as ObjectInputStream):
        this-object:Value = po:ReadLongChar().
    end method.
    
end class.