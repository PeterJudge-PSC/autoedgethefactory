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

/* Don't have a USING for this class, so that we can avoid conflicts with the STRING() ABL keyword/function
using OpenEdge.Lang.String.*/
using Progress.Lang.Object.
using Progress.Lang.Class.

class OpenEdge.Lang.String
        implements IExternalizable:

    define static public property Type as class Class no-undo
        get():
            if not valid-object(OpenEdge.Lang.String:Type) then
                OpenEdge.Lang.String:Type = Class:GetClass('OpenEdge.Lang.String').
            
            return OpenEdge.Lang.String:Type.
        end.
        private set.
    
    define static private variable moEmptyString as OpenEdge.Lang.String no-undo.
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
    
    method static public OpenEdge.Lang.String Empty ():
        if not valid-object(moEmptyString) then
            moEmptyString = new OpenEdge.Lang.String('').
        
        return moEmptyString.
    end method.
    
    method override public logical Equals(input p0 as Object):
        if type-of(p0, OpenEdge.Lang.String) then
            return (this-object:Value eq cast(p0, OpenEdge.Lang.String):Value).
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

    method public character extent Split(input pcDelimiter as character):
        return OpenEdge.Lang.String:Split(this-object:Value, pcDelimiter).
    end method.
    
    method public character extent Split():
        return OpenEdge.Lang.String:Split(this-object:Value).
    end method.
        
    method static public character extent Split(input pcValue as longchar):
        return OpenEdge.Lang.String:Split(pcValue, ',').
    end method.
            
    method static public character extent Split(input pcValue as longchar,
                                                input pcDelimiter as character):
        define variable cArray as character extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = num-entries(pcValue, pcDelimiter).
        extent(cArray) = iMax.
        
        do iLoop = 1 to iMax:
            cArray[iLoop] = entry(iLoop, pcValue, pcDelimiter).
        end. 
        
        return cArray.
    end method.
    
    method public handle ToHandle():
        define variable cValue as character no-undo.
        cValue = this-object:Value.
        
        return widget-handle(cValue).
    end method.
    
    method override public character ToString():
        define variable cValue as character no-undo.
        cValue = this-object:Value.
        
        return cValue.
    end method.
    
end class.