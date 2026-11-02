namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities;
    using ContractManagement.DataStore.Model;

    public class ContractValidationLookupData
    {
        public ContractValidationLookupData()
        {
            PresenceCheckItems = new List<PresenceCheckItem>();
        }

        public List<string> ContractTypes { get; set; }

        public List<string> LocalEnterprisePartnerships { get; set; }

        public List<UnitOfProcurement> UnitsOfProcurement { get; set; }

        public List<string> InvestmentPriorities { get; set; }

        public List<string> RegionTypes { get; set; }

        public List<string> SpecificationTitles { get; set; }

        public Dictionary<string, FSCDeliverableStructureDefinitionResponse> FscDeliverableStructureData { get; set; }

        public List<PresenceCheckItem> PresenceCheckItems { get; set; }

        public IReadOnlyCollection<MatchingTenderAwardReferenceItem> MatchingTenderAwardReferenceItems { get; set; }

        public bool MultipleOverlappingContractsAllowedForFundingType { get; set; }

        public IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> FundingTypePeriodFundingStreamPeriods { get; set; }

        public IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> ProfileFundingStreamPeriodDeliverables { get; set; }

        public bool HasSiblingContractWithDraftStatus { get; set; }
    }
}
