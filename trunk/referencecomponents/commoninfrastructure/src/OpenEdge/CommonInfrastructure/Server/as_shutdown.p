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

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.Lang.ABLSession.

using Progress.Lang.Class.

/* ***************************  Main Block  *************************** */
cast(ABLSession:Instance:SessionProperties:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager')),
        IServiceManager):Kernel:Clear(ABLSession:Instance).

/* eof */