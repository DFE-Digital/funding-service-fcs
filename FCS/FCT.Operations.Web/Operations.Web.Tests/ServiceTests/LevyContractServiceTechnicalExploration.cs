namespace Operations.Web.Tests.ServiceTests
{
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.Web.Repositories;
    using Services;

    [TestClass]
    public class LevyContractServiceTechnicalExploration
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void LevyContractService_ShouldGetData()
        {
            using (var context = new ContractManagementDbContext())
            {
                LevyContractService service = new LevyContractService(new CrmContractInformationRepository(), new RoatpUkprnRepository(context));

                var x = service.GetLevyContractsThatCannotBeAmended();
            }
            
        }
    }
}
