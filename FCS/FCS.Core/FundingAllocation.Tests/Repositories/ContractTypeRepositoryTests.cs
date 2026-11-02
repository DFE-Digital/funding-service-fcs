namespace FundingAllocation.Tests.Repositories
{
    using System.Data.SqlClient;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ContractTypeRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTypeRepository_GetContractTypeShouldUseProviderCategoryWhenFound()
        {
            // arrange
            const string fundingTypeCode = "ftTest";
            const string fundingPeriodCode = "fpTest";
            const string providerCategory = "pcTest";
            const string contractType = "ctTest";
            const string contractTypeDefault = "ctTest - Default";
            RemoveCfsCodesToContractTypeConfig(fundingTypeCode, fundingPeriodCode, providerCategory);
            RemoveCfsCodesToContractTypeConfig(fundingTypeCode, fundingPeriodCode, "DEFAULT");
            InsertCfsCodesToContractTypeConfig(fundingTypeCode, fundingPeriodCode, providerCategory, contractType);
            InsertCfsCodesToContractTypeConfig(fundingTypeCode, fundingPeriodCode, "DEFAULT", contractTypeDefault);
            FundingAllocationContext context = new FundingAllocationContext(DbContextOptions);
            ContractTypeRepository repository = new ContractTypeRepository(context);

            // act
            var returnedContractType = repository.GetContractType(fundingTypeCode, fundingPeriodCode, providerCategory).Result;

            // assert
            returnedContractType.Should().Be(contractType);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTypeRepository_GetContractTypeShouldReturnDefaultWhenProviderCategoryNotFound()
        {
            // arrange
            const string fundingTypeCode = "ftTest";
            const string fundingPeriodCode = "fpTest";
            const string providerCategory = "pcTest";
            const string contractType = "ctTest";
            const string contractTypeDefault = "ctTest - Default";
            RemoveCfsCodesToContractTypeConfig(fundingTypeCode, fundingPeriodCode, providerCategory);
            RemoveCfsCodesToContractTypeConfig(fundingTypeCode, fundingPeriodCode, "DEFAULT");
            InsertCfsCodesToContractTypeConfig(fundingTypeCode, fundingPeriodCode, providerCategory, contractType);
            InsertCfsCodesToContractTypeConfig(fundingTypeCode, fundingPeriodCode, "DEFAULT", contractTypeDefault);
            FundingAllocationContext context = new FundingAllocationContext(DbContextOptions);
            ContractTypeRepository repository = new ContractTypeRepository(context);

            // act
            var returnedContractType = repository.GetContractType(fundingTypeCode, fundingPeriodCode, "some other").Result;

            // assert
            returnedContractType.Should().Be(contractTypeDefault);
        }

        private void RemoveCfsCodesToContractTypeConfig(string fundingTypeCode, string fundingPeriodCode,
            string providerCategory)
        {
            FundingAllocationContext context = new FundingAllocationContext(DbContextOptions);
            context.CfsCodesToContractTypeConfigRows.Where(r => r.FundingTypeCode == fundingTypeCode &&
                                                                r.FundingPeriodCode == fundingPeriodCode &&
                                                                r.ProviderCategory == providerCategory)
                .ToList()
                .ForEach(r => context.CfsCodesToContractTypeConfigRows.Remove(r));

            context.SaveChanges();
        }

        private void InsertCfsCodesToContractTypeConfig(string fundingTypeCode, string fundingPeriodCode,
            string providerCategory, string contractType)
        {
            using FundingAllocationContext context = new FundingAllocationContext(DbContextOptions);
            context.CfsCodesToContractTypeConfigRows.Add(new CfsCodesToContractTypeConfig(fundingTypeCode,
                fundingPeriodCode, providerCategory, contractType));

            context.SaveChanges();
        }

        private DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;
    }
}
