/*------------------------------------------------------------------------
    File        : as_shutdown.p
    Purpose     : 

    Syntax      :

    Description : AppServer shutdown procedure

    @author pjudge
    Created     : Fri Jun 04 13:57:59 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Lang.ABLSession.

using Progress.Lang.Class.

/* ***************************  Main Block  *************************** */
cast(ABLSession:Instance:SessionProperties:Get(Class:GetClass('OpenEdge.Core.InjectABL.IKernel')),
        IKernel):Clear(ABLSession:Instance).

/* eof */