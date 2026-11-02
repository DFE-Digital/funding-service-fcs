namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Infrastructure.Services;
    using Microsoft.Xrm.Sdk;

    public class CheckEsfTotalPlannedVolumeStepsPageObject
    {
        private readonly IOrganizationService _organizationService;

        public CheckEsfTotalPlannedVolumeStepsPageObject()
        {
            _organizationService = CrmConnectionFactory.GetConnection();
        }

        public ContractInfo RetrievedContractForValidation { get; set; }

        public ContractInfo GetLatestContractInfoByUkprn(int ukprn)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                ContractInfo contract = xrmContext.sfa_contractSet
                    .Where(c => c.sfa_UKPRN == ukprn.ToString() && (sfa_contracthierarchytype)c.sfa_HierarchyType.Value == sfa_contracthierarchytype.Contract)
                    .OrderByDescending(c => c.CreatedOn)
                    .Select(c => new ContractInfo
                    {
                        Id = c.Id,
                        ContractNumber = c.sfa_number,
                        ContractVersion = c.sfa_Version.Value

                    })
                    .FirstOrDefault();

                if (contract != null)
                {
                    contract.Allocations = xrmContext.sfa_contractallocationSet
                        .Where(a => a.sfa_ContractId.Id == contract.Id)
                        .Select(a => new AllocationInfo
                        {
                            AllocationNumber = a.sfa_contractallocationnumber,
                            Deliverables = GetDeliverables(a.sfa_contractallocationnumber, contract.ContractVersion)
                        })
                        .ToList();
                }

                return contract;
            }
        }

        private IReadOnlyCollection<DeliverableInfo> GetDeliverables(string allocationNumber, int contractVersion)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                return
                    (from a in xrmContext.sfa_contractallocationSet
                     join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                     join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals d.sfa_ContractAllocationId.Id
                     where
                         c.sfa_Version == contractVersion &&
                         a.sfa_contractallocationnumber == allocationNumber
                     select new DeliverableInfo
                     {
                         DeliverableCode = int.Parse(d.sfa_DeliverableCode),
                         TotalPlannedVolume = d.sfa_PlannedVolume,
                         DeliverablePeriods = GetDeliverablePeriods(allocationNumber, contractVersion, int.Parse(d.sfa_DeliverableCode))
                     })
                    .ToList();
            }
        }

        private IReadOnlyCollection<DeliverablePeriodInfo> GetDeliverablePeriods(string allocationNumber, int contractVersionNumber, int deliverableCode)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                return
                    (from a in xrmContext.sfa_contractallocationSet
                     join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                     join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals d.sfa_ContractAllocationId.Id
                     join cdp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals cdp.sfa_ContractDeliverableId.Id
                     where
                        c.sfa_Version == contractVersionNumber &&
                        a.sfa_contractallocationnumber == allocationNumber &&
                        d.sfa_DeliverableCode == deliverableCode.ToString()
                     select new DeliverablePeriodInfo
                     {
                         Year = cdp.sfa_Year.Value,
                         Month = cdp.sfa_Period.Value,
                         PlannedVolume = cdp.sfa_PlannedVolume

                     })
                    .ToList();
            }
        }

        public class ContractInfo
        {
            public Guid Id { get; set; }

            public string ContractNumber { get; set; }

            public int ContractVersion { get; set; }

            public IReadOnlyCollection<AllocationInfo> Allocations { get; set; }
        }

        public class AllocationInfo
        {
            public string AllocationNumber { get; set; }

            public IReadOnlyCollection<DeliverableInfo> Deliverables { get; set; }
        }

        public class DeliverableInfo
        {
            public int DeliverableCode { get; set; }

            public decimal? TotalPlannedVolume { get; set; }

            public IReadOnlyCollection<DeliverablePeriodInfo> DeliverablePeriods { get; set; }
        }

        public class DeliverablePeriodInfo
        {
            public int Year { get; set; }

            public int Month { get; set; }

            public decimal? PlannedVolume { get; set; }
        }

        public class DeliverablePeriodValidateInfo
        {
            public string ContractNumber { get; set; }

            public string AllocationNumber { get; set; }

            public int DeliverableCode { get; set; }

            public decimal? TotalPlannedVolume { get; set; }

            public int Year { get; set; }

            public int Month { get; set; }

            public decimal? PlannedVolume { get; set; }

            public override string ToString()
            {
                return $"Deliverable Code: {DeliverableCode}, Year: {Year}, Month: {Month}";
            }
        }
    }
}
