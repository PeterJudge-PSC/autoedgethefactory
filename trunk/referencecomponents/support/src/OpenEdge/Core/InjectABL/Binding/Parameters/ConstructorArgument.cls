/*------------------------------------------------------------------------
    File        : ConstructorArgument
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 16:03:33 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.Lang.DataTypeEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Parameters.ConstructorArgument inherits Parameter:
    define private variable mcConstructorName as character no-undo init 'Constructor'. 
    
    /* primitives */
    constructor public ConstructorArgument(pcValue as character):
        super(mcConstructorName , pcValue).
    end constructor.
    
    constructor public ConstructorArgument (pcValue as character, poType as DataTypeEnum):
        super(mcConstructorName, pcValue, poType).    
    end constructor.
    
    constructor public ConstructorArgument(pcValue as character extent):
        super(mcConstructorName, pcValue).
    end constructor.
    
    constructor public ConstructorArgument (pcValue as character extent, poType as DataTypeEnum):
        super(mcConstructorName, pcValue, poType).        
    end constructor.
    
    /* objects */
    constructor public ConstructorArgument(poValue as Object):
        super(mcConstructorName, poValue).
    end constructor.

    constructor public ConstructorArgument (poValue as Object, poDeclaredType as class Class):
        super(mcConstructorName, poValue, poDeclaredType).
    end constructor.

    constructor public ConstructorArgument(poValue as Object extent):
        super(mcConstructorName, poValue).
    end constructor.

    constructor public ConstructorArgument (poValue as Object extent, poDeclaredType as class Class):
        super(mcConstructorName, poValue, poDeclaredType).
    end constructor.
    
    /* types */
    constructor public ConstructorArgument(poType as class Class):
        super(mcConstructorName, poType).
    end constructor.

    constructor public ConstructorArgument(poType as class Class, poDataType as DataTypeEnum):
        super(mcConstructorName, poType, poDataType).
    end constructor.

    constructor public ConstructorArgument(poType as class Class extent):
        super(mcConstructorName, poType).
    end constructor.
    
    constructor public ConstructorArgument(poType as class Class extent, poDataType as DataTypeEnum):
        super(mcConstructorName, poType, poDataType).
    end constructor.
        
end class.