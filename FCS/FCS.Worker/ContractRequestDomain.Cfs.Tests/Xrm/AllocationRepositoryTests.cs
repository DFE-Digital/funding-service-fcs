namespace ContractRequestDomain.Cfs.Tests.Xrm
{
    using System;
    using System.Linq;
    using ContractRequestDomain.Cfs.Xrm.Repositories;
    using ContractRequestDomain.Cfs.Common.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using System.Collections.Generic;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;

    [TestClass]
    public class AllocationRepositoryTests
    {
        private const string FundingStreamPeriodCode = "ALLF1819";
        private const string AllocationRef = "AllocationRepositoryTest";

        private const string FundingTypeCode = "LOANS";
        private const string FundingPeriod = "AY1819";
        private const int DeliverableCode = 5;

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationRepository_ShouldCreateAllocationWithNoAllocationPeriods()
        {
            // arrange
            ClearDownAllocation();
            Allocation allocationDto = CreateAllocationDto(createAllocationPeriods: false);

            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            LookupRepository lookupRepository = new LookupRepository(organizationSvc);
            AllocationRepository allocationRepository = new AllocationRepository(organizationSvc, lookupRepository);

            // act
            allocationRepository.CreateAllocationAndPeriods(allocationDto);

            // assert
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                var allocations = xrmContext.sfa_allocationSet
                    .Where(a => a.sfa_name == AllocationRef)
                    .ToList();

                Assert.AreEqual(1, allocations.Count, "Incorrect number of allocations returned");

                var allocation = allocations.First();
                Assert.AreEqual(FundingPeriod, allocation.sfa_fundingperiod.Name, "Incorrect FundingPeriod stored in CRM allocation");

                var fundingTypeCode = xrmContext.sfa_fundingtypeSet
                    .First(ft => ft.Id == allocation.sfa_fundingtype.Id).sfa_fundingtypecode;
                Assert.AreEqual(FundingTypeCode, fundingTypeCode, "Incorrect FundingTypeCode stored in CRM allocation");

                var allocationperiods = xrmContext.sfa_allocationperiodSet
                    .Where(ap => ap.sfa_allocation.Id == allocation.Id)
                    .ToList();

                Assert.AreEqual(0, allocationperiods.Count, "Incorrect number of allocation periods returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationRepository_ShouldCreateAllocationWithSomeAllocationPeriods()
        {
            // arrange
            ClearDownAllocation();
            Allocation allocationDto = CreateAllocationDto();

            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            LookupRepository lookupRepository = new LookupRepository(organizationSvc);
            AllocationRepository allocationRepository = new AllocationRepository(organizationSvc, lookupRepository);

            // act
            allocationRepository.CreateAllocationAndPeriods(allocationDto);

            // assert
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                var allocations = xrmContext.sfa_allocationSet
                    .Where(a => a.sfa_name == AllocationRef)
                    .ToList();

                Assert.AreEqual(1, allocations.Count, "Incorrect number of allocations returned");

                var allocation = allocations.First();
                Assert.AreEqual(FundingPeriod, allocation.sfa_fundingperiod.Name, "Incorrect FundingPeriod stored in CRM allocation");

                var fundingTypeCode = xrmContext.sfa_fundingtypeSet
                    .First(ft => ft.Id == allocation.sfa_fundingtype.Id).sfa_fundingtypecode;
                Assert.AreEqual(FundingTypeCode, fundingTypeCode, "Incorrect FundingTypeCode stored in CRM allocation");

                var allocationperiods = xrmContext.sfa_allocationperiodSet
                    .Where(ap => ap.sfa_allocation.Id == allocation.Id)
                    .ToList();

                Assert.AreEqual(12, allocationperiods.Count, "Incorrect number of allocation periods returned");

                var allocationperiod12 = allocationperiods[11];
                Assert.AreEqual("Jul-19", allocationperiod12.sfa_period, "Incorrect period stored in 12th Allocation Period");
                Assert.AreEqual("Jul-19", allocationperiod12.sfa_name, "Incorrect name stored in 12th Allocation Period");
                Assert.AreEqual("2019", allocationperiod12.sfa_year, "Incorrect Year stored in 12th Allocation Period");
                Assert.AreEqual(7, allocationperiod12.sfa_month, "Incorrect Month value stored in 12th Allocation Period");
                Assert.AreEqual(120M, allocationperiod12.sfa_value, "Incorrect profile value stored in 12th Allocation Period");
            }
        }

        private static void ClearDownAllocation()
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationSvc))
            {
                List<Guid> allocations = xrmContext.sfa_allocationSet
                    .Where(a => a.sfa_name == AllocationRef)
                    .Select(c => c.Id).ToList();

                allocations.ForEach(c => organizationSvc.Delete(sfa_allocation.EntityLogicalName, c));
            }
        }

        private static Allocation CreateAllocationDto(bool createAllocationPeriods = true)
        {
            DateTime startDate = new DateTime(2018, 8, 01);

            Allocation allocation =  new Allocation
            {
                Id = AllocationRef,
                FundingStreamPeriodCode = FundingStreamPeriodCode,
                DeliverableCode = DeliverableCode,
                FundingTypeCode = FundingTypeCode,
                FundingPeriod = FundingPeriod,
                Ukprn = GetUkprnFromCrm(),
                MajorVersion = 1,
                MinorVersion = 1,
                StartDate = startDate,
                EndDate = new DateTime(2019, 7, 31)
            };

            if (createAllocationPeriods)
            {
                allocation.AllocationPeriods = CreateAllAllocationPeriods(startDate: startDate, numberOfAllocationPeriods: 12);
            }

            return allocation;
        }

        private static List<AllocationPeriod> CreateAllAllocationPeriods(DateTime startDate, int numberOfAllocationPeriods)
        {
            List<AllocationPeriod> allocationPeriods = new List<AllocationPeriod>();

            Enumerable.Range(0, numberOfAllocationPeriods).ToList().ForEach(monthIncrement =>
                allocationPeriods.Add(CreateAllocationPeriod(startDate.AddMonths(monthIncrement), (monthIncrement + 1) * 10)));

            return allocationPeriods;
        }

        private static AllocationPeriod CreateAllocationPeriod(DateTime periodDatetime, decimal profileValue)
        {
            string period = periodDatetime.ToString("MMM") + "-" + periodDatetime.Year.ToString().Substring(2, 2);

            return new AllocationPeriod
            {
                Month = periodDatetime.Month,
                Year = periodDatetime.Year,
                ProfileValue = profileValue,
                Period = period
            };
        }

        private static int GetUkprnFromCrm()
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return int.Parse(context.AccountSet.First(a => a.sfa_UKPRN != null).sfa_UKPRN);
            }
        }
    }
}