namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using System;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Moq;
    using MoreLinq;
    using PaymentGenerationDomain.Integration.DataStore;
    using OrganisationDomain.Integration.DataStore;
    using OrganisationDomain.Integration.DataStore.Model;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class DeliveryOrgLinkingDataFix
    {
        [TestMethod, TestCategory("DataFix_R46")]
        public void LinkDeliveryOrgs()
        {
            UpdateDeliveryOrgUkprnInCrmForAllVersionsOfAllocation("SSF-1787", 10014799);

            CreateDissolvedOrgInOrgServiceCacheIfNotPresent(10017360, 130433, "ASPIRE", "Pupil Referral Unit");
            CreateDissolvedOrgInOrgServiceCacheIfNotPresent(10000615, 113216, "BEDLINGTONSHIRE COMMUNITY HIGH SCHOOL", "School-Community");
            CreateDissolvedOrgInOrgServiceCacheIfNotPresent(10006603, 114268, "BLESSED ROBERT JOHNSON CATHOLIC COLLEGE", "School-Voluntary aided");

            IReadOnlyCollection<AllocationDeliveryOrg> allocationsWithDeliveryOrgs = GetAllocationsWithDeliveryOrgs();

            allocationsWithDeliveryOrgs.ForEach(AddOrgInfoIfPossible);

            List<string> ukprnsNotInCrm = allocationsWithDeliveryOrgs.Where(a => !a.IsOrgInCrm())
                .Select(a => a.DeliveryOrgUkprn)
                .ToList();

            OrganisationService organisationService = new OrganisationService(Mock.Of<ILogger>(), Mock.Of<IOrganisationServiceApiHttpClient>());

            XrmOrganisationManager xrmOrganisationManager = 
                new XrmOrganisationManager {OrgService = GetOrganizationService()};

            ukprnsNotInCrm.ForEach(ukprn => 
                CallOrgServiceAndCreateOrgInCrm(organisationService, xrmOrganisationManager, int.Parse(ukprn)));

            allocationsWithDeliveryOrgs.Where(a => !a.IsOrgInCrm())
                .ForEach(AddOrgInfoIfPossible);

            allocationsWithDeliveryOrgs.ForEach(UpdateSubnominalAggregations);

            allocationsWithDeliveryOrgs.ForEach(UpdateApprovedContractAllocation);
        }

        private void UpdateApprovedContractAllocation(AllocationDeliveryOrg allocationDeliveryOrg)
        {
            using (var context = new ContractManagementDbContext())
            {
                ApprovedContractAllocation approvedContractAllocation = context.ApprovedContractAllocations.SingleOrDefault(a => // published or withdrawn allocations will not be present
                    a.ContractAllocationNumber == allocationDeliveryOrg.AllocationNumber);

                if (approvedContractAllocation != null)
                {
                    approvedContractAllocation.DeliveryOrganisationUkprn = int.Parse(allocationDeliveryOrg.DeliveryOrgUkprn);
                    approvedContractAllocation.DeliveryOrganisationId = allocationDeliveryOrg.DeliveryOrgId;

                    context.SaveChanges();
                }
            }
        }
    
        private static void UpdateDeliveryOrgUkprnInCrmForAllVersionsOfAllocation(string allocationNumber, int deliveryOrgUkprn)
        {
            using (XrmServiceContext context = new XrmServiceContext(GetOrganizationService()))
            {
                context.sfa_contractallocationSet
                    .Where(a => a.sfa_contractallocationnumber == allocationNumber)
                    .Select(a => a.Id)
                    .ToList()
                    .ForEach(id =>
                    {
                        GetOrganizationService().Update(new sfa_contractallocation
                        {
                            Id = id,
                            sfa_deliveryorganisationukprn = deliveryOrgUkprn.ToString()
                        });
                    });
            }
        }

        private static void CallOrgServiceAndCreateOrgInCrm(IOrganisationService organisationService, IXrmOrganisationManager xrmOrganisationManager, int ukprn)
        {
            organisation orgServiceOrg = organisationService.GetOrganisationForUkprn(ukprn);

            ContractOrganisation crmOrg = new ContractOrganisation
            {
                OrganisationId = orgServiceOrg.organisationId,
                UKPRN = orgServiceOrg.organisationIdentifiers.First(o => o.organisationIdentifierType == organisationIdentifierType.UKPROVIDERREFERENCENUMBER).organisationIdentifier,
                Status = orgServiceOrg.organisationStatusRelationships.First(s => s.organisationStatus.organisationStatusScheme == organisationStatusSchemeType.LEGAL).organisationStatus.organisationStatus,
                Name = orgServiceOrg.organisationNames.First(o => o.organisationNameType == organisationNameType.LEGAL).organisationName,
                Upin = orgServiceOrg.organisationIdentifiers.First(o => o.organisationIdentifierType == organisationIdentifierType.UPIN).organisationIdentifier,
                CompanyNumber = orgServiceOrg.organisationIdentifiers.FirstOrDefault(o => o.organisationIdentifierType == organisationIdentifierType.COMPANYREGISTRATIONNUMBER)?.organisationIdentifier,
                CharityNumber = orgServiceOrg.organisationIdentifiers.FirstOrDefault(o => o.organisationIdentifierType == organisationIdentifierType.CHARITYNUMBER)?.organisationIdentifier,
            };

            xrmOrganisationManager.CreateOrganisationIfNotExists(crmOrg);
        }

        private void AddOrgInfoIfPossible(AllocationDeliveryOrg allocationDeliveryOrg)
        {
            var crmOrg = GetCrmOrg(allocationDeliveryOrg.DeliveryOrgUkprn);

            allocationDeliveryOrg.DeliveryOrgId = crmOrg?.OrganisationId;
        }

        private SimpleCrmOrg GetCrmOrg(string ukprn)
        {
            using (var context = new XrmServiceContext(GetOrganizationService()))
            {
                return context.AccountSet.Where(a => a.sfa_UKPRN == ukprn)
                    .Select(o => new {o.Id, o.sfa_OrganisationID})
                    .AsEnumerable()
                    .Select(o => new SimpleCrmOrg(o.Id, o.sfa_OrganisationID))
                    .FirstOrDefault();
            }
        }

        private static IReadOnlyCollection<AllocationDeliveryOrg> GetAllocationsWithDeliveryOrgs()
        {
            using (var context = new XrmServiceContext(GetOrganizationService()))
            {
                return (from c in context.sfa_contractSet
                        join a in context.sfa_contractallocationSet on c.sfa_contractId equals a.sfa_ContractId.Id
                        where a.sfa_deliveryorganisationukprn != null
                        select new {c.sfa_UKPRN, a.sfa_contractallocationnumber, a.sfa_deliveryorganisationukprn, a.Id })
                    .AsEnumerable()
                    .Select(a => new AllocationDeliveryOrg(allocationId: a.Id, allocationNumber: a.sfa_contractallocationnumber, deliveryOrgUkprn: a.sfa_deliveryorganisationukprn, contractOrgUkprn: a.sfa_UKPRN))
                    .Distinct()
                    .ToList();
            }
        }

        private void UpdateSubnominalAggregations(AllocationDeliveryOrg allocationDeliveryOrg)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                int deliveryOrgUkprn = int.Parse(allocationDeliveryOrg.DeliveryOrgUkprn);
                int contractingOrgUkprn = int.Parse(allocationDeliveryOrg.ContractOrgUkprn);

                var subnominalAggregations = context.SubnominalAggregations.Where(s => s.AllocationNumber == allocationDeliveryOrg.AllocationNumber && s.Ukprn == contractingOrgUkprn);
                subnominalAggregations.ForEach(s =>
                {
                    s.Ukprn = deliveryOrgUkprn;
                    s.OrganisationId = allocationDeliveryOrg.DeliveryOrgId;
                });

                context.SaveChanges();
            }
        }

        private static OrganizationService GetOrganizationService()
        {
            return new OrganizationService(CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString));
        }

        private static void CreateDissolvedOrgInOrgServiceCacheIfNotPresent(int ukprn, int upin, string tradingName, string providerType)
        {
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                Organisation existingOrg = context.Organisations.SingleOrDefault(o => o.Ukprn == ukprn);

                if (existingOrg == null)
                {
                    context.Organisations.Add(new Organisation
                    {
                        Ukprn = ukprn,
                        Upin = upin,
                        TradingName = tradingName,
                        Type = providerType,
                        Status = "Dissolved",
                        SequenceNumber = 0, // no data retrievable from CPDS
                        HasUkrlpBeenCalledSuccessfully = true, //  no data retrievable from UKRLP
                        CompanyRegistrationNumber = null,
                        CharityNumber = null
                    });
                    context.SaveChanges();
                }
            }
        }

        private class SimpleCrmOrg
        {
            public SimpleCrmOrg(Guid crmOrgId, string organisationId)
            {
                CrmOrgId = crmOrgId;
                OrganisationId = organisationId;
            }

            public Guid CrmOrgId { get; }

            public string OrganisationId { get; }
        }

        private class AllocationDeliveryOrg
        {
            public AllocationDeliveryOrg(Guid allocationId, string allocationNumber, string deliveryOrgUkprn, string contractOrgUkprn)
            {
                AllocationNumber = allocationNumber;
                DeliveryOrgUkprn = deliveryOrgUkprn;
                ContractOrgUkprn = contractOrgUkprn;
                AllocationId = allocationId;
            }

            protected bool Equals(AllocationDeliveryOrg other)
            {
                return AllocationId.Equals(other.AllocationId) && string.Equals(AllocationNumber, other.AllocationNumber) && string.Equals(DeliveryOrgUkprn, other.DeliveryOrgUkprn) && string.Equals(ContractOrgUkprn, other.ContractOrgUkprn) && string.Equals(DeliveryOrgId, other.DeliveryOrgId);
            }

            public override bool Equals(object obj)
            {
                if (ReferenceEquals(null, obj)) return false;
                if (ReferenceEquals(this, obj)) return true;
                if (obj.GetType() != this.GetType()) return false;
                return Equals((AllocationDeliveryOrg) obj);
            }

            public override int GetHashCode()
            {
                unchecked
                {
                    var hashCode = AllocationId.GetHashCode();
                    hashCode = (hashCode * 397) ^ (AllocationNumber != null ? AllocationNumber.GetHashCode() : 0);
                    hashCode = (hashCode * 397) ^ (DeliveryOrgUkprn != null ? DeliveryOrgUkprn.GetHashCode() : 0);
                    hashCode = (hashCode * 397) ^ (ContractOrgUkprn != null ? ContractOrgUkprn.GetHashCode() : 0);
                    hashCode = (hashCode * 397) ^ (DeliveryOrgId != null ? DeliveryOrgId.GetHashCode() : 0);
                    return hashCode;
                }
            }

            public bool IsOrgInCrm()
            {
                return !string.IsNullOrEmpty(DeliveryOrgId);
            }

            public Guid AllocationId { get; }

            public string AllocationNumber { get; }

            public string DeliveryOrgUkprn { get; }

            public string ContractOrgUkprn { get; }

            public string DeliveryOrgId { get; set; }
        }
    }
}
