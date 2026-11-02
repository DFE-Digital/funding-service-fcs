namespace ContractRequestDomain.Cfs.Tests.Release
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Cfs.Release.Repositories;
    using Common.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class AllocationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationRepository_GetAllocationsForRelease_ShouldReturnAllocationsInStatusOfInReleaseAndSubstatusOfReleaseInProgress()
        {
            // arrange
            DeleteAllocations(fundingType: "LOANS", fundingPeriod: "AY1819");
            DeleteAllocations(fundingType: "MAIN", fundingPeriod: "AY1819");

            Account[] providers = GetProviders(4);

            Guid sampleAllocationCrmId = CreateAllocation(fundingType: "LOANS", fundingPeriod: "AY1819", fundingStreamPeriod: "ALLF1819", status: sfa_AllocationStatus.InRelease, subStatus: sfa_AllocationSubStatus.ReleaseinProgress, provider: providers[0]);
            CreateAllocation(fundingType: "LOANS", fundingPeriod: "AY1819", fundingStreamPeriod: "ALLF1819", status: sfa_AllocationStatus.InRelease, subStatus: sfa_AllocationSubStatus.ReleaseinProgress, provider: providers[1]);
            CreateAllocation(fundingType: "LOANS", fundingPeriod: "AY1819", fundingStreamPeriod: "ALLF1819", status: sfa_AllocationStatus.PreRelease, subStatus: sfa_AllocationSubStatus.InReview, provider: providers[2]);
            CreateAllocation(fundingType: "MAIN", fundingPeriod: "AY1819", fundingStreamPeriod: "AEBC1819", status: sfa_AllocationStatus.InRelease, subStatus: sfa_AllocationSubStatus.ReleaseinProgress, provider: providers[3]);

            AllocationRepository allocationRepository = new AllocationRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            IReadOnlyCollection<Allocation> allocations = allocationRepository.GetAllocationsForRelease(fundingType: "LOANS", fundingPeriod: "AY1819");

            // assert
            Assert.IsNotNull(allocations, "Unexpected null value returned");
            Assert.AreEqual(2, allocations.Count, "Unexpected number of allocations returned");

            Allocation sampleReadyForReleaseAllocation = allocations.SingleOrDefault(a => a.Ukprn.ToString() == providers[0].sfa_UKPRN);
            Assert.IsNotNull(sampleReadyForReleaseAllocation, "Expected allocation not returned");
            Assert.AreEqual(providers[0].sfa_UKPRN, sampleReadyForReleaseAllocation.Ukprn.ToString(), "Unexpected Ukprn returned");
            Assert.AreEqual(new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc), sampleReadyForReleaseAllocation.StartDate, "Unexpected StartDate returned");
            Assert.AreEqual(new DateTime(2019, 07, 31, 0, 0, 0, DateTimeKind.Utc), sampleReadyForReleaseAllocation.EndDate, "Unexpected EndDate returned");
            Assert.AreEqual(1, sampleReadyForReleaseAllocation.MajorVersion, "Unexpected MajorVersion returned");
            Assert.AreEqual(2, sampleReadyForReleaseAllocation.MinorVersion, "Unexpected MinorVersion returned");
            Assert.AreEqual("ALLOC-ID", sampleReadyForReleaseAllocation.Id, "Unexpected Id returned");
            Assert.AreEqual("LOANS", sampleReadyForReleaseAllocation.FundingTypeCode, "Unexpected FundingTypeCode returned");
            Assert.AreEqual("ALLF1819", sampleReadyForReleaseAllocation.FundingStreamPeriodCode, "Unexpected FundingStreamPeriodCode returned");
            Assert.AreEqual("AY1819", sampleReadyForReleaseAllocation.FundingPeriod, "Unexpected FundingPeriod returned");
            Assert.AreEqual(5, sampleReadyForReleaseAllocation.DeliverableCode, "Unexpected DeliverableCode returned");
            Assert.AreEqual(sampleAllocationCrmId, sampleReadyForReleaseAllocation.CrmEntityId, "Unexpected CrmEntityId returned");
            Assert.AreEqual(1, sampleReadyForReleaseAllocation.AllocationPeriods.Count, "Unexpected number of allocation periods returned");
            AllocationPeriod selectedAllocationPeriod = sampleReadyForReleaseAllocation.AllocationPeriods.Single();
            Assert.AreEqual("Aug-18", selectedAllocationPeriod.Period, "Unexpected Period returned");
            Assert.AreEqual(1000m, selectedAllocationPeriod.ProfileValue, "Unexpected ProfileValue returned");
            Assert.AreEqual(8, selectedAllocationPeriod.Month, "Unexpected Month returned");
            Assert.AreEqual(2018, selectedAllocationPeriod.Year, "Unexpected Year returned");

            Allocation sampleInReviewAllocation = allocations.SingleOrDefault(a => a.Ukprn.ToString() == providers[2].sfa_UKPRN);
            Assert.IsNull(sampleInReviewAllocation, "Unexpected In Review allocation returned");
        }

        private static void DeleteAllocations(string fundingType, string fundingPeriod)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                IQueryable<Guid> query = (
                    from a in context.sfa_allocationSet
                    join ft in context.sfa_fundingtypeSet on a.sfa_fundingtype.Id equals ft.sfa_fundingtypeId
                    join fp in context.sfa_periodSet on a.sfa_fundingperiod.Id equals fp.sfa_periodId
                    where
                        ft.sfa_fundingtypecode == fundingType &&
                        fp.sfa_periodname == fundingPeriod
                    select a.Id);

                query
                    .AsEnumerable()
                    .ForEach(id => organizationService.Delete(sfa_allocation.EntityLogicalName, id));
            }
        }

        private static Guid CreateAllocation(
            string fundingType,
            string fundingPeriod,
            string fundingStreamPeriod,
            sfa_AllocationStatus status,
            sfa_AllocationSubStatus subStatus,
            Account provider)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_allocation allocation = new sfa_allocation
            {
                sfa_name = "ALLOC-ID",
                sfa_status = new OptionSetValue((int)status),
                sfa_substatus = new OptionSetValue((int)subStatus),
                sfa_ukprn = provider.sfa_UKPRN,
                sfa_value = 1000m,
                sfa_startdate = new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc),
                sfa_enddate = new DateTime(2019, 07, 31, 0, 0, 0, DateTimeKind.Utc),
                sfa_majorversion = 1,
                sfa_minorversion = 2,
                sfa_provider = new EntityReference(Account.EntityLogicalName, provider.Id),
                sfa_fundingtype = GetFundingTypeEntityReference(fundingType),
                sfa_fundingstreamperiod = GetFundingStreamPeriodEntityReference(fundingStreamPeriod),
                sfa_fundingperiod = GetFundingPeriodEntityReference(fundingPeriod),
                sfa_deliverable = GetFspDeliverableEntityReference("ALLF1819", 5),
                RelatedEntities =
                {
                    new KeyValuePair<Relationship, EntityCollection>(new Relationship("sfa_sfa_allocation_sfa_allocationperiod_allocation"), new EntityCollection
                    {
                        EntityName = sfa_allocationperiod.EntityLogicalName,
                        Entities =
                        {
                            new sfa_allocationperiod
                            {
                                sfa_name = "Aug-18",
                                sfa_value = 1000m,
                                sfa_month = 8,
                                sfa_year = "2018",
                                sfa_period = "Aug-18"
                            }
                        }
                    })
                }
            };

            return organizationService.Create(allocation);
        }

        private static Account[] GetProviders(int numberOfProvidersToReturn)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return context.AccountSet
                    .Take(numberOfProvidersToReturn)
                    .ToArray();
            }
        }

        private static EntityReference GetFundingTypeEntityReference(string fundingType)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                Guid id = context.sfa_fundingtypeSet
                    .Where(ft => ft.sfa_fundingtypecode == fundingType)
                    .Select(e => e.Id)
                    .Single();

                return new EntityReference(SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_fundingtype.EntityLogicalName, id);
            }
        }

        private static EntityReference GetFundingStreamPeriodEntityReference(string fundingStreamPeriod)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                Guid id = context.sfa_fundingstreamperiodSet
                    .Where(fsp => fsp.sfa_fundingstreamperiodcode == fundingStreamPeriod)
                    .Select(e => e.Id)
                    .Single();

                return new EntityReference(sfa_fundingstreamperiod.EntityLogicalName, id);
            }
        }

        private static EntityReference GetFundingPeriodEntityReference(string fundingPeriod)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                Guid id = context.sfa_periodSet
                    .Where(p => p.sfa_periodname == fundingPeriod)
                    .Select(e => e.Id)
                    .Single();

                return new EntityReference(sfa_period.EntityLogicalName, id);
            }
        }

        private static EntityReference GetFspDeliverableEntityReference(string fundingStreamPeriod, int deliverableCode)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                Guid id = (
                    from d in context.sfa_deliverableSet
                    join fs in context.sfa_fundingstreamSet on d.sfa_FundingStreamId.Id equals fs.sfa_fundingstreamId
                    join fsp in context.sfa_fundingstreamperiodSet on fs.sfa_fundingstreamId equals fsp.sfa_FundingStreamCodeId.Id
                    where
                        fsp.sfa_fundingstreamperiodcode == fundingStreamPeriod
                        && d.sfa_DeliverableCode == deliverableCode
                    select d.Id)
                    .Single();

                return new EntityReference(sfa_deliverable.EntityLogicalName, id);
            }
        }
    }
}
