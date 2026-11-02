namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class FundingStreamConfigServiceTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingStreamConfigService_ShouldGetData()
        {
            FundingStreamConfigService service = new FundingStreamConfigService();
            FSCDeliverableStructureDefinitionResponse response = service.GetFullDeliverableStructure("16-18NLAP2018");

            Assert.IsTrue(response.DeliverableStructureList.Any());
        }
    }
}
