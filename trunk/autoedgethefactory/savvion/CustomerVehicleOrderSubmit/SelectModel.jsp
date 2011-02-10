<!-- bizsolo generate="false" -->
<html xmlns:bizsolo="http://www.savvion.com/sbm/BizSolo" xmlns:sbm="http://www.savvion.com/sbm" xmlns:jsp="http://java.sun.com/JSP/Page" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:sfe="http://www.savvion.com/sbm/sfe" xmlns:c="http://java.sun.com/jstl/core">
<head><META http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.savvion.BizSolo.Server.*,com.savvion.BizSolo.beans.*,java.util.Vector" %>
<%@ page errorPage="/BizSolo/common/jsp/error.jsp" %>
<%@ taglib uri="/BizSolo/common/tlds/bizsolo.tld" prefix="bizsolo" %>
<%@ taglib uri="/bpmportal/tld/bpmportal.tld" prefix="sbm" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sfe" uri="http://jmaki/v1.0/jsp" %>
  <jsp:useBean id="bizManage" class="com.savvion.sbm.bizmanage.api.BizManageBean" scope="session"></jsp:useBean>
  <jsp:useBean id="bean" class="com.savvion.BizSolo.beans.Bean" scope="session"></jsp:useBean>
  <jsp:useBean id="factoryBean" class="com.savvion.BizSolo.beans.EPFactoryBean" scope="session"></jsp:useBean>
  <jsp:useBean id="bizSite" class="com.savvion.sbm.bpmportal.bizsite.api.BizSiteBean" scope="session"></jsp:useBean>
<%! String _PageName = "SelectModel"; %>
<%! String __webAppName = "CustomerVehicleOrderSubmit"; %>
<% pageContext.setAttribute( "contextPath", request.getContextPath()+"/"); %>
<%! java.util.Vector myVector; %>

<title>SelectModel</title>
<!-- Javascript -->
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/initControls.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/customValidation.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/prototype.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/effects.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/scriptaculous.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/pwr.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/engine.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/cal.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/util.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/utilities.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.config.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.core.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.lang-enUS.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.validators.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/pValidate.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/document.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/jscalendar/calendar.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/jscalendar/calendar-en.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/jscalendar/calendar-setup.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>dwr/interface/adapterDWR.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/utilities/utilities.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/container/container-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/connection/connection-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/resize/resize-beta-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/animation/animation-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/json/json-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/logger/logger-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/checkboxvalidation/SpryValidationCheckbox.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/confirmvalidation/SpryValidationConfirm.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/passwordvalidation/SpryValidationPassword.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/radiovalidation/SpryValidationRadio.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/selectvalidation/SpryValidationSelect.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/textareavalidation/SpryValidationTextarea.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/textfieldvalidation/SpryValidationTextField.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry//SpryEffects.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/ext/adapter/ext/ext-base.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/ext/ext-all.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/ext/PagingRowNumberer.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/BmViewport.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/WaitDialog.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/LoggerDialog.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/ResizableDialog.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/FormWidget.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/FormPanel.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/FormWidgetHandler.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/TransactionAjaxObject.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/BusinessObjectHandler.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/sbm.utils.js"></script>
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/fonts/fonts.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/resize/assets/skins/sam/resize.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/container/assets/skins/sam/container.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/logger/assets/skins/sam/logger.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/checkboxvalidation/SpryValidationCheckbox.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/confirmvalidation/SpryValidationConfirm.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/textareavalidation/SpryValidationTextarea.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/passwordvalidation/SpryValidationPassword.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/radiovalidation/SpryValidationRadio.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/selectvalidation/SpryValidationSelect.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/textfieldvalidation/SpryValidationTextField.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/ext/resources/css/ext-all.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/ext/resources/css/xtheme-default.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/css/theme01/bm-all.css">
<script language="JavaScript">
 Ext.BLANK_IMAGE_URL = '<c:out value='${contextPath}'/>bpmportal/javascript/ext/resources/images/default/s.gif';
	 
	  var isIFrame = <%= (PublicResources.INTERACTIVE_MODE.equalsIgnoreCase(bean.getPropString(PublicResources.MODE)) || PublicResources.SLAVE_MODE.equalsIgnoreCase(bean.getPropString(PublicResources.MODE))) ? true : false %>;
	  
<!--
    function AlertReassign()
    {
      if (document.form.elements['bizsite_assigneeName'].value == '' )
      {
        alert('Please provide assignee name!')
        document.form.elements['bizsite_assigneeName'].focus();
        return false;
      }
      else
      {
        return true;
      }
    }
    
    var uploadWnd;
    var param;
 
    function openDocAttWin( slotName,sesID, ptname, piname, docurl, docServer, readonly, ismultiline, appendwith, isStart )
    {
      param = 'bzsid=' + sesID;
      param += '&pt=' + ptname;
      param += '&pi=' + piname;
      param += '&ds=' + slotName;
      param += '&docurl=' + docurl;
      param += '&readonly=' + readonly;
      param += '&ismultiline=' + ismultiline;
      param += '&appendwith=' + appendwith;
      param += '&isPICreation=' + isStart;
      uploadWnd = openDocumentPresentation(docServer + '/BizSite.DocAttacher?' + param, isIFrame);
    }

    function setCheckBoxStyleForIE()
    {
      var isIE = (navigator.appName == "Microsoft Internet Explorer") ? 1 : 0;
      var w_Elements = document.getElementsByTagName("input");
      for ( i=0; i < w_Elements.length; ++i)
      {
          if(isIE && (w_Elements.item(i).getAttribute("type") == "checkbox" || w_Elements.item(i).getAttribute("type") == "radio"))
            w_Elements.item(i).className = "ChkBoxNone";
      }
    }
    
    function onSuccess() {
    }
    
    
   function editDecimal(element,pms,scale)
    {
    if(typeof element == 'string') element = document.getElementById(element);
	var id = element.getAttribute('id');
	if (element != null)
	{
	      var newurl = '<c:out value='${contextPath}'/>bpmportal/common/pop_decimal_dataslot.jsp?elementID=' + id + '&pms=' + pms + '&scale=' + scale + '&value=' + element.value;
	      
        MM_openBrWindow(newurl,'editdecimal','scrollbars=yes,resizable=yes,width=690,height=174');
	}
}
//-->
</script>

<bizsolo:link rel="stylesheet"></bizsolo:link>

<sbm:setLocale value="<%= bizManage.getLocale() %>"></sbm:setLocale>
<% try{ %><sbm:setBundle scope="page" basename="CustomerVehicleOrderSubmit/properties/CustomerVehicleOrderSubmit"></sbm:setBundle><% } catch(Exception e){}%>
</head>
<body class="ApBody yui-skin-sam" onUnload="pwr.removePakBizSoloBeanFromCache('<%=session.getId()%>', onSuccess);" onLoad="setCheckBoxStyleForIE();hideControls();beforeInitControls();initControls();initTabs();sbm.utils.onDOMReady();">
<form method="post" name="form" onsubmit="return sbm.utils.onFormSubmit();">
<div id="northDiv"></div><% /* Workaround, activityName will disappear in the future */ %>
<% String activityName = bean.getPropString("workitemName"); %>
<div id="resultDiv">
<div style='visibility:hidden;display:none' class='vBoxClass' name='errors' id='errors'></div>
<input name="crtPage" type="hidden" value="SelectModel"><input name="crtApp" type="hidden" value="CustomerVehicleOrderSubmit"><input name="activityMode" type="hidden" value="procReq"><input type="hidden" name="nextPage" value="Start.jsp">
<input name="_yahoo_flow_button" type="hidden" value=''>
<!-- Content --> 

    <div align="center">

      <img border="0" id="aetf_logo" width="400" height="69" src="images/aetf_logo.png">
      <br clear="all">
<fieldset id="fsModel">

        <legend>Model Selection</legend>
        <div align="center">

          <font color="#008000" face="Segoe UI" size="4">
            <b>
              <i>Welcome to </i>
            </b>
          </font>
          <font color="#008000" face="Segoe UI" size="4">
            <b>
              <i>
                <Label class="ApSegDataslotLabel" for=""><bizsolo:value name='SelectedVehicleBrand' valueType='label'/></Label>
      
              </i>
            </b>
          </font>
          <font color="#008000" face="Segoe UI" size="4">
            <b>
              <i> motors. </i>
            </b>
          </font>
          <br clear="all">
<font color="#008000" face="Segoe UI" size="4">
            <i>Please select your model</i>
          </font>
        </div>

        <div align="left">

          <br clear="all">
<br clear="all">
<table align="center" cellpadding="5" cellspacing="0" class="(default)" id="tblModels" width="550">
            <thead>
              <tr>
                <th class="(default)" width="137" rowspan="1" colspan="1">
                  <div align="center">

                    <img border="0" id="imgCompact" width="82" height="32" src="images/blue_coupe.gif">
                    <br clear="all">
<font color="#0000ff" face="Segoe UI" size="3">
                      <b>
                        <i>Compact Cars</i>
                      </b>
                    </font>
                  </div>

                </th>
                <th class="(default)" width="137" rowspan="1" colspan="1">
                  <font color="#808080" face="Segoe UI" size="3">
                    <b>
                      <i>Our compact cars turn on a dime, fit in any parking space and are cheap to run.</i>
                    </b>
                  </font>
                </th>
                <th class="(default)" rowspan="1" colspan="1">
                  <div align="center">

                    <img border="0" id="imgPremium" width="82" height="32" src="images/blue_convertible.gif">
                    <br clear="all">
<font color="#0000ff" face="Segoe UI" size="3">
                      <b>
                        <i>Premium &amp; Performance Vehicles</i>
                      </b>
                    </font>
                  </div>

                </th>
                <th class="(default)" width="137" rowspan="1" colspan="1">
                  <font color="#808080" face="Segoe UI" size="3">
                    <b>
                      <i>Top speed, total comfort.</i>
                    </b>
                  </font>
                </th>
              </tr>
              <tr>
                <th class="(default)" colspan="2" width="137" rowspan="1">
                  <div align="center">

                    <select size="5" id="listCompact" style="width:250px; height:75px; " onchange="listCompact_onChange();"><% myVector = (java.util.Vector)bean.getPropVector("VehicleModelsCompact");if(myVector!=null){pageContext.setAttribute("myVector", myVector);%>
<c:forEach var="curr" items="${myVector}">
            <option value="<c:out value='${curr}'/>"><c:out value="${curr}"></c:out></option>
    </c:forEach>
<%} %></select>

                  </div>

                </th>
                <th class="(default)" colspan="2" rowspan="1">
                  <div align="center">

                    <select size="5" id="listPremium" style="width:250px; height:75px; " onchange="listPremium_onChange();"><% myVector = (java.util.Vector)bean.getPropVector("VehicleModelsPremium");if(myVector!=null){pageContext.setAttribute("myVector", myVector);%>
<c:forEach var="curr" items="${myVector}">
            <option value="<c:out value='${curr}'/>"><c:out value="${curr}"></c:out></option>
    </c:forEach>
<%} %></select>

                  </div>

                </th>
              </tr>
              <tr>
                <th class="(default)" width="137" rowspan="1" colspan="1"></th>
                <th class="(default)" width="137" rowspan="1" colspan="1"></th>
                <th class="(default)" rowspan="1" colspan="1"></th>
                <th class="(default)" width="137" rowspan="1" colspan="1"></th>
              </tr>
              <tr>
                <th class="(default)" width="137" rowspan="1" colspan="1">
                  <div align="center">

                    <br clear="all">
<img border="0" id="imgSedan" width="82" height="32" src="images/blue_sedan.gif">
                    <br clear="all">
<font color="#0000ff" face="Segoe UI" size="3">
                      <b>
                        <i>Sedans</i>
                      </b>
                    </font>
                  </div>

                </th>
                <th class="(default)" width="137" rowspan="1" colspan="1">
                  <font color="#808080" face="Segoe UI" size="3">
                    <b>
                      <i>Safety and comfort: our sedans give you the best value for money.</i>
                    </b>
                  </font>
                </th>
                <th class="(default)" rowspan="1" colspan="1">
                  <div align="center">

                    <br clear="all">
<img border="0" id="imgSUV" width="82" height="32" src="images/blue_suv.gif">
                    <br clear="all">
<font color="#0000ff" face="Segoe UI" size="3">
                      <b>
                        <i>Crossovers</i>
                      </b>
                    </font>
                  </div>

                </th>
                <th class="(default)" width="137" rowspan="1" colspan="1">
                  <font color="#808080" face="Segoe UI" size="3">
                    <b>
                      <i>Comfort, visibility, rugged good looks: the best of all worlds</i>
                    </b>
                  </font>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td class="(default)" colspan="2" width="137" rowspan="1" valign="top">
                  <div align="center">

                    <select size="5" id="listSedan" style="width:250px; height:75px; " onchange="listSedan_onChange();"><% myVector = (java.util.Vector)bean.getPropVector("VehicleModelsSedan");if(myVector!=null){pageContext.setAttribute("myVector", myVector);%>
<c:forEach var="curr" items="${myVector}">
            <option value="<c:out value='${curr}'/>"><c:out value="${curr}"></c:out></option>
    </c:forEach>
<%} %></select>

                  </div>

                </td>
                <td class="(default)" colspan="2" rowspan="1" valign="top">
                  <div align="center">

                    <select size="5" id="listSUV" style="width:250px; height:75px; " onchange="listSUV_onChange();"><% myVector = (java.util.Vector)bean.getPropVector("VehicleModelsSUV");if(myVector!=null){pageContext.setAttribute("myVector", myVector);%>
<c:forEach var="curr" items="${myVector}">
            <option value="<c:out value='${curr}'/>"><c:out value="${curr}"></c:out></option>
    </c:forEach>
<%} %></select>

                  </div>

                </td>
              </tr>
              <tr>
                <td class="(default)" width="137" rowspan="1" colspan="1" valign="top"></td>
                <td class="(default)" width="137" rowspan="1" colspan="1" valign="top"></td>
                <td class="(default)" rowspan="1" colspan="1" valign="top"></td>
                <td class="(default)" width="137" rowspan="1" colspan="1" valign="top"></td>
              </tr>
              <tr>
                <td class="(default)" width="137" rowspan="1" colspan="1" valign="top">
                  <div align="center">
</div>

                </td>
                <td class="(default)" width="137" rowspan="1" colspan="1" valign="top">
                  <div align="center">

                    <img border="0" id="imgTruck" width="82" height="32" src="images/blue_truck.gif">
                    <br clear="all">
<font color="#0000ff" face="Segoe UI" size="3">
                      <b>
                        <i>Trucks &amp; Vans</i>
                      </b>
                    </font>
                  </div>

                </td>
                <td class="(default)" rowspan="1" colspan="1" valign="top">
                  <font color="#808080" face="Segoe UI" size="3">
                    <b>
                      <i>Built to last, our trucks and vans won't be beat down.</i>
                    </b>
                  </font>
                </td>
                <td class="(default)" width="137" rowspan="1" colspan="1" valign="top"></td>
              </tr>
              <tr>
                <td class="(default)" colspan="4" width="137" rowspan="1" valign="top">
                  <div align="center">

                    <select size="5" id="listTruck" style="width:250px; height:75px; " onchange="listTruck_onChange();"><% myVector = (java.util.Vector)bean.getPropVector("VehicleModelsTruck");if(myVector!=null){pageContext.setAttribute("myVector", myVector);%>
<c:forEach var="curr" items="${myVector}">
            <option value="<c:out value='${curr}'/>"><c:out value="${curr}"></c:out></option>
    </c:forEach>
<%} %></select>

                  </div>

                </td>
              </tr>
            </tbody>
          </table>
          <br clear="all">
</div>

      </fieldset>

      <div id="div1" class="" style="">
</div>

      <input class="ApInptTxt" type="text" id="txtModel" name="SelectedVehicleModel" size="30" maxlength="256" value="<bizsolo:value name='SelectedVehicleModel'/>">
<script>addHiddenControls("txtModel");</script>    <div style="display:none" id="txtModelError"><div><font color="red"><span class="error" id="txtModelErrorMsg"></span><a href="#" onclick="txtModelErrorMsgClose();return false;"><img border="0" src="<c:out value='${contextPath}'/>bpmportal/css/apptheme01/images/close.gif"></a></font></div></div>
      <br clear="all">


</div>
<!-- Footer -->

<div id="cmdDiv">
<table width="100%" cellpadding="0" align="center" cellspacing="0" border="0">
<tr align="center">
<td class="ApButtonDarkBg" width="63%">
<table border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="ApBtnSpace">
<input type="submit" name="SB_Name" id="btn-complete" class="ApScrnButton" onMouseOver="this.className='ApScrnButtonHover';" onMouseOut="this.className='ApScrnButton';" onClick="clickedButton=this.name;this.onsubmit = new Function('return false');" value="<bizsolo:getLabel name='linkSelectOptions' type='LINK'/>"></td>
<td class="ApBtnSpace">
<input type="button" name="bizsite_reset" id="btn-reset" class="ApScrnButton" onMouseOver="this.className='ApScrnButtonHover';" onMouseOut="this.className='ApScrnButton';" onClick="sbm.utils.reset()" value="<bizsolo:getLabel name='RESET_LABEL' type='RESOURCE'/>"></td>
</tr>
</table>
</td>
</tr>
</table>
</div>

    </div>

  
                    <div id="resizablepanel" style="display:none">
                        <div class="hd">Alert Dialog</div>
                        <div class="bd"></div>
                        <div class="ft"></div>
                    </div> 
</div> 
<div id="southDiv"></div></form>
</body>

<script language="JavaScript">
<!--
function beforeInitControls() {
}
-->
</script>
<script language="JavaScript">
<!--
function userValidationJavascipt() {
  return true;
}
-->
</script>
<sbm:dataSources appName="CustomerVehicleOrderSubmit" appType="bizsolo">
</sbm:dataSources>
<script language="JavaScript">
<!--
    
function listPremium_onChange(eventContext) {
sbm.util.setValue('txtModel',sbm.util.getValue('listPremium'));
{
document.getElementById('listCompact').selectedIndex = -1;
document.getElementById('listSedan').selectedIndex = -1;
document.getElementById('listSUV').selectedIndex = -1;
document.getElementById('listTruck').selectedIndex = -1;;
}
}


function listCompact_onChange(eventContext) {
sbm.util.setValue('txtModel',sbm.util.getValue('listCompact'));
{
document.getElementById('listPremium').selectedIndex = -1;
document.getElementById('listSedan').selectedIndex = -1;
document.getElementById('listSUV').selectedIndex = -1;
document.getElementById('listTruck').selectedIndex = -1;;
}
}


function listSUV_onChange(eventContext) {
sbm.util.setValue('txtModel',sbm.util.getValue('listSUV'));
{
document.getElementById('listCompact').selectedIndex = -1;
document.getElementById('listSedan').selectedIndex = -1;
document.getElementById('listPremium').selectedIndex = -1;
document.getElementById('listTruck').selectedIndex = -1;;
}
}


function cbStyle_onChange(eventContext) {
}


function listSedan_onChange(eventContext) {
sbm.util.setValue('txtModel',sbm.util.getValue('listSedan'));
{
document.getElementById('listCompact').selectedIndex = -1;
document.getElementById('listPremium').selectedIndex = -1;
document.getElementById('listSUV').selectedIndex = -1;
document.getElementById('listTruck').selectedIndex = -1;;
}
}


function listTruck_onChange(eventContext) {
sbm.util.setValue('txtModel',sbm.util.getValue('listTruck'));
{
document.getElementById('listCompact').selectedIndex = -1;
document.getElementById('listSedan').selectedIndex = -1;
document.getElementById('listSUV').selectedIndex = -1;
document.getElementById('listPremium').selectedIndex = -1;;
}
}


  -->
</script>
<!--Initialize extensible widgets.-->
<script language="JavaScript">
<!--
var allWidgets = [];
var businessObjects = [];
var formWidgetHandler;
sbm.utils.onDOMReady = function() {
YAHOO.util.Event.onDOMReady(function(){formWidgetHandler = new FormWidgetHandler(allWidgets);});
}
Ext.onReady(function(){

});
         var viewport = new Bm.util.BmViewport('');
sbm.utils.onFormSubmit = function() {
         if(allWidgets.length > 0 && !formWidgetHandler.validateWidgets()) return false;
        try{
             if(!userValidationJavascipt()) return false;
             if(!sbm.utils.beforeFormSubmit('box+label')) return false;
         }catch(e){}
         document.form.action='<%=response.encodeURL("Start.jsp")%>';
         if(allWidgets.length > 0)formWidgetHandler.saveDataSlots();
         return true;
}
-->
</script>

</html>