//------------------------------------------------------------------------------
// 
//     Runtime Version:4.0.30319.34209
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
//------------------------------------------------------------------------------

namespace SFA.FCT.PerformanceTests{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using Microsoft.VisualStudio.TestTools.WebTesting;
    using Microsoft.VisualStudio.TestTools.WebTesting.Rules;
    using System.Diagnostics;
    
    
    [DeploymentItem("PerftestCRM\\Performance test Data.csv", "PerftestCRM")]
    [DataSource("DataSource1", "Microsoft.VisualStudio.TestTools.DataSource.CSV", "|DataDirectory|\\PerftestCRM\\Performance test Data.csv", Microsoft.VisualStudio.TestTools.WebTesting.DataBindingAccessMethod.Unique, Microsoft.VisualStudio.TestTools.WebTesting.DataBindingSelectColumns.SelectOnlyBoundColumns, "Performance test Data#csv")]
    [DataBinding("DataSource1", "Performance test Data#csv", "UserID", "DataSource1.Performance test Data#csv.UserID")]
    [DataBinding("DataSource1", "Performance test Data#csv", "Password", "DataSource1.Performance test Data#csv.Password")]
    
    public class CRMBrowseCoded : WebTest {
      
    
        public CRMBrowseCoded() {
            //this.Context.Add("WebServer1", "http://fct-crm-dev-01.cloudapp.net");
            this.Context.Add("WebServer1", CommonConfigurationParameters.CrmUrl());
            this.PreAuthenticate = true;
            this.Proxy = "default";
        }
        
        public override IEnumerator<WebTestRequest> GetRequestEnumerator() {
            this.UserName = this.Context["DataSource1.Performance test Data#csv.UserID"].ToString();
            this.Password = this.Context["DataSource1.Performance test Data#csv.Password"].ToString();
            // Initialize validation rules that apply to all requests in the WebTest
            if ((this.Context.ValidationLevel >= Microsoft.VisualStudio.TestTools.WebTesting.ValidationLevel.Low)) {
                ValidateResponseUrl validationRule1 = new ValidateResponseUrl();
                this.ValidateResponse += new EventHandler<ValidationEventArgs>(validationRule1.Validate);
            }
            if ((this.Context.ValidationLevel >= Microsoft.VisualStudio.TestTools.WebTesting.ValidationLevel.Low)) {
                ValidationRuleResponseTimeGoal validationRule2 = new ValidationRuleResponseTimeGoal();
                validationRule2.Tolerance = 0D;
                this.ValidateResponseOnPageComplete += new EventHandler<ValidationEventArgs>(validationRule2.Validate);
            }
            Debug.WriteLine("In CRMBRowseCoded. CrmUrl is  ...\n" + CommonConfigurationParameters.CrmUrl());
           
            this.BeginTransaction("Login");

            //(this.Context["WebServer1"].ToString() + "
            //WebTestRequest request6 = new WebTestRequest("http://fct-crm-dev-01.cloudapp.net/fctdev/main.aspx")); 
            WebTestRequest request6 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/fctdev/main.aspx"));
            request6.ThinkTime = 10;
            request6.ExpectedResponseUrl = (this.Context["WebServer1"].ToString() + "/fctdev/main.aspx#319924894");
            WebTestRequest request6Dependent1 = new WebTestRequest("http://rapport.trusteer.com/rapport/ping");
            request6Dependent1.ThinkTime = 10;
            request6Dependent1.QueryStringParameters.Add("ak", "6C51B6024C26DCFD2CC8521B6F0F15B19E1A21774BF5FA9FC11AC7A354AAC5E7", false, false);
            request6Dependent1.QueryStringParameters.Add("ubv", "3.5.1404.61-standard-release", false, false);
            request6Dependent1.QueryStringParameters.Add("t", "2d443afe", false, false);
            request6Dependent1.QueryStringParameters.Add("m", "RapportKoan", false, false);
            request6.DependentRequests.Add(request6Dependent1);
            yield return request6;
            request6 = null;

            WebTestRequest request7 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/workplace/home_dashboards.aspx"));
            request7.QueryStringParameters.Add("pagemode", "iframe", false, false);
            request7.QueryStringParameters.Add("sitemappath", "SFA%7cExtensions%7cnav_dashboards", false, false);
            yield return request7;
            request7 = null;

            WebTestRequest request8 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/_forms/navtour/dlg_navtour.aspx"));
            request8.ThinkTime = 10;
            yield return request8;
            request8 = null;

            WebTestRequest request9 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/fctdev/main.aspx"));
            request9.ExpectedResponseUrl = (this.Context["WebServer1"].ToString() + "/fctdev/main.aspx#906586960");
            yield return request9;
            request9 = null;

            WebTestRequest request10 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/dashboards/dashboard.aspx"));
            request10.QueryStringParameters.Add("dashboardId", "%7be3f25b25-2260-e411-93f7-000d3ab03a58%7d", false, false);
            request10.QueryStringParameters.Add("dashboardType", "1030", false, false);
            request10.QueryStringParameters.Add("pagemode", "iframe", false, false);
            yield return request10;
            request10 = null;
      
            this.EndTransaction("Login");
 

            this.BeginTransaction("View_Contracts");

            WebTestRequest request1 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/_root/homepage.aspx"));
            request1.ThinkTime = 10;
            request1.QueryStringParameters.Add("etc", "10005", false, false);
            request1.QueryStringParameters.Add("pagemode", "iframe", false, false);
            request1.QueryStringParameters.Add("sitemappath", "SFA%7cExtensions%7csfa_contract", false, false);
            yield return request1;
            request1 = null;

            this.EndTransaction("View_Contracts");

            this.BeginTransaction("View_Caseloads");

            WebTestRequest request2 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/_root/homepage.aspx"));
            request2.ThinkTime = 10;
            request2.QueryStringParameters.Add("etc", "10013", false, false);
            request2.QueryStringParameters.Add("pagemode", "iframe", false, false);
            request2.QueryStringParameters.Add("sitemappath", "SFA%7cExtensions%7csfa_caseload", false, false);
            yield return request2;
            request2 = null;

            this.EndTransaction("View_Caseloads");

            this.BeginTransaction("view_Notifications");

            WebTestRequest request3 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/_root/homepage.aspx"));
            request3.ThinkTime = 10;
            request3.QueryStringParameters.Add("etc", "10020", false, false);
            request3.QueryStringParameters.Add("pagemode", "iframe", false, false);
            request3.QueryStringParameters.Add("sitemappath", "SFA%7cExtensions%7csfa_notification", false, false);
            yield return request3;
            request3 = null;

            this.EndTransaction("view_Notifications");

            WebTestRequest request4 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/fctdev/main.aspx"));
            request4.ThinkTime = 10;
            request4.ExpectedResponseUrl = (this.Context["WebServer1"].ToString() + "/fctdev/main.aspx#250690590");
            yield return request4;
            request4 = null;

            //this.BeginTransaction("view_Visualisation");

            //WebTestRequest request5 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/Visualization/visualization.aspx"));
            //request5.ThinkTime = 10;
            //request5.Method = "POST";
            //request5.QueryStringParameters.Add("uniqueId", "0.029027136976824633AF73677-C596-E411-93FB-000D3AB03A58", false, false);
            //FormPostHttpBody request5Body = new FormPostHttpBody();
            //request5Body.FormPostParameters.Add("vizXml", "<vizXml><filterFetchXml>&#60;fetch distinct&#61;&#34;false&#34; no-lock&#61;&#34;" +
            //        "false&#34; mapping&#61;&#34;logical&#34; page&#61;&#34;1&#34; count&#61;&#34;50&" +
            //        "#34; returntotalrecordcount&#61;&#34;true&#34;&#62;&#60;entity name&#61;&#34;sfa" +
            //        "_notification&#34;&#62;&#60;attribute name&#61;&#34;statuscode&#34; &#47;&#62;&#" +
            //        "60;attribute name&#61;&#34;ownerid&#34; &#47;&#62;&#60;attribute name&#61;&#34;s" +
            //        "fa_notificationtype&#34; &#47;&#62;&#60;attribute name&#61;&#34;sfa_notification" +
            //        "&#34; &#47;&#62;&#60;attribute name&#61;&#34;createdon&#34; &#47;&#62;&#60;attri" +
            //        "bute name&#61;&#34;sfa_link&#34; &#47;&#62;&#60;attribute name&#61;&#34;sfa_noti" +
            //        "ficationid&#34; &#47;&#62;&#60;attribute name&#61;&#34;createdon&#34; &#47;&#62;" +
            //        "&#60;attribute name&#61;&#34;sfa_notificationtype&#34; &#47;&#62;&#60;attribute " +
            //        "name&#61;&#34;sfa_link&#34; &#47;&#62;&#60;attribute name&#61;&#34;sfa_notificat" +
            //        "ion&#34; &#47;&#62;&#60;attribute name&#61;&#34;ownerid&#34; &#47;&#62;&#60;attr" +
            //        "ibute name&#61;&#34;statuscode&#34; &#47;&#62;&#60;filter type&#61;&#34;and&#34;" +
            //        "&#62;&#60;condition attribute&#61;&#34;statecode&#34; operator&#61;&#34;eq&#34; " +
            //        "value&#61;&#34;0&#34; &#47;&#62;&#60;&#47;filter&#62;&#60;order attribute&#61;&#" +
            //        "34;createdon&#34; descending&#61;&#34;true&#34; &#47;&#62;&#60;&#47;entity&#62;&" +
            //        "#60;&#47;fetch&#62;</filterFetchXml><visualizationId>&#123;3AF73677-C596-E411-93" +
            //        "FB-000D3AB03A58&#125;</visualizationId><viewid>&#123;08EC53B2-B3C8-4DB1-916E-FCB" +
            //        "73007FC77&#125;</viewid><viewtype>1039</viewtype><visType>1111</visType><layoutS" +
            //        "ize>1</layoutSize><paneContentWidth>318</paneContentWidth><paneContentHeight>343" +
            //        "</paneContentHeight><ShowChartPicker>true</ShowChartPicker><ie-browser-version>1" +
            //        "0</ie-browser-version><layoutXml>&#60;grid name&#61;&#34;resultset&#34; object&#" +
            //        "61;&#34;10020&#34; jump&#61;&#34;sfa_name&#34; select&#61;&#34;1&#34; icon&#61;&" +
            //        "#34;1&#34; preview&#61;&#34;1&#34;&#62;&#60;row name&#61;&#34;result&#34; id&#61" +
            //        ";&#34;sfa_notificationid&#34;&#62;&#60;cell name&#61;&#34;createdon&#34; width&#" +
            //        "61;&#34;100&#34;&#47;&#62;&#60;cell name&#61;&#34;sfa_notificationtype&#34; widt" +
            //        "h&#61;&#34;125&#34;&#47;&#62;&#60;cell name&#61;&#34;sfa_link&#34; width&#61;&#3" +
            //        "4;50&#34;&#47;&#62;&#60;cell name&#61;&#34;sfa_notification&#34; width&#61;&#34;" +
            //        "300&#34; disableSorting&#61;&#34;1&#34;&#47;&#62;&#60;cell name&#61;&#34;ownerid" +
            //        "&#34; width&#61;&#34;100&#34;&#47;&#62;&#60;cell name&#61;&#34;statuscode&#34; w" +
            //        "idth&#61;&#34;100&#34;&#47;&#62;&#60;&#47;row&#62;&#60;&#47;grid&#62;</layoutXml" +
            //        "></vizXml>");
            //request5.Body = request5Body;
            //yield return request5;
            //request5 = null;
            
            //this.EndTransaction("view_Notifications");
            


            //WebTestRequest request11 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/_root/homepage.aspx"));
            //request11.ThinkTime = 10;
            //request11.QueryStringParameters.Add("etc", "10005", false, false);
            //request11.QueryStringParameters.Add("pagemode", "iframe", false, false);
            //request11.QueryStringParameters.Add("sitemappath", "SFA%7cExtensions%7csfa_contract", false, false);
            //yield return request11;
            //request11 = null;

//            WebTestRequest request12 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/_static/blank.htm"));
//            request12.ThinkTime = 10;
//            yield return request12;
//            request12 = null;

            //WebTestRequest request13 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/_root/homepage.aspx"));
            //request13.ThinkTime = 10;
            //request13.QueryStringParameters.Add("etc", "10013", false, false);
            //request13.QueryStringParameters.Add("pagemode", "iframe", false, false);
            //request13.QueryStringParameters.Add("sitemappath", "SFA%7cExtensions%7csfa_caseload", false, false);
            //yield return request13;
            //request13 = null;

            //WebTestRequest request14 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/_root/homepage.aspx"));
            //request14.QueryStringParameters.Add("etc", "10020", false, false);
            //request14.QueryStringParameters.Add("pagemode", "iframe", false, false);
            //request14.QueryStringParameters.Add("sitemappath", "SFA%7cExtensions%7csfa_notification", false, false);
            //yield return request14;
            //request14 = null;

            //WebTestRequest request15 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/_static/blank.htm"));
            //request15.ThinkTime = 10;
            //yield return request15;
            //request15 = null;


            //WebTestRequest request16 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/fctdev/main.aspx"));
            //request16.ThinkTime = 10;
            //request16.ExpectedResponseUrl = (this.Context["WebServer1"].ToString() + "/fctdev/main.aspx#768916516");
            //yield return request16;
            //request16 = null;


            //WebTestRequest request17 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/_root/homepage.aspx"));
            //request17.ThinkTime = 10;
            //request17.QueryStringParameters.Add("etc", "4212", false, false);
            //request17.QueryStringParameters.Add("pagemode", "iframe", false, false);
            //request17.QueryStringParameters.Add("sitemappath", "SFA%7cMyWork%7cnav_Tasks", false, false);
            //yield return request17;
            //request17 = null;

            //WebTestRequest request18 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/workplace/home_calendar.aspx"));
            //request18.QueryStringParameters.Add("pagemode", "iframe", false, false);
            //request18.QueryStringParameters.Add("sitemappath", "SFA%7cTools%7cnav_calendar", false, false);
            //yield return request18;
            //request18 = null;

            //WebTestRequest request19 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/FCTDev/calendar/Day.aspx"));
            //request19.ThinkTime = 10;
            //request19.QueryStringParameters.Add("date", "2015-01-26T15%3a10%3a29", false, false);
            //yield return request19;
            //request19 = null;
/*
            WebTestRequest request20 = new WebTestRequest((this.Context["WebServer1"].ToString() + "/fctdev/main.aspx"));
            request20.ExpectedResponseUrl = (this.Context["WebServer1"].ToString() + "/fctdev/main.aspx#401796149");
            yield return request20;
            request20 = null;
 */
        }
    }
}
