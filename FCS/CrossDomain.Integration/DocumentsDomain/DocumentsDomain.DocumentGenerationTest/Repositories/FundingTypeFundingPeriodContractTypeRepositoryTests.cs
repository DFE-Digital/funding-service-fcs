namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Repositories
{
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using DocumentGeneration.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;

    [TestClass]
    public class FundingTypeFundingPeriodContractTypeRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodContractTypeRepository_GetDefinedContractTermForProvider_ShouldReturnCorrectDefinedContractTermForProvider()
        {
            //arrange 
            const string fundingTypeCode = "EDSK";
            const string fundingPeriodName = "AY1920";
            const string contractType = "Conditions of Funding (Grant) (HEI)";
            const string providerTerm = "Provider";

            RemoveAllRows();

            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodContractTypes.Add(
                    new FundingTypeFundingPeriodContractType(fundingTypeCode, fundingPeriodName, contractType, providerTerm));

                context.SaveChanges();
            }

            var fundingTypeFundingPeriodContractTypeRepository = new FundingTypeFundingPeriodContractTypeRepository(new ContractManagementDbContext());

            // act
            string definedContractTermForProvider =
                fundingTypeFundingPeriodContractTypeRepository.GetDefinedContractTermForProvider(fundingTypeCode, fundingPeriodName, contractType);

            // assert
            Assert.AreEqual(definedContractTermForProvider, providerTerm, "Incorrect definedContractTermForProvider returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodContractTypeRepository_GetDefinedContractTermForProvider_ShouldReturnCorrectDefinedContractTermForProviderAccountingForTheCache()
        {
            //arrange 
            const string fundingTypeCodeFirst = "EDSK";
            const string fundingPeriodNameFirst = "AY1920";
            const string contractTypeFirst = "Conditions of Funding (Grant) (HEI)";
            const string providerTermFirst = "Provider";

            const string fundingTypeCodeSecond = "EDSK";
            const string fundingPeriodNameSecond = "AY1920";
            const string contractTypeSecond = "Conditions of Funding (Grant) (Employer)";
            const string providerTermSecond = "Employer";

            RemoveAllRows();

            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodContractTypes.Add(
                    new FundingTypeFundingPeriodContractType(fundingTypeCodeFirst, fundingPeriodNameFirst, contractTypeFirst, providerTermFirst));
                context.FundingTypeFundingPeriodContractTypes.Add(
                    new FundingTypeFundingPeriodContractType(fundingTypeCodeSecond, fundingPeriodNameSecond, contractTypeSecond, providerTermSecond));

                context.SaveChanges();
            }

            var fundingTypeFundingPeriodContractTypeRepository = new FundingTypeFundingPeriodContractTypeRepository(new ContractManagementDbContext());

            // 1st act
            string definedContractTermForProviderFirst =
                fundingTypeFundingPeriodContractTypeRepository.GetDefinedContractTermForProvider(fundingTypeCodeFirst, fundingPeriodNameFirst, contractTypeFirst);

            // 1st assert
            Assert.AreEqual(definedContractTermForProviderFirst, providerTermFirst, "Incorrect definedContractTermForProvider returned on first call");


            // 2nd act
            string definedContractTermForProviderSecond =
                fundingTypeFundingPeriodContractTypeRepository.GetDefinedContractTermForProvider(fundingTypeCodeSecond, fundingPeriodNameSecond, contractTypeSecond);

            // 2nd assert
            Assert.AreEqual(definedContractTermForProviderSecond, providerTermSecond, "Incorrect definedContractTermForProvider returned on second call");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodContractTypeRepository_GetDefinedContractTermForProvider_ShouldReturnEmptyStringWhenDefinedContractTermForProviderDoesNotExist()
        {
            //arrange 
            const string fundingTypeCode = "EDSK";
            const string fundingPeriodName = "AY1920";
            const string contractType = "Conditions of Funding (Grant) (HEI)";
            const string providerTerm = "Provider";

            RemoveAllRows();
            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodContractTypes.Add(
                    new FundingTypeFundingPeriodContractType(fundingTypeCode, fundingPeriodName, contractType, providerTerm));

                context.SaveChanges();
            }

            var fundingTypeFundingPeriodContractTypeRepository = new FundingTypeFundingPeriodContractTypeRepository(new ContractManagementDbContext());

            // act
            string definedContractTermForProvider =
                fundingTypeFundingPeriodContractTypeRepository.GetDefinedContractTermForProvider(fundingTypeCode, fundingPeriodName, "XXX RANDOM YYY");

            // assert
            Assert.AreEqual(definedContractTermForProvider, string.Empty, "Empty string was not returned");
        }

        private void RemoveAllRows()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodContractTypes.RemoveAll();
                context.SaveChanges();
            }
        }
    }
}