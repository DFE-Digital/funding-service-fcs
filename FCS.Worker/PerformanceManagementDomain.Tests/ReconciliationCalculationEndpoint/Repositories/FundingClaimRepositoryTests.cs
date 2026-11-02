namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Repositories
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using System.Data.Entity;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using UnitTests.Common;
    using DtoFundingClaim = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim;
    using FundingClaim = SFA.FCT.PerformanceManagementDomain.DataStore.Models.FundingClaim;
    using FundingClaimRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.FundingClaimRepository;

    [TestClass]
    public class FundingClaimRepositoryTests
    {
        private List<FundingClaim> _fundingClaimList = new List<FundingClaim>();
        private List<FundingClaimContractAllocation> _fundingClaimContractAllocations;
        private List<FundingClaimDeliverable> _fundingClaimDeliverables;

        [TestCleanup]
        public void TestCleanup()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                _fundingClaimList.ForEach(fundingClaim =>
                {
                    context.FundingClaims.RemoveByKey(fundingClaim.Id);
                });

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimRepository_WhenGetFundingClaimByNaturalKeyIsCalled_CorrectRecordIsReturned()
        {
            // Arrange
            FundingClaim testFundingClaim = new FundingClaim("ORG", 123, 1, "MIDYEAR", "AY", "1516", false);
            _fundingClaimList = CreateFCEntities(testFundingClaim, noOfEntitiesToCreate: 5);
            _fundingClaimContractAllocations = CreateFCAEntities(_fundingClaimList.Select(x => x.Id).ToList());
            _fundingClaimDeliverables = CreateFCDEntities(_fundingClaimContractAllocations.Select(x => x.Id).ToList());

            AddEntitiesToDb(_fundingClaimList, _fundingClaimContractAllocations, _fundingClaimDeliverables);

            FundingClaimRepository repository = new FundingClaimRepository();
            FundingClaimRepository.FundingClaimNaturalKey naturalKey = new FundingClaimRepository.FundingClaimNaturalKey()
            {
                OrganisationIdentifier = "ORG",
                VersionNumber = 2,
                ClaimTypeName = FundingClaimRepository.ClaimTypeNames.MIDYEAR,
                PeriodTypeCode = "AY",
                Period = "1516"
            };
            using (var context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                // Act
                DtoFundingClaim foundFundingClaim = repository.GetFundingClaimByNaturalKey(naturalKey, connectionInfo).Result;

            // Assert
            Assert.IsNotNull(foundFundingClaim);
            Assert.AreEqual(2, foundFundingClaim.VersionNumber);
            }
        }

        private void AddEntitiesToDb(List<FundingClaim> fundingClaimList, List<FundingClaimContractAllocation> fundingClaimAllocations, List<FundingClaimDeliverable> fundingClaimDeliverables)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.FundingClaims.AddRange(fundingClaimList);
                ((DbSet<FundingClaimContractAllocation>)context.FundingClaimContractAllocations).AddRange(fundingClaimAllocations);
                ((DbSet<FundingClaimDeliverable>)context.FundingClaimDeliverables).AddRange(fundingClaimDeliverables);

                context.SaveChanges();
            }
        }

        private List<FundingClaim> CreateFCEntities(FundingClaim fundingClaim, int noOfEntitiesToCreate)
        {
            var fundingClaimList = new List<FundingClaim>();

            for (int i = 1; i <= noOfEntitiesToCreate; i++)
            {
                var fc = new FundingClaim(fundingClaim.OrganisationIdentifier, fundingClaim.Ukprn, fundingClaim.VersionNumber + i, fundingClaim.ClaimTypeName, fundingClaim.PeriodTypeCode, fundingClaim.Period, fundingClaim.HasBeenSigned);
                fc.Allocations = new List<FundingClaimContractAllocation>
                {
                    new FundingClaimContractAllocation(Guid.NewGuid(), "allocNumber", "fspcode")
                    {
                        Deliverables = new List<FundingClaimDeliverable>
                        {
                            new FundingClaimDeliverable(Guid.NewGuid(), 1, 10m, 10m, 10m, 999m)
                        }
                    }
                };
                fundingClaimList.Add(fc);
            }

            return fundingClaimList;
        }

        private List<FundingClaimContractAllocation> CreateFCAEntities(List<Guid> fundingClaimIds)
        {
            List<FundingClaimContractAllocation> allocations = new List<FundingClaimContractAllocation>();
            foreach (var id in fundingClaimIds)
            {
                allocations.Add(new FundingClaimContractAllocation(id, "CAN", "FSPC"));
            }
            return allocations;
        }

        private List<FundingClaimDeliverable> CreateFCDEntities(List<Guid> fundingClaimAllocationIds)
        {
            List<FundingClaimDeliverable> deliverables = new List<FundingClaimDeliverable>();
            foreach (var id in fundingClaimAllocationIds)
            {
                deliverables.Add(new FundingClaimDeliverable(id, 1, 1m, 1m, 1m, 777m));
            }
            return deliverables;
        }
    }
}