namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Repositories
{
    using System.Linq;
    using IncrementContractVersionEndpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class AllocationNumberRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationNumberRepository_GetAllocationNumberPrefix_ShouldGetPrefix()
        {
            // Arrange 
            string prefix;
            string fspCode;

            using (var context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                fspCode = GetFundingStreamPeriodCode();

                var fsp = context.sfa_fundingstreamperiodSet.Single(fs => fs.sfa_fundingstreamperiodcode == fspCode);

                prefix = fsp.sfa_AllocationReferencePrefix;
            }

            var allocationNumberRepository = new AllocationNumberRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // Act 
            var prefixReturned = allocationNumberRepository.GetAllocationNumberPrefix(fspCode);

            // Assert
            Assert.AreEqual(prefix, prefixReturned, "The returned prefix number is incorrect");
        }

        private static string GetFundingStreamPeriodCode()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_fundingstreamperiodSet.First().sfa_fundingstreamperiodcode;
            }
        }
    }
}