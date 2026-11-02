
namespace FCTCrmConfig.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CrmConfiguration_ContractCRMWorkflow : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("Initial_Story", "Contract Workflows")]
        //Does the contract entity exists
        public void ContractWorkflowIsSynchronous()
        {
            // Example of how to Check Workflows
            //TestBase.CrmConfiguration.Entity("sfa_contract")
            //       .Workflow("dhtest2")
            //       .IsSynchronousProcess();

            //TestBase.CrmConfiguration.Entity("Contract")
            //     .Workflow("dhtest")
            //     .IsBackgroundProcess();
        }

        #endregion

    }
}
