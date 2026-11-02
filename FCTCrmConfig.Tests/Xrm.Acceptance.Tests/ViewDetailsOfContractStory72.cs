using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Acceptance.Tests
{


    [TestClass]
    public class ViewLatestContractStory72 : TestBase
    {
        
        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "72")]
        public void CheckContractEntityExists()
        {
            TestBase.CrmConfiguration.Entity("Contract");

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "72")]
        public void CheckContractFormIsAvailable()
        {
            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main);
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "72")]
        public void CheckFieldIsAvailableAndDissabled()
        {
            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
                .Field("Contract No")
                .IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
                    .Field("Version")
                    .IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
                 .Field("Contract Owner")
                 .IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            .Field("Task Owner")
            .IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            .Field("Contract Status")
            .IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            .Field("Sub Status")
            .IsDisabled(true);

            //TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            //.Field("Description")
            //.IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            .Field("UKPRN")
            .IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            .Field("Provider")
            .IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            .Field("Funding Type")
            .IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            .Field("Contract Type")
            .IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            .Field("Contract Value")
            .IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            .Field("Start Date")
            .IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            .Field("End Date")
            .IsDisabled(true);

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            .Field("Latest Version")
            .IsDisabled(true);
            //will the above test for it being a tickbox?

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
            .Field("Last Approved Version")
            .IsDisabled(true);
            //will the above test for it being a tickbox?
        }

    }
}
