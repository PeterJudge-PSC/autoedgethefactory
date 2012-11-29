/** ****************************************************************************
  Copyright 2012 Progress Software Corporation
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
    http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
**************************************************************************** **/
/** ------------------------------------------------------------------------
    File        : IPaintVehicle
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Nov 30 16:36:59 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using AutoEdge.Factory.Server.Build.BusinessComponents.VehicleBuildStep.
using AutoEdge.Factory.Server.Build.BusinessComponents.PaintVehicle.

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

class AutoEdge.Factory.Server.Build.BusinessComponents.PaintVehicle inherits VehicleBuildStep:

    constructor public PaintVehicle(input poComponentInfo as IComponentInfo  ):
        super (input poComponentInfo).
    end constructor.

    method override public void PerformStep():
        BodyInWhiteInspection().
        PaintUndercoat().
        PaintFinalCoat().
        BakePaint(). 
    end method.        
    
    method public void BodyInWhiteInspection():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'BodyInWhiteInspection').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'BodyInWhiteInspection').
    end method.
    
    method public void PaintUndercoat():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'PaintUndercoat').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'PaintUndercoat').
    end method.
    
    method public void PaintFinalCoat():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'PaintFinalCoat').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'PaintFinalCoat').
    end method.
    
    method public void BakePaint():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'BakePaint').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'BakePaint').
    end method.
     

end class.