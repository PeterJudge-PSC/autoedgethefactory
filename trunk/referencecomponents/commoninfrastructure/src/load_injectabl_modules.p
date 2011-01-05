/** ------------------------------------------------------------------------
    File        : load_injectabl_modules.p
    Purpose     : InjectABL module loader for the OERA CommonInfrastructure layer
    Syntax      :
    Description : 
    @author pjudge
    Created     : Mon Dec 13 13:40:24 EST 2010
    Notes       :
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.InjectABL.ServiceMessageModule.
using OpenEdge.CommonInfrastructure.InjectABL.CommonInfrastructureModule.
using OpenEdge.Core.InjectABL.IKernel.

/** -- defs  -- **/
define input parameter poKernel as IKernel no-undo.

/** -- main -- **/
poKernel:Load(new ServiceMessageModule()).
poKernel:Load(new CommonInfrastructureModule()).

/** -- errors -- **/
/** -- eof -- **/
