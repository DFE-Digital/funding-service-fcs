namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using UnitTests.Common;

    [TestClass]
    public class PolicyConfigRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTypeRepository_ShouldGetAllContractTypes()
        {
            List<string> contractTypes = new List<string>
            {
                "Dummy Test CT 1",
                "Dummy Test CT 2",
                "Dummy Test CT 3",
                "Dummy Test CT 4",
                "Dummy Test CT 5"
            };

            ClearDownContractTypes(contractTypes);

            using (var context = new ContractManagementDbContext())
            {
                contractTypes.ForEach(ct => context.ContractTypes.Add(new ContractType(ct)));
                context.SaveChanges();
            }

            using (var dbContext = new ContractManagementDbContext())
            {
                var repository = new PolicyConfigRepository(dbContext);

                // act
                IReadOnlyCollection<string> actualContractTypes = repository.GetAllContractTypes();

                Assert.IsTrue(actualContractTypes.Count >= 5, "Repository did not return the contract types added");
                contractTypes.ForEach(
                    ct =>
                        Assert.IsTrue(actualContractTypes.Any(actual => string.Equals(actual, ct)),
                            $"Contract Type {ct} was not found"));
            }
            ClearDownContractTypes(contractTypes);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RegionTypeRepository_ShouldGetAllRegionTypes()
        {
            List<RegionType> regionTypes = new List<RegionType>
            {
                new RegionType(100, "Dummy Test RT 1"),
                new RegionType(200, "Dummy Test RT 2"),
                new RegionType(300, "Dummy Test RT 3"),
                new RegionType(400, "Dummy Test RT 4"),
                new RegionType(500, "Dummy Test RT 5"),
            };

            ClearDownRegionTypes(regionTypes);

            using (var context = new ContractManagementDbContext())
            {
                regionTypes.ForEach(rt => context.RegionTypes.Add(rt));
                context.SaveChanges();
            }

            using (var dbContext = new ContractManagementDbContext())
            {
                var repository = new PolicyConfigRepository(dbContext);

                // act
                IReadOnlyCollection<string> allRegionTypes = repository.GetAllRegionTypes();

                Assert.IsTrue(allRegionTypes.Count >= 5, "Repository did not return the region types added");
                regionTypes
                    .Select(rt => rt.RegionTypeName)
                    .ForEach(rt =>
                        Assert.IsTrue(allRegionTypes.Any(actual => string.Equals(actual, rt)),
                            $"Region Type {rt} was not found"));
            }
            ClearDownRegionTypes(regionTypes);
        }

        private static void ClearDownContractTypes(List<string> contractTypes)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.ContractTypes.RemoveWhere(ct => contractTypes.Contains(ct.ContractTypeName));
                context.SaveChanges();
            }
        }

        private static void ClearDownRegionTypes(List<RegionType> regionTypes)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.RegionTypes
                    .ToList()
                    .Where(rt => regionTypes.Contains(rt))
                    .ForEach(rt => context.RegionTypes.Remove(rt));
                context.SaveChanges();
            }
        }
    }
}