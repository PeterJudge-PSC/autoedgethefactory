<!-- bizsolo generate="false" -->
<html xmlns:bizsolo="http://www.savvion.com/sbm/BizSolo" xmlns:sbm="http://www.savvion.com/sbm" xmlns:jsp="http://java.sun.com/JSP/Page" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:sfe="http://www.savvion.com/sbm/sfe" xmlns:c="http://java.sun.com/jstl/core">
<head><META http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.savvion.BizSolo.Server.*,com.savvion.BizSolo.beans.*,java.util.Vector,java.util.Locale" %>
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
<%! String _PageName = "ReviewSelection"; %>
<%! String __webAppName = "CustomerVehicleOrderSubmit"; %>
<% pageContext.setAttribute( "contextPath", request.getContextPath()+"/"); %>

<title>ReviewSelection</title>
<%boolean isStandaloneBS = (bizManage == null || bizManage.getName() == null || "".equals(bizManage.getName()) || bizManage.getLocale() == null);Locale myLocale = (!isStandaloneBS) ? bizManage.getLocale() : request.getLocale();%>
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
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.lang-<%=myLocale.getLanguage()%><%=myLocale.getCountry()%>.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.validators.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/pValidate.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/document.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/jscalendar/calendar.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/jscalendar/calendar-<%=myLocale.getLanguage() %>.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/jscalendar/calendar-setup-<%=myLocale.getLanguage() %>.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>dwr/interface/adapterDWR.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/utilities/utilities.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/container/container-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/connection/connection-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/resize/resize-beta-min.js"></script>
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
<bizsolo:getApplicationResources baseName="CustomerVehicleOrderSubmit/properties/CustomerVehicleOrderSubmit"/></head>
<body class="apbody yui-skin-sam" onUnload="pwr.removePakBizSoloBeanFromCache('<%=session.getId()%>', onSuccess);" onLoad="setCheckBoxStyleForIE();hideControls();beforeInitControls();initControls();initTabs();sbm.utils.onDOMReady();">
<form method="post" name="form" onsubmit="return sbm.utils.onFormSubmit();">
<div id="northDiv"><bizsolo:xsrf/></div><% /* Workaround, activityName will disappear in the future */ %>
<% String activityName = bean.getPropString("workitemName"); %>
<div id="resultDiv">
<div style='visibility:hidden;display:none' class='vBoxClass' name='errors' id='errors'></div>
<input name="crtPage" type="hidden" value="ReviewSelection"><input name="crtApp" type="hidden" value="CustomerVehicleOrderSubmit"><input name="activityMode" type="hidden" value="procReq"><input type="hidden" name="nextPage" value="Start.jsp">
<input name="_yahoo_flow_button" type="hidden" value=''>
<!-- Content --> 

    
      
    
    <div align="center" id="">
      <img border="0" id="imgAETFLogo" width="400" height="69" src="images/aetf_logo.png">
    </div>
    <div align="left" id="">
      <fieldset name="fsReview">
        <legend><sbm:message key="ReviewSelection.fieldset.fsReview.label"></sbm:message></legend>
        <div align="center" id="">
          <font color="#008000" face="Segoe UI" size="4">
            <i>Please review your selections carefully. If you are satisfied with them, select a dealer, and complete the order. Otherwise use your browser's back button to change your selections.</i>
          </font>
        </div>
        <div align="left" id="">
          <br clear="all">
<table align="center" cellpadding="0" cellspacing="0" class="(default)" id="tblSelections" width="100%">
            <tbody>
              <tr>
                <td class="(default)" width="30%" rowspan="1" colspan="1" valign="top">
                  <div align="right" id="">
                    <font color="#808080" face="Segoe UI" size="3">Brand</font>
                  </div>
                </td>
                <td class="(default)" width="5" rowspan="1" colspan="1" valign="top"></td>
                <td class="(default)" width="70%" rowspan="1" colspan="1" valign="top">
                  <sfe:widget name="sbm.textfield" id="txtSelectedBrand" args="{'type':'Label', 'size':32, 'maxlength':50, 'readonly':true, 'disabled':false, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion text field widget.', 'tabOrder':'0'}" />

                </td>
              </tr>
              <tr>
                <td class="(default)" width="30%" rowspan="1" colspan="1" valign="top">
                  <div align="right" id="">
                    <font color="#808080" face="Segoe UI" size="3">Model</font>
                  </div>
                </td>
                <td class="(default)" width="5" rowspan="1" colspan="1" valign="top"></td>
                <td class="(default)" width="70%" rowspan="1" colspan="1" valign="top">
                  <sfe:widget name="sbm.combobox" id="cbSelectedModel" args="{'size':20, 'readonly':true, 'disabled':true, 'cascade':false, 'level':0, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion Combobox widget.', 'tabOrder':'0'}" />

                </td>
              </tr>
              <tr>
                <td class="(default)" width="30%" rowspan="1" colspan="1" valign="top">
                  <div align="right" id="">
                    <font color="#808080" face="Segoe UI" size="3">Exterior Color</font>
                  </div>
                </td>
                <td class="(default)" width="5" rowspan="1" colspan="1" valign="top"></td>
                <td class="(default)" width="70%" rowspan="1" colspan="1" valign="top">
                  <sfe:widget name="sbm.checkbox" id="cbExtColour" args="{'layout':'Horizontal', 'readonly':true, 'disabled':true, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion Checkbox widget.', 'tabOrder':'0'}" />

                </td>
              </tr>
              <tr>
                <td class="(default)" width="30%" rowspan="1" colspan="1" valign="top">
                  <div align="right" id="">
                    <font color="#808080" face="Segoe UI" size="3">Wheels</font>
                  </div>
                </td>
                <td class="(default)" width="5" rowspan="1" colspan="1" valign="top"></td>
                <td class="(default)" width="70%" rowspan="1" colspan="1" valign="top">
                  <sfe:widget name="sbm.checkbox" id="cbSelectedWheels" args="{'layout':'Horizontal', 'readonly':true, 'disabled':true, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion Checkbox widget.', 'tabOrder':'0'}" />

                </td>
              </tr>
              <tr>
                <td class="(default)" width="30%" rowspan="1" colspan="1" valign="top">
                  <div align="right" id="">
                    <font color="#808080" face="Segoe UI" size="3">Moonroof</font>
                  </div>
                </td>
                <td class="(default)" width="5" rowspan="1" colspan="1" valign="top"></td>
                <td class="(default)" width="70%" rowspan="1" colspan="1" valign="top">
                  <sfe:widget name="sbm.checkbox" id="cbSelectedMoonroof" args="{'layout':'Horizontal', 'readonly':true, 'disabled':true, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion Checkbox widget.', 'tabOrder':'0'}" />

                </td>
              </tr>
              <tr>
                <td class="(default)" width="30%" rowspan="1" colspan="1" valign="top">
                  <div align="right" id="">
                    <font color="#808080" face="Segoe UI" size="3">Seat Material</font>
                  </div>
                </td>
                <td class="(default)" width="5" rowspan="1" colspan="1" valign="top"></td>
                <td class="(default)" width="70%" rowspan="1" colspan="1" valign="top">
                  <sfe:widget name="sbm.checkbox" id="cbSelectedSeatMaterial" args="{'layout':'Horizontal', 'readonly':true, 'disabled':true, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion Checkbox widget.', 'tabOrder':'0'}" />

                </td>
              </tr>
              <tr>
                <td class="(default)" width="30%" rowspan="1" colspan="1" valign="top">
                  <div align="right" id="">
                    <font color="#808080" face="Segoe UI" size="3">Interior Trim Color</font>
                  </div>
                </td>
                <td class="(default)" width="5" rowspan="1" colspan="1" valign="top"></td>
                <td class="(default)" width="70%" rowspan="1" colspan="1" valign="top">
                  <sfe:widget name="sbm.checkbox" id="cbSelectedTrim" args="{'layout':'Horizontal', 'readonly':true, 'disabled':true, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion Checkbox widget.', 'tabOrder':'0'}" />

                </td>
              </tr>
              <tr>
                <td class="(default)" width="30%" rowspan="1" colspan="1" valign="top">
                  <div align="right" id="">
                    <font color="#808080" face="Segoe UI" size="3">Accessories</font>
                  </div>
                </td>
                <td class="(default)" width="5" rowspan="1" colspan="1" valign="top"></td>
                <td class="(default)" width="70%" rowspan="1" colspan="1" valign="top">
                  <sfe:widget name="sbm.checkbox" id="cbSelectedAccessories" args="{'layout':'Vertical', 'readonly':false, 'disabled':true, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion Checkbox widget.', 'tabOrder':'0'}" />

                </td>
              </tr>
            </tbody>
          </table>
          <br clear="all">
</div>
      </fieldset>
    </div>
    <div align="center" id="">
      <fieldset name="fsComplete">
        <legend><sbm:message key="ReviewSelection.fieldset.fsComplete.label"></sbm:message></legend>
        <div align="center" id="">
          <font color="#008000" face="Segoe UI" size="4">
            <i>Please select a dealer to arrange for the payment and collection of your new car, and confirm your email address in case we need to contact you.</i>
          </font>
          <br clear="all">
<br clear="all">
<font color="#808080" face="Segoe UI" size="3">Select your dealer </font>
          <sfe:widget name="sbm.combobox" id="cbDealer" args="{'size':5, 'readonly':false, 'disabled':false, 'cascade':true, 'level':0, 'validationType':'none', 'validation':{}, 'toolTip':'', 'tabOrder':'0'}" />

          <br clear="all">
</div>
      </fieldset>
      

</div>
<!-- Footer -->

<div id="cmdDiv">
<table width="100%" cellpadding="0" align="center" cellspacing="0" border="0">
<tr align="center">
<td class="ApButtonDarkBg" width="63%">
<table border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="ApBtnSpace">
<input type="submit" name="SB_Name" id="btn-complete" class="ApScrnButton" onMouseOver="this.className='ApScrnButtonHover';" onMouseOut="this.className='ApScrnButton';" onClick="clickedButton=this.name;this.onsubmit = new Function('return false');" value="<bizsolo:getLabel name='linkCreateOrder' type='LINK'/>"></td>
<td class="ApBtnSpace">
<input type="button" name="bizsite_reset" id="btn-reset" class="ApScrnButton" onMouseOver="this.className='ApScrnButtonHover';" onMouseOut="this.className='ApScrnButton';" onClick="sbm.utils.reset()" value="<bizsolo:getLabel name='RESET_LABEL' type='RESOURCE'/>"></td>
</tr>
</table>
</td>
</tr>
</table>
</div>

    </div>
    <div align="left" id=""></div>
  
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
    
function Form_onLoad(eventContext) {
}


  -->
</script>
<!--Initialize extensible widgets.-->
<script language="JavaScript">
<!--
var allWidgets = [{widget:'txtSelectedBrand', bound:'true', editable:'false', type:'sbm.textfield', source: {type:'DATASLOT', dataSlotName:'SelectedVehicleBrand', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'SelectedVehicleBrand', dataSlotType:'STRING'}, dsType:'STRING', service:'false'},
{widget:'cbSelectedModel', bound:'true', editable:'false', type:'sbm.combobox', source: {type:'DATASLOT', dataSlotName:'SelectedVehicleModel', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'', dataSlotType:''}, dsType:'STRING', service:'false'},
{widget:'cbExtColour', bound:'true', editable:'false', type:'sbm.checkbox', source: {type:'DATASLOT', dataSlotName:'SelectedExtColour', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'', dataSlotType:''}, dsType:'STRING', service:'false'},
{widget:'cbSelectedWheels', bound:'true', editable:'false', type:'sbm.checkbox', source: {type:'DATASLOT', dataSlotName:'SelectedWheels', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'', dataSlotType:''}, dsType:'STRING', service:'false'},
{widget:'cbSelectedMoonroof', bound:'true', editable:'false', type:'sbm.checkbox', source: {type:'DATASLOT', dataSlotName:'SelectedMoonroof', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'', dataSlotType:''}, dsType:'STRING', service:'false'},
{widget:'cbSelectedSeatMaterial', bound:'true', editable:'false', type:'sbm.checkbox', source: {type:'DATASLOT', dataSlotName:'SelectedSeatMaterial', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'', dataSlotType:''}, dsType:'STRING', service:'false'},
{widget:'cbSelectedTrim', bound:'true', editable:'false', type:'sbm.checkbox', source: {type:'DATASLOT', dataSlotName:'SelectedTrimColour', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'', dataSlotType:''}, dsType:'STRING', service:'false'},
{widget:'cbSelectedAccessories', bound:'true', editable:'true', type:'sbm.checkbox', source: {type:'DATASLOT', dataSlotName:'InteriorAccessories', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'', dataSlotType:''}, dsType:'STRING', service:'false'},
{widget:'cbDealer', bound:'true', editable:'true', type:'sbm.combobox', source: {type:'DATASLOT', dataSlotName:'DealerName', dataSlotType:''}, target:{type:'DATASLOT', dataSlotName:'DealerCode', dataSlotType:'STRING'}, dsType:'STRING', service:'false'}
];
var businessObjects = [];
var formWidgetHandler;
sbm.utils.onDOMReady = function() {
YAHOO.util.Event.onDOMReady(function(){
formWidgetHandler = new FormWidgetHandler(allWidgets,{processName:');CustomerVehicleOrderSubmit',adapletCache:{'user':'' }});
Form_onLoad();
 });
 }
Ext.onReady(function(){

});
         var viewport = new Bm.util.BmViewport('');
sbm.utils.onFormSubmit = function() {
         if(!formWidgetHandler.validateWidgets()) return false;
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