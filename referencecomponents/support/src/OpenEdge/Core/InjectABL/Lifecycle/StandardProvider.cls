/*------------------------------------------------------------------------
    File        : StandardProvider
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Mar 02 16:41:44 EST 2010
    Notes       : * We need to catch certain P.L.SysErrors since we don't
                    know in advance what the callees' signatures are, and so
                    we shoot and hope. And catch SysErrors based on number.
                    This catch allows us to handle these conditions gracefully,
                    which is what we would do if we could determine the callee
                    signatures in advance. 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection.
using OpenEdge.Core.InjectABL.Binding.Parameters.MethodArgument.
using OpenEdge.Core.InjectABL.Binding.Parameters.PropertyValue.
using OpenEdge.Core.InjectABL.Binding.Parameters.ConstructorArgument.
using OpenEdge.Core.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Core.InjectABL.Lifecycle.IProvider.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.InvocationError.

using OpenEdge.Core.System.ArgumentError.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.IOModeEnum.
using OpenEdge.Lang.Assert.

using Progress.Lang.Class.
using Progress.Lang.ParameterList.
using Progress.Lang.AppError.
using Progress.Lang.SysError.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Lifecycle.StandardProvider implements IProvider:
    define private static property ProviderType as class Class no-undo get. private set.  
    
    define public property Type as class Class no-undo get. private set.
    
    constructor public StandardProvider(poClass as class Class):
        this-object:Type = poClass.
    end constructor.
    
    /** Method injection **/
    method protected void InjectViaMethod(poInstance as Object,
                                          pcMethodName as character,
                                          poParameters as IParameterCollection,
                                          poContext as ILifecycleContext):
        define variable oPL as ParameterList no-undo.
        define variable oMethArg as MethodArgument extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iNumParam as integer no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oArg as IParameter no-undo.
        
        Assert:ArgumentNotNull(poParameters, 'Injection parameters').
        Assert:ArgumentNotNullOrEmpty(pcMethodName, 'Injection method name').
        
        oPL = new ParameterList(poParameters:Size).
        
        oIterator = poParameters:Iterator().
        do while oIterator:HasNext():
            oArg = cast(oIterator:Next(), IParameter).
            iLoop = iLoop + 1.
            SetParameterValue(poContext,
                              oPL,
                              iLoop,
                              oArg).
        end.

        poInstance:GetClass():Invoke(poInstance, pcMethodName, oPL).
        
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            /* Could not dynamically find method ''<name> in class ''<name> with <number> matching parameter(s). (15312) */
            case eSysErr:GetMessageNum(1):
                when 15312 then
                    undo, throw new InvocationError(eSysErr, 'method', poContext:Binding:TargetType:TypeName).
                otherwise
                    undo, throw eSysErr.
            end case.
        end catch.
    end method.
    
    /** Property injection **/
    method protected void InjectViaProperty(poInstance as Object,
                                            poPropertyValue as PropertyValue,
                                            poContext as ILifecycleContext):
        define variable oPL as ParameterList no-undo.

        define variable oMethArg as PropertyValue extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iNumParam as integer no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oArg as IParameter no-undo.

        undo, throw new AppError('Setting property values via reflection not supported yet').
        
        Assert:ArgumentNotNull(poPropertyValue, 'Injection property value parameter').
        
        oPL = new ParameterList(1).
        SetParameterValue(poContext,
                          oPL,
                          1, 
                          poPropertyValue).
        
        poInstance:GetClass():Invoke(poInstance, poPropertyValue:Name, oPL).
        
        @todo(task="implement", action="the msg number will change").
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            /* Could not dynamically find method ''<name> in class ''<name> with <number> matching parameter(s). (15312) */
            case eSysErr:GetMessageNum(1):
                when 15312 then
                    undo, throw new InvocationError(eSysErr, 'property', poContext:Binding:TargetType:TypeName).
                otherwise
                    undo, throw eSysErr.
            end case.
        end catch.
    end method.
    
    @todo(task="implement", action="futures").
    /** Constructor injection 
    
        At some point in the future, we may add a generic/dynamic constructor injection 
        strategy, which will determine which constructor to use. At the moment, this code
        takes all of the ConstructorArguments that are part of this context, and attempts
        to invoke an object with those arguments.
     **/
    method public Object Create(poContext as ILifecycleContext):
        define variable oNew as Object no-undo.
        define variable oPL as ParameterList no-undo.
        define variable oCtorArg as ConstructorArgument extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iNumParam as integer no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oArg as Object no-undo.
        
        Assert:ArgumentNotNull(poContext:Binding:TargetType, 'Binding target').
        
        iNumParam = 0.
        if not poContext:Parameters:IsEmpty() then
        do:
            extent(oCtorArg) = poContext:Parameters:Size.
            
            oIterator = poContext:Parameters:Iterator().
            do while oIterator:HasNext():
                oArg = oIterator:Next().
                
                if type-of(oArg, ConstructorArgument) then
                    assign iNumParam = iNumParam + 1
                           oCtorArg[iNumParam] = cast(oArg, ConstructorArgument).
            end.
        end.
        
        oPL = new ParameterList(iNumParam).
        do iLoop = 1 to iNumParam:
            SetParameterValue(poContext,
                              oPL,
                              iLoop,
                              oCtorArg[iLoop]).
        end.
        
        oNew = poContext:Binding:TargetType:New(oPL).
        
        /* Make sure we're using the right type */
        Assert:ArgumentIsType(oNew, this-object:Type).
        
        return oNew.
        
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            /* Dynamic NEW cannot NEW class <type> because an unambiguous appropriate constructor could not be found. (15310) */ 
            case eSysErr:GetMessageNum(1):
                when 15310 then
                    undo, throw new InvocationError(eSysErr, 'constructor', poContext:Binding:TargetType:TypeName).
                otherwise
                    undo, throw eSysErr.                                                    
            end case.
        end catch.
    end method.
    
    method public void InjectMethods(poInstance as Object,
                                     poContext as ILifecycleContext):
        define variable oParameter as IParameter no-undo.
        define variable oIterator as IIterator no-undo.
        define variable cMethod as character no-undo.
        define variable cPrevMethod as character no-undo.
        def var oMethArgs as IParameterCollection.
        
        if not poContext:Parameters:IsEmpty() then
        do:
            cPrevMethod = ''.
            oIterator = poContext:Parameters:Iterator().
            do while oIterator:HasNext():
                oParameter = cast(oIterator:Next(), IParameter).
                
                if type-of(oParameter, MethodArgument) then
                do:
                    cMethod = oParameter:Name.
                    
                    if cPrevMethod ne cMethod then
                    do:
                        /* inject the previous method */
                        if valid-object(oMethArgs) then
                            InjectViaMethod(poInstance,
                                            cPrevMethod,
                                            oMethArgs,
                                            poContext).
                        oMethArgs = new IParameterCollection().
                    end.
                    
                    oMethArgs:Add(oParameter).
                    
                    cPrevMethod = cMethod.
                end.    /* is MethodArgument */
            end.    /* iterate */
            
            /* inject the last method. this is an artifact of the way that the Collection Iterator works. */
            if valid-object(oMethArgs) and cMethod ne '' then
                InjectViaMethod(poInstance,
                                cMethod,
                                oMethArgs,
                                poContext).
        end.    /* empty params */
    end method.
    
    method public void InjectProperties(poInstance as Object,
                                        poContext as ILifecycleContext):
        define variable oPropValue as IParameter no-undo.
        define variable oIterator as IIterator no-undo.
        
        if not poContext:Parameters:IsEmpty() then
        do:
            oIterator = poContext:Parameters:Iterator().
            do while oIterator:HasNext():
                oPropValue = cast(oIterator:Next(), IParameter).
                
                if type-of(oPropValue, PropertyValue) then
                    InjectViaProperty(poInstance,
                                      cast(oPropValue, PropertyValue),
                                      poContext).
            end.
        end.
    end method.
    
    method protected void SetParameterValue(poContext as ILifecycleContext,
                                            poParams as Progress.Lang.ParameterList /* fully-qualified for clarity */,
                                            piOrder as integer,
                                            poArgument as IParameter /*InjectABL parameter*/ ):
        define variable oValue as Object no-undo.
        define variable oValueArray as Object extent no-undo.
        define variable cValue as character no-undo.
        define variable cValueArray as character extent no-undo.
        define variable lIsArray as logical no-undo.
        
        lIsArray = DataTypeEnum:IsArray(poArgument:Type).
        
        if DataTypeEnum:IsPrimitive(poArgument:Type) then
        do:
            if lIsArray then
            do:
                poArgument:GetValue(poContext, output cValueArray).
                poParams:SetParameter(piOrder,
                                      poArgument:Type:ToString(),
                                      IOModeEnum:Input:ToString(),
                                      cValueArray).
            end.
            else
            do:
                poArgument:GetValue(poContext, output cValue).
                poParams:SetParameter(piOrder,
                                      poArgument:Type:ToString(),
                                      IOModeEnum:Input:ToString(),
                                      cValue).
            end.
        end.    /* primitives */
        else
        do:
            if lIsArray then
            do:
                poArgument:GetValue(poContext, output oValueArray).
                poParams:SetParameter(piOrder,
                                      substitute(DataTypeEnum:ClassArray:ToString(), poArgument:DeclaredType:TypeName),
                                      IOModeEnum:Input:ToString(),
                                      oValueArray).
            end.
            else
            do:
                poArgument:GetValue(poContext, output oValue).
                poParams:SetParameter(piOrder,
                                      substitute(DataTypeEnum:Class:ToString(), poArgument:DeclaredType:TypeName),
                                      IOModeEnum:Input:ToString(),
                                      oValue).
            end.
        end.    /* objects*/
        
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            case eSysErr:GetMessageNum(1):
                /* Unable to convert SET-PARAMETER value to datatype passed. (10059) */
                when 10059 then
                    undo, throw new ArgumentError(eSysErr, 'SetParameter', poArgument:Name).
                otherwise
                    undo, throw eSysErr.
            end case.
        end catch.
    end method.
    
    constructor static StandardProvider():
        StandardProvider:ProviderType = Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.IProvider').
    end constructor.
    
    /** factory method for new IProvider instances **/
    method static public IProvider GetProvider(poProviderType as class Class,
                                               poImplementation as class Class):
        define variable oProvider as IProvider no-undo.
        
        Assert:ArgumentNotNull(poProviderType, "provider type").
        Assert:ArgumentNotNull(poImplementation, "implementation type").
        
        if not poProviderType:IsA(StandardProvider:ProviderType) then
            undo, throw new AppError('type mismatch:' + poProviderType:TypeName + ' must implement ' + StandardProvider:ProviderType:TypeName).
        
        oProvider = dynamic-new(poProviderType:TypeName) (poImplementation).
        
        return oProvider.
    end method.
    
end class.
