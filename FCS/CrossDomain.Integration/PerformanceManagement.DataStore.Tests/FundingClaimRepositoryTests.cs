namespace PerformanceManagement.DataStore.Tests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;
    using System.Data.Entity;
    using System.Linq;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using UnitTests.Common;
    using DtoFundingClaim = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim;
    using FundingClaim = SFA.FCT.PerformanceManagementDomain.DataStore.Models.FundingClaim;

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
        public void FundingClaimRepository_RetrieveAllFundingClaimsForPeriodAndClaimType_ShouldReturnUncalculatedTotalDeliveryValue()
        {
            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                context.FundingClaims.RemoveWhere(fc => fc.ClaimTypeName == "MID YEAR" && fc.Period == "1516");
                context.SaveChanges();
            }

            FundingClaim testFundingClaim = new FundingClaim("ORG", 123, 1, "MID YEAR", "CM", "1516", false);
            _fundingClaimList = CreateFCEntities(testFundingClaim, 5);
            _fundingClaimContractAllocations = CreateFCAEntities(_fundingClaimList.Select(x => x.Id).ToList());
            _fundingClaimDeliverables = CreateFCDEntities(_fundingClaimContractAllocations.Select(x => x.Id).ToList());

            AddEntitiesToDb(_fundingClaimList, _fundingClaimContractAllocations, _fundingClaimDeliverables);

            // act
            using (var context = new PerformanceManagementDbContext())
            {
                var repository = new FundingClaimRepository(context);
                List<DtoFundingClaim> listDtoFundingClaim = repository.RetrieveAllFundingClaimsForPeriodAndClaimType("1516", "MID YEAR").ToList();
            
                // assert
                ContractAllocation contractAllocationCan = listDtoFundingClaim[0].ContractAllocations.Single(ca => ca.ContractAllocationNumber == "CAN");
                Assert.AreEqual(777, contractAllocationCan.DeliverableLines[0].TotalDelivery);
                var contractAllocationallocNumber = listDtoFundingClaim[0].ContractAllocations.Single(ca => ca.ContractAllocationNumber == "allocNumber");
                Assert.AreEqual(999, contractAllocationallocNumber.DeliverableLines[0].TotalDelivery);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimRepository_RetrieveAllFundingClaimsForPeriodAndClaimType_ShouldOnlyReturnFundingClaimsWithAllocations()
        {
            // arrange
            const string orgWithAllocations = "ORG2";
            DeleteAllFundingClaims();
            FundingClaim testFundingClaim = new FundingClaim("ORG", 123, 1, "MID YEAR", "CM", "1516", false);
            FundingClaim testFundingClaimWithAllocations = new FundingClaim(orgWithAllocations, 123, 1, "MID YEAR", "CM", "1516", false);
            testFundingClaimWithAllocations.Allocations.Add(new FundingClaimContractAllocation(testFundingClaimWithAllocations.Id, "alloc", "fsp"));

            CreateFundingClaimInDb(testFundingClaim);
            CreateFundingClaimInDb(testFundingClaimWithAllocations);

            var context = new PerformanceManagementDbContext();
            context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
            var repository = new FundingClaimRepository(context);

            // act
            List<DtoFundingClaim> listDtoFundingClaim = repository.RetrieveAllFundingClaimsForPeriodAndClaimType("1516", "MID YEAR").ToList();

            // assert
            Assert.AreEqual(1, listDtoFundingClaim.Count, "The number of funding claims returned is incorrect");
            Assert.AreEqual(1, listDtoFundingClaim.Count(fc => fc.Contractor.OrganisationIdentifier == orgWithAllocations), "The expected org is not present");
        }

        private void DeleteAllFundingClaims()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.FundingClaims.ForEach(fc => { context.FundingClaims.Remove(fc); });

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimRepository_WhenGetFundingClaimByNaturalKeyIsCalled_CorrectRecordIsReturned()
        {
            // Arrange
            FundingClaim testFundingClaim = new FundingClaim("ORG", 123, 1, "MIDYEAR", "AY", "1516", false);
            _fundingClaimList = CreateFCEntities(testFundingClaim, 5);
            _fundingClaimContractAllocations = CreateFCAEntities(_fundingClaimList.Select(x=>x.Id).ToList());
            _fundingClaimDeliverables = CreateFCDEntities(_fundingClaimContractAllocations.Select(x => x.Id).ToList());

            AddEntitiesToDb(_fundingClaimList, _fundingClaimContractAllocations, _fundingClaimDeliverables);

            
            var repository = new FundingClaimRepository(new PerformanceManagementDbContext());
            FundingClaimNaturalKey naturalKey = new FundingClaimNaturalKey()
            {
                OrganisationIdentifier = "ORG",
                VersionNumber = 2,
                ClaimTypeName = ClaimTypeNames.MIDYEAR,
                PeriodTypeCode = "AY",
                Period = "1516"
            };
            // Act
            DtoFundingClaim foundFundingClaim = repository.GetFundingClaimByNaturalKey(naturalKey);

            // Assert
            Assert.IsNotNull(foundFundingClaim);
            Assert.AreEqual(2, foundFundingClaim.VersionNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimRepository_WhenRetrieveAllFundingClaimsIsCalled_CorrectNumberOfRecordsReturned()
        {
            // Arrange
            FundingClaim testFundingClaim = new FundingClaim("ORG", 123, 1, "Year End", "AY", "1516", false);
            _fundingClaimList = CreateFCEntities(testFundingClaim, 5);
            FundingClaim testFundingClaim2 = new FundingClaim("ORG", 123, 1, "Mid Year", "AY", "1516", false);
            _fundingClaimList.AddRange(CreateFCEntities(testFundingClaim2, 5));
            FundingClaim testFundingClaim3 = new FundingClaim("ORG", 123, 1, "Year End", "AY", "1617", false);
            _fundingClaimList.AddRange(CreateFCEntities(testFundingClaim3, 5));

            _fundingClaimContractAllocations = CreateFCAEntities(_fundingClaimList.Select(x => x.Id).ToList());
            _fundingClaimDeliverables = CreateFCDEntities(_fundingClaimContractAllocations.Select(x => x.Id).ToList());

            AddEntitiesToDb(_fundingClaimList, _fundingClaimContractAllocations, _fundingClaimDeliverables);

            // Act
            var repository = new FundingClaimRepository(new PerformanceManagementDbContext());
            
            List<DtoFundingClaim> retrievedFundingClaims = repository.RetrieveAllFundingClaimsForPeriodAndClaimType("1516", "Year End");

            // Assert
            Assert.AreEqual(5, retrievedFundingClaims.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimRepository_WhenAddFundingClaimsIsCalled_CorrectNumberOfRecordsAreAddedToDb()
        {
            // Arrange
            const string orgId = "ORG00009";
            FundingClaim testFundingClaim = new FundingClaim(orgId, 123, 1, "Year End", "AY", "1516", false);
            _fundingClaimList = CreateFCEntities(testFundingClaim, 5);

            _fundingClaimContractAllocations = CreateFCAEntities(_fundingClaimList.Select(x => x.Id).ToList());
            _fundingClaimDeliverables = CreateFCDEntities(_fundingClaimContractAllocations.Select(x => x.Id).ToList());

            _fundingClaimContractAllocations
                .ForEach(a => a.Deliverables = _fundingClaimDeliverables
                    .Where(d => d.ContractAllocationId == a.Id)
                    .ToList());

            _fundingClaimList.ForEach(
                x => x.Allocations = _fundingClaimContractAllocations
                .Where(a => a.FundingClaimId == x.Id)
                .ToList());

            // Act
            var repository = new FundingClaimRepository(new PerformanceManagementDbContext());

            repository.AddFundingClaims(_fundingClaimList);

            // Assert

            using (var context = new PerformanceManagementDbContext())
            {
                List<FundingClaim> fundingClaims = context.FundingClaims
                    .Where(x => x.OrganisationIdentifier == orgId)
                    .Include(fc => fc.Allocations.Select(a => a.Deliverables))
                    .ToList();

                List<FundingClaimContractAllocation> allocations = fundingClaims.SelectMany(x => x.Allocations).ToList();

                var deliverables = allocations.SelectMany(a => a.Deliverables).ToList();
                Assert.AreEqual(5, fundingClaims.Count);
                Assert.AreEqual(5, allocations.Count);
                Assert.AreEqual(5, deliverables.Count);
            }
        }

        private void AddEntitiesToDb(List<FundingClaim> fundingClaimList, List<FundingClaimContractAllocation> fundingClaimAllocations, List<FundingClaimDeliverable> fundingClaimDeliverables)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.FundingClaims.AddRange(fundingClaimList);
                ((DbSet<FundingClaimContractAllocation>) context.FundingClaimContractAllocations).AddRange(fundingClaimAllocations);
                ((DbSet<FundingClaimDeliverable>) context.FundingClaimDeliverables).AddRange(fundingClaimDeliverables);

                context.SaveChanges();
            }
        }

        private void CreateFundingClaimInDb(FundingClaim fundingClaim)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.FundingClaims.Add(fundingClaim);

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
            foreach(var id in fundingClaimIds)
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
