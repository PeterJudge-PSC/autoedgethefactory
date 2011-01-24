/** ------------------------------------------------------------------------
    File        : load_injectabl_modules.p
    Purpose     : InjectABL module loader for the AutoEdge|TheFactory sample application
    Syntax      :
    Description : 
    @author pjudge
    Created     : Mon Dec 13 13:40:24 EST 2010
    Notes       :
  ---------------------------------------------------------------------- */
{routinelevel.i}

using AutoEdge.Factory.InjectABL.FactoryCommonModule.
using AutoEdge.Factory.InjectABL.FactoryOrderModule.
using AutoEdge.Factory.InjectABL.FactoryBuildModule.
using OpenEdge.Core.InjectABL.IKernel.

/** -- defs  -- **/
define input parameter poKernel as IKernel no-undo.

/** -- main -- **/
poKernel:Load(new FactoryCommonModule()).
poKernel:Load(new FactoryOrderModule()).
poKernel:Load(new FactoryBuildModule()).

/** -- eof -- **/
