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

using AutoEdge.Factory.Server.InjectABL.CommonModule.
using AutoEdge.Factory.Server.InjectABL.OrderModule.
using AutoEdge.Factory.Server.InjectABL.BuildModule.
using OpenEdge.Core.InjectABL.IKernel.

/** -- defs  -- **/
define input parameter poKernel as IKernel no-undo.

/** -- main -- **/
poKernel:Load(new CommonModule()).
poKernel:Load(new OrderModule()).
poKernel:Load(new BuildModule()).

/** -- eof -- **/
