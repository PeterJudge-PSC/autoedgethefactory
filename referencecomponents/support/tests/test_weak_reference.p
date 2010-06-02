/*------------------------------------------------------------------------
    File        : test_weak_reference.p
    Purpose     : Tests the OpenEdge.Lang.WeakReference class

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Fri Mar 12 11:36:58 EST 2010
    Notes       : * this test MUST be run with -nogc, otherwise the performance
                    test will fail miserably.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.WeakReference.
using Progress.Lang.AppError.
using Progress.Lang.Object.

def var oInstance as Object no-undo.
def var iRef as int no-undo.
def var oRef as Object no-undo.
def var oWeakRef as WeakReference no-undo.
def var lAlive as log no-undo.

oInstance = new Object().

oWeakRef = new WeakReference(oInstance).

iRef = oWeakRef:Reference.

if iref ne int(oInstance) then
    undo, throw new AppError('weak reference not same as int(obj)').

lAlive = oWeakRef:IsAlive().
if lalive eq false then
    undo, throw new AppError('weak reference not alive; should be').
    
oRef = oWeakRef:Resolve().
if not valid-object(oRef) then
    undo, throw new AppError('weak reference not resolve; should be').     

if oref ne oInstance then
    undo, throw new AppError('resolved weak reference not same as instance').

/* explicitly delete object; we can't simply set variable to ? and hope the GC
   does its thing before the next line
 */
delete object oInstance.
 
lAlive = oWeakRef:IsAlive().
if lalive eq true then
    undo, throw new AppError('weak reference alive; should not be').

oRef = oWeakRef:Resolve().
if valid-object(oRef) then
    undo, throw new AppError('weak reference was resolved; should not be').     

/** performance **/
run PerformanceTest.

message 
'tests passed'
view-as alert-box.

procedure PerformanceTest:
    def var oInstance as Object no-undo.
    def var iLoop as int no-undo.
    def var iMax as int no-undo.
    def var iRef as int no-undo.
    def var iRefLoc as int no-undo.
    def var oRef as Object no-undo.
    def var oWeakRef as WeakReference no-undo.
    def var istart as int no-undo.
    def var iend as int no-undo.
        
    iMax =  exp(10, 5).
    iRefLoc =  /*2 / 3 * */ iMax.
    
    do iloop = 1 to iMax:
        oInstance = new Progress.Lang.Object().
        
        if iRefLoc eq iloop then
            iRef = int(oInstance).
    end.

    istart = mtime.
    oRef = OpenEdge.Lang.WeakReference:ResolveWeakReference(iRef).
    iend = mtime.
    
    message 
    imax ' objects took ' (iend - istart) ' milliseconds' skip
    iref ' found ?' valid-object(oref)
    'iRefLoc=' iRefLoc 
    view-as alert-box.
    
    
    
end procedure.

catch e as AppError:
    message 
        e:ReturnValue
    view-as alert-box.
end catch.

/* eof */ 