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

    public class DWHPublishWebserviceCoded : WebTest
    {
      private TestDWHAtomFeed _pacPageObject;
      public DWHPublishWebserviceCoded() 
        {
           this.PreAuthenticate = true;
           this.Proxy = "default";
           _pacPageObject = new TestDWHAtomFeed();
           _Task = new Task();
        }

         public override IEnumerator<WebTestRequest> GetRequestEnumerator()
         {
            _Task = _pacPageObject.RetrieveFeed();
            yield break;
         }
     }
}