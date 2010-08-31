/** ------------------------------------------------------------------------
    File        : FlagsEnum
    Purpose     : Parent class for flags enumerations: enumerations that contain
                  values that can be 'stacked' or stored together in one
                  property/variable.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri May 15 15:41:08 EDT 2009
    Notes       : * These kinds of enumerations allow us to store multiple values
                    in a single value. OpenEdge.PresentationLayer.Common.ActionStateEnum 
                    contains an example of their use.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.EnumMember.
using Progress.Lang.AppError.

class OpenEdge.Lang.FlagsEnum abstract inherits EnumMember:
    /** Determines whether a variable or member contains the particular specified
        flag enumeration value.
        
        @param piValueSum Contains the value that is being checked to determine whether
        it contains a particular flag.
        @param poCheckEnum The flag being checked for inclusion.
        @return Whether the value includes the specified member
      */
    method static public logical IsA (piValueSum as int, poCheckEnum as EnumMember):
        define variable iPos as integer no-undo.
        define variable iVal as integer no-undo.
        define variable iCheckVal as integer no-undo.
        
        /** This value should always be a power of 2. */
        iCheckVal = poCheckEnum:Value.
        
        /** This loop looks for the position of the bit (the '1') in our value
            so for an iVal of 2, it'll be the right-most position, ie 32. */
        do iPos = 1 to 32 while iVal eq 0:
            iVal = get-bits(iCheckVal, iPos, 1).
        end.
        
        /** Now we look to whether the total enum contains a bit set (ie a '1') set
            at the position we established above.  Because we're dealing with powers 
            of 2, we know that if a bit is set that the check flag appears in the value. */
        return (get-bits(piValueSum, iPos - 1, 1) eq iVal).
    end method.
    
    /* Private ctor so that a derived class can't bypass the necessary checks for
       power-of-two-ness. */
    constructor private FlagsEnum():
        super(-1).
    end constructor.
    
    constructor public FlagsEnum(input piValue as integer):
        this-object(piValue, ?).
    end constructor.
    
    constructor public FlagsEnum ( input piValue as integer, input pcName as character ):
        super(input piValue, input pcName).
        
        ValidateEnumMemberValue(piValue).
    end constructor.
    
    /** The value must be a power of 2 for it to be a flag enumeration value.
        The algorithm below adapted from the following comment on Stackoverflow:
        http://stackoverflow.com/questions/600293/how-to-check-if-a-number-is-a-power-of-2/2552559#2552559 */
    method private void ValidateEnumMemberValue(input piValue as integer):
        if not piValue eq exp(2, log(piValue, 2)) then
          undo, throw new AppError(string(piValue) + ' is not a power of 2, which is required for a flag enumeration value').
    end method.

end class.