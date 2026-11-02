namespace SFA.FCT.Performancetests
{
   using System;
   using System.Configuration;
   using System.Collections.Generic;
   using System.Text;
   using Microsoft.VisualStudio.TestTools.WebTesting;
   using SFA.FCT.Contracts.AcceptanceTests.Pages;
   using SFA.FCT.Contracts.AcceptanceTests.Utils;


   public class PluginPublishApprovedContracts : WebTest
   {

      private PublishApprovedContractPageObject testPluginPACP = new PublishApprovedContractPageObject();

      public PluginPublishApprovedContracts()
      {
         this.PreAuthenticate = true;
         this.Proxy = "default";
         this.PreWebTest += new EventHandler<PreWebTestEventArgs>(this.testPluginPACP.PreWebTest);
         ConfigurationManager.RefreshSection("AppSettings");
         this.Context.Add("AadInstance", ConfigurationManager.AppSettings["ida:AADInstance_ContractPublish"]);
         string Tenant = ConfigurationManager.AppSettings["ida:Tenant_ContractPublish"];
         string ClientId = ConfigurationManager.AppSettings["ida:ClientId_ContractPublish"];
         string AppKey = ConfigurationManager.AppSettings["ida:AppKey_ContractPublish"];
         string ResourceId = ConfigurationManager.AppSettings["ResourceId_ContractPublish"];
         this.PostWebTest += new EventHandler<PostWebTestEventArgs>(this.testPluginPACP.PostWebTest);
         this.PreTransaction += new EventHandler<PreTransactionEventArgs>(this.testPluginPACP.PreTransaction);
         this.PostTransaction += new EventHandler<PostTransactionEventArgs>(this.testPluginPACP.PostTransaction);
         this.PrePage += new EventHandler<PrePageEventArgs>(this.testPluginPACP.PrePage);
         this.PostPage += new EventHandler<PostPageEventArgs>(this.testPluginPACP.PostPage);
      }

      public override IEnumerator<WebTestRequest> GetRequestEnumerator()
      {
         this.PreRequestDataBinding += new EventHandler<PreRequestDataBindingEventArgs>(this.testPluginPACP.PreRequestDataBinding);
         this.PreRequest += new EventHandler<PreRequestEventArgs>(this.testPluginPACP.PreRequest);
         //testPluginPACP.
         testPluginPACP.VerifyFeed();
         this.PostRequest += new EventHandler<PostRequestEventArgs>(this.testPluginPACP.PostRequest);
         yield break;
      }
   }
}