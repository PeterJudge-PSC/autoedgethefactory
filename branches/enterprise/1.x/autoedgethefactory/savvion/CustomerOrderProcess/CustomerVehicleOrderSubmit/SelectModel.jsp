<!-- bizsolo generate="false" -->
<html xmlns:bizsolo="http://www.savvion.com/sbm/BizSolo" xmlns:sbm="http://www.savvion.com/sbm" xmlns:jsp="http://java.sun.com/JSP/Page" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:sfe="http://www.savvion.com/sbm/sfe" xmlns:c="http://java.sun.com/jsp/jstl/core">
<head><META http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.savvion.BizSolo.Server.*,com.savvion.BizSolo.beans.*,com.savvion.sbm.util.DatabaseMapping,java.util.Vector,java.util.Locale" %>
<%@ page errorPage="/BizSolo/common/jsp/error.jsp" %>
<%@ taglib uri="/BizSolo/common/tlds/bizsolo.tld" prefix="bizsolo" %>
<%@ taglib uri="/bpmportal/tld/bpmportal.tld" prefix="sbm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sfe" uri="http://jmaki/v1.0/jsp" %>
<%@ include file="/BizSolo/common/jsp/include_i18n_msgs.jsp" %>
  <jsp:useBean id="bizManage" class="com.savvion.sbm.bizmanage.api.BizManageBean" scope="session"></jsp:useBean>
  <jsp:useBean id="bean" class="com.savvion.BizSolo.beans.Bean" scope="session"></jsp:useBean>
  <jsp:useBean id="factoryBean" class="com.savvion.BizSolo.beans.EPFactoryBean" scope="session"></jsp:useBean>
  <jsp:useBean id="bizSite" class="com.savvion.sbm.bpmportal.bizsite.api.BizSiteBean" scope="session"></jsp:useBean>
<%! String _PageName = "SelectModel"; %>
<%! String __webAppName = "CustomerVehicleOrderSubmit"; %>
<% pageContext.setAttribute( "contextPath", request.getContextPath()+"/"); %>
<% pageContext.setAttribute( "maxMulitLineLength", DatabaseMapping.self().getSQLSize(java.lang.String.class));  %>

<title>SelectModel</title>
<%boolean isStandaloneBS = (bizManage == null || bizManage.getName() == null || "".equals(bizManage.getName()) || bizManage.getLocale() == null);Locale myLocale = (!isStandaloneBS) ? bizManage.getLocale() : request.getLocale();%>
<!-- Javascript -->
<script language="JavaScript"> var getLocalizedString = parent.getLocalizedString; </script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/initControls.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/customValidation.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/prototype.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/effects.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/scriptaculous.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/pwr.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>dwr/engine.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/cal.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>dwr/util.js"></script>
<script>DWREngine = dwr.engine; DWRUtil = dwr.util;</script><script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/utilities.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.config.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.core.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.lang-<%=myLocale.getLanguage()%><%=myLocale.getCountry()%>.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.validators.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.validators-<%=myLocale.getLanguage()%><%=myLocale.getCountry()%>.js"></script>
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
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/ux/fileuploadfield/FileUploadField.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/bm/common/bmfield.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fileupload.js"></script>
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
<bizsolo:link rel="stylesheet"></bizsolo:link>
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/css/<%= bizManage.getTheme() %>/bm-all.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/css/<%= bizManage.getTheme() %>/bm-xml.css">
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



<sbm:setLocale value="<%= bizManage.getLocale() %>"></sbm:setLocale>
<% try{ %><sbm:setBundle scope="page" basename="CustomerVehicleOrderSubmit/properties/CustomerVehicleOrderSubmit"></sbm:setBundle><% } catch(Exception e){}%>
<bizsolo:getApplicationResources baseName="CustomerVehicleOrderSubmit/properties/CustomerVehicleOrderSubmit"/></head>
<body class="apbody yui-skin-sam" onUnload="pwr.removePakBizSoloBeanFromCache('<%=session.getId()%>', onSuccess);" onLoad="setCheckBoxStyleForIE();hideControls();beforeInitControls();initControls();initTabs();sbm.utils.onDOMReady();">
<form method="post" name="form" onsubmit="return sbm.utils.onFormSubmit();">
<div id="northDiv"><bizsolo:xsrf/></div><% /* Workaround, activityName will disappear in the future */ %>
<% String activityName = bean.getPropString("workitemName"); %>
<div id="resultDiv">
<div style='visibility:hidden;display:none' class='vBoxClass' name='errors' id='errors'></div>
<input name="crtPage" type="hidden" value="SelectModel"><input name="crtApp" type="hidden" value="CustomerVehicleOrderSubmit"><input name="activityMode" type="hidden" value="procReq"><input type="hidden" name="nextPage" value="Start.jsp">
<input name="_yahoo_flow_button" type="hidden" value=''>
<!-- Content --> 

    
      
    
    <div align="center" id="">
      <img border="0" id="imgAETFLogo" width="400" height="69" src="images/aetf_logo.png">
      <br clear="all">
<br clear="all">
<br clear="all">
<div id="div1" name="div1">
        <div align="center" id="">
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
              <i> Motors</i>
            </b>
          </font>
          <br clear="all">
<font color="#008000" face="Segoe UI" size="4">
            <i>Please select your model</i>
          </font>
        </div>
        <div align="left" id="">
          <br clear="all">
<table align="center" cellpadding="5" cellspacing="0" class="(default)" id="tblModels" width="550">
            <thead>
              <tr>
                <th class="(default)" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <img border="0" id="imgCompact" width="82" height="32" src="images/blue_coupe.gif">
                    <br clear="all">
<font color="#0000ff" face="Segoe UI" size="3">
                      <b>
                        <i>Compact Cars</i>
                      </b>
                    </font>
                  </div>
                </th>
                <th class="(default)" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <img border="0" id="imgSedan" width="82" height="32" src="images/blue_sedan.gif">
                    <br clear="all">
<font color="#0000ff" face="Segoe UI" size="3">
                      <b>
                        <i>Sedans</i>
                      </b>
                    </font>
                  </div>
                </th>
                <th class="(default)" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <img border="0" id="imgPremium" width="82" height="32" src="images/blue_convertible.gif">
                    <br clear="all">
<font color="#0000ff" face="Segoe UI" size="3">
                      <b>
                        <i>Premium &amp; Performance Vehicles</i>
                      </b>
                    </font>
                  </div>
                </th>
                <th class="(default)" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <img border="0" id="imgSUV" width="82" height="32" src="images/blue_suv.gif">
                    <br clear="all">
<font color="#0000ff" face="Segoe UI" size="3">
                      <b>
                        <i>Crossovers</i>
                      </b>
                    </font>
                  </div>
                </th>
                <th class="(default)" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <img border="0" id="imgTruck" width="82" height="32" src="images/blue_truck.gif">
                    <br clear="all">
<font color="#0000ff" face="Segoe UI" size="3">
                      <b>
                        <i>Trucks &amp; Vans</i>
                      </b>
                    </font>
                  </div>
                </th>
              </tr>
              <tr>
                <th class="(default)" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <font color="#808080" face="Segoe UI" size="2">
                      <b>
                        <i>Our compact cars turn on a dime, fit in any parking space and are cheap to run.</i>
                      </b>
                    </font>
                  </div>
                </th>
                <th class="(default)" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <font color="#808080" face="Segoe UI" size="2">
                      <b>
                        <i>Safety and comfort: our sedans give you the best value for money.</i>
                      </b>
                    </font>
                  </div>
                </th>
                <th class="(default)" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <font color="#808080" face="Segoe UI" size="2">
                      <b>
                        <i>Top speed, total comfort.</i>
                      </b>
                    </font>
                  </div>
                </th>
                <th class="(default)" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <font color="#808080" face="Segoe UI" size="2">
                      <b>
                        <i>Comfort, visibility, rugged good looks: the best of all worlds</i>
                      </b>
                    </font>
                  </div>
                </th>
                <th class="(default)" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <font color="#808080" face="Segoe UI" size="2">
                      <b>
                        <i>Built to last, our trucks and vans won't be beat down.</i>
                      </b>
                    </font>
                  </div>
                </th>
              </tr>
              <tr>
                <th class="ApInptRadio" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <sfe:widget name="sbm.radio" id="uxCompactModels" args="{'layout':'Vertical', 'readonly':false, 'disabled':false, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion Radio widget.'}" />
<script language="javascript">
<!--
jmaki.subscribe("/sbm/radio/onChange", function(args){if(args.widgetId=='uxCompactModels'){uxCompactModels_onChange(args);}});

-->
</script>
                  </div>
                </th>
                <th class="ApInptRadio" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <sfe:widget name="sbm.radio" id="uxSedanModels" args="{'layout':'Vertical', 'readonly':false, 'disabled':false, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion Radio widget.'}" />
<script language="javascript">
<!--
jmaki.subscribe("/sbm/radio/onChange", function(args){if(args.widgetId=='uxSedanModels'){uxSedanModels_onChange(args);}});

-->
</script>
                  </div>
                </th>
                <th class="ApInptRadio" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <sfe:widget name="sbm.radio" id="uxPremiumModels" args="{'layout':'Vertical', 'readonly':false, 'disabled':false, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion Radio widget.'}" />
<script language="javascript">
<!--
jmaki.subscribe("/sbm/radio/onChange", function(args){if(args.widgetId=='uxPremiumModels'){uxPremiumModels_onChange(args);}});

-->
</script>
                  </div>
                </th>
                <th class="ApInptRadio" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <sfe:widget name="sbm.radio" id="uxSUVModels" args="{'layout':'Vertical', 'readonly':false, 'disabled':false, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion Radio widget.'}" />
<script language="javascript">
<!--
jmaki.subscribe("/sbm/radio/onChange", function(args){if(args.widgetId=='uxSUVModels'){uxSUVModels_onChange(args);}});

-->
</script>
                  </div>
                </th>
                <th class="ApInptRadio" width="110" rowspan="1" colspan="1">
                  <div align="center" id="">
                    <sfe:widget name="sbm.radio" id="uxTruckModels" args="{'layout':'Vertical', 'readonly':false, 'disabled':false, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion Radio widget.'}" />
<script language="javascript">
<!--
jmaki.subscribe("/sbm/radio/onChange", function(args){if(args.widgetId=='uxTruckModels'){uxTruckModels_onChange(args);}});

-->
</script>
                  </div>
                </th>
              </tr>
            </thead>
          </table>
          <br clear="all">
<br clear="all">
</div>
      </div>
      

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

      <sfe:widget name="sbm.textfield" id="txtModel" args="{'type':'text', 'size':32, 'maxlength':50, 'readonly':false, 'disabled':false, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion text field widget.'}" />

      <sfe:widget name="sbm.textfield" id="txtModelName" args="{'type':'text', 'size':32, 'maxlength':50, 'readonly':false, 'disabled':false, 'required':false, 'validationType':'none', 'validation':{}, 'toolTip':'Savvion text field widget.', 'tabOrder':'0'}" />

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
// Sets the value of the ModelName dataslot via a field
function assignModelName (srcModel) {
  var s = sbm.widgets.getValue(srcModel);
  var obj = eval(s);

  for(var i = 0; i < obj.length; i++) {
    var e = obj[i];
    if (e.selected) {sbm.widgets.setValue('txtModelName', e.label);}
  }
}

function clearOtherSelections (selectedModel) {
  if (selectedModel !== 'uxCompactModels') {document.getElementById('uxCompactModels').selectedIndex = -1;}
  if (selectedModel !== 'uxSedanModels') {document.getElementById('uxSedanModels').selectedIndex = -1;}
  if (selectedModel !== 'uxSUVModels') {document.getElementById('uxSUVModels').selectedIndex = -1;}
  if (selectedModel !== 'uxTruckModels') {document.getElementById('uxTruckModels').selectedIndex = -1;}
  if (selectedModel !== 'uxPremiumModels') {document.getElementById('uxPremiumModels').selectedIndex = -1;}
}

function uxTruckModels_onChange(eventContext) {
sbm.widgets.setValue('txtModel',sbm.widgets.getValue('uxTruckModels'));
{
clearOtherSelections('uxTruckModels');
assignModelName('uxTruckModels');;
}
}


function onLoad(eventContext) {
{
sbm.util.hide('txtModel');
sbm.util.hide('txtModelName');;
}
}


function uxSUVModels_onChange(eventContext) {
sbm.widgets.setValue('txtModel',sbm.widgets.getValue('uxSUVModels'));
{
clearOtherSelections('uxSUVModels');
assignModelName('uxSUVModels');;
}
}


function uxCompactModels_onChange(eventContext) {
sbm.widgets.setValue('txtModel',sbm.widgets.getValue('uxCompactModels'));
{
clearOtherSelections('uxCompactModels');
assignModelName('uxCompactModels');;
}
}


function uxSedanModels_onChange(eventContext) {
sbm.widgets.setValue('txtModel',sbm.widgets.getValue('uxSedanModels'));
{
clearOtherSelections('uxSedanModels');
assignModelName('uxSedanModels');;
}
}


function uxPremiumModels_onChange(eventContext) {
sbm.widgets.setValue('txtModel',sbm.widgets.getValue('uxPremiumModels'));
{
clearOtherSelections('uxPremiumModels');
assignModelName('uxPremiumModels');;
}
}

-->
</script>
<!--Initialize extensible widgets.-->
<script language="JavaScript">
<!--
var allWidgets = [{widget:'uxCompactModels', bound:'true', editable:'true', type:'sbm.radio', source: {type:'DATASLOT', dataSlotName:'CompactModels', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'CompactModels', dataSlotType:'STRING'}, dsType:'STRING', service:'false'},
{widget:'uxSedanModels', bound:'true', editable:'true', type:'sbm.radio', source: {type:'DATASLOT', dataSlotName:'SedanModels', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'SedanModels', dataSlotType:'STRING'}, dsType:'STRING', service:'false'},
{widget:'uxPremiumModels', bound:'true', editable:'true', type:'sbm.radio', source: {type:'DATASLOT', dataSlotName:'PremiumModels', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'PremiumModels', dataSlotType:'STRING'}, dsType:'STRING', service:'false'},
{widget:'uxSUVModels', bound:'true', editable:'true', type:'sbm.radio', source: {type:'DATASLOT', dataSlotName:'SUVModels', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'SUVModels', dataSlotType:'STRING'}, dsType:'STRING', service:'false'},
{widget:'uxTruckModels', bound:'true', editable:'true', type:'sbm.radio', source: {type:'DATASLOT', dataSlotName:'TruckModels', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'TruckModels', dataSlotType:'STRING'}, dsType:'STRING', service:'false'},
{widget:'txtModel', bound:'true', editable:'true', type:'sbm.textfield', source: {type:'DATASLOT', dataSlotName:'SelectedVehicleModel', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'SelectedVehicleModel', dataSlotType:'STRING'}, dsType:'STRING', service:'false'},
{widget:'txtModelName', bound:'true', editable:'true', type:'sbm.textfield', source: {type:'DATASLOT', dataSlotName:'ModelName', dataSlotType:'STRING'}, target:{type:'DATASLOT', dataSlotName:'ModelName', dataSlotType:'STRING'}, dsType:'STRING', service:'false'}
];
var businessObjects = [];
var formWidgetHandler;
sbm.utils.onDOMReady = function() {
YAHOO.util.Event.onDOMReady(function(){
formWidgetHandler = new FormWidgetHandler(allWidgets,{processName:');CustomerVehicleOrderSubmit',adapletCache:{'user':'' }});
onLoad();
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
         }catch(e){return false;}
         document.form.action='<%=response.encodeURL("Start.jsp")%>';
         if(allWidgets.length > 0)formWidgetHandler.saveDataSlots();
         return true;
}
-->
</script>

</html>