namespace SFA.FCT.Performancetests
{
   using System;
   using System.Collections.Generic;
   using System.Text;
   using Microsoft.VisualStudio.TestTools.WebTesting;
   using SFA.FCT.Contracts.AcceptanceTests.Pages;


   [DeploymentItem("performancetests\\DataFiles\\ContractService_test_Data.csv")]
   [DataSource("DataSource1", "Microsoft.VisualStudio.TestTools.DataSource.CSV", "|DataDirectory|\\ContractService_test_Data.csv", Microsoft.VisualStudio.TestTools.WebTesting.DataBindingAccessMethod.Sequential, Microsoft.VisualStudio.TestTools.WebTesting.DataBindingSelectColumns.SelectOnlyBoundColumns, "ContractService_test_Data#csv")]
   [DataBinding("DataSource1", "ContractService_test_Data#csv", "Page_Number", "DataSource1.ContractService_test_Data#csv.Page_Number")]

    public class ContractPublishWebserviceCoded4 : WebTest
    {
      private TestDCFSAtomFeed _pacPageObject;      
         public ContractPublishWebserviceCoded4() 
        {
           this.PreAuthenticate = true;
           this.Proxy = "default";
           _pacPageObject = new TestDCFSAtomFeed();
           ////this.PreWebTest += new EventHandler<PreWebTestEventArgs>(this._pacPageObject.PreWebTest);
           //this.PostWebTest += new EventHandler<PostWebTestEventArgs>(this._pacPageObject.PostWebTest);
           //this.PreTransaction += new EventHandler<PreTransactionEventArgs>(this._pacPageObject.PreTransaction);
           //this.PostTransaction += new EventHandler<PostTransactionEventArgs>(this._pacPageObject.PostTransaction);
           //this.PrePage += new EventHandler<PrePageEventArgs>(this._pacPageObject.PrePage);
           //this.PostPage += new EventHandler<PostPageEventArgs>(this._pacPageObject.PostPage);

           
            //this.PreAuthenticate = true;
            //this.Proxy = "default";
       }

         public override IEnumerator<WebTestRequest> GetRequestEnumerator()
         {
            //this.PreRequestDataBinding += new EventHandler<PreRequestDataBindingEventArgs>(this._pacPageObject.PreRequestDataBinding);
            //this.PreRequest += new EventHandler<PreRequestEventArgs>(this._pacPageObject.PreRequest);

            _pacPageObject.VerifyFeed();
            //this.PostRequest += new EventHandler<PostRequestEventArgs>(this._pacPageObject.PostRequest);
            yield break;
         }
     }
}