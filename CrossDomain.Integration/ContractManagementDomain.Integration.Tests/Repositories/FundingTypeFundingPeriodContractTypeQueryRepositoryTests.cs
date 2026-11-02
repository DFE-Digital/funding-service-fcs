namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Core.Internal;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.Data;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingTypeFundingPeriodContractTypeQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodContractTypeQueryRepository_ShouldGetAllRows()
        {
            // arrange
            RemoveAllRows();

            const string fundingTypeCode = "EDSK";
            const string fundingPeriodCode = "AY1920";
            const string contractType1 = "Contract for Services";
            const string contractType2 = "Conditions of Funding (Grant)";
            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodContractTypes.Add(
                    new FundingTypeFundingPeriodContractType(fundingTypeCode, fundingPeriodCode, contractType1, "Provider"));
                context.FundingTypeFundingPeriodContractTypes.Add(
                    new FundingTypeFundingPeriodContractType(fundingTypeCode, fundingPeriodCode, contractType2, "Provider"));


                context.SaveChanges();
            }

            // act
            using (var context = new ContractManagementDbContext())
            {
                IReadOnlyCollection<FundingTypeFundingPeriodContractType> fundingTypeFundingPeriodContractTypes =
                    new FundingTypeFundingPeriodContractTypeQueryRepository()
                        .GetFundingTypeFundingPeriodContractTypes(new ConnectionInfo(null, context.Database.Connection));

                // assert
                Assert.AreEqual(2, fundingTypeFundingPeriodContractTypes.Count,
                    "The number of rows returned is not correct");
            }
        }

        private void RemoveAllRows()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodContractTypes.ToList().ForEach(r => context.FundingTypeFundingPeriodContractTypes.Remove(r));

                context.SaveChanges();
            }
        }
    }
}
