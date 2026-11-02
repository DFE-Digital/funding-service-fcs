namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentConfiguration
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Models;
    using DataStore.Repositories;
    using DocumentPartCreators.Extensions;
    using Dtos;

    public class DocumentConfigurationSource : IDocumentConfigurationSource
    {
        private readonly IFundingStreamPeriodRepository _fundingStreamPeriodRepository;
        private readonly IFspDeliverableRepository _fspDeliverableRepository;
        private static IDictionary<string, DataStore.Models.FundingStreamPeriod> _allocationSettingsForSummaryOfFunding;
        private readonly IFundingTypeFundingPeriodRepository _fundingTypeFundingPeriodRepository;

        public DocumentConfigurationSource(IFundingStreamPeriodRepository fundingStreamPeriodRepository, IFspDeliverableRepository fspDeliverableRepository, IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository)
        {
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
            _fspDeliverableRepository = fspDeliverableRepository;
            _fundingTypeFundingPeriodRepository = fundingTypeFundingPeriodRepository;
        }

        protected virtual IDictionary<string, DataStore.Models.FundingStreamPeriod> AllocationSettingsForSummaryOfFunding
        {
            get
            {
                if (_allocationSettingsForSummaryOfFunding == null)
                {
                    _allocationSettingsForSummaryOfFunding =
                        _fundingStreamPeriodRepository.GetAll().ToDictionary(fsp => fsp.FundingStreamPeriodCode);
                }

                return _allocationSettingsForSummaryOfFunding;
            }
        }

        public int GetFundingStreamPeriodDisplayOrder(contractAllocationsContractAllocation contractAllocation)
        {
            string fspCode = contractAllocation.fundingStreamPeriodCode;

            return GetCacheFundingStreamPeriod(fspCode)?.DisplayOrder ?? -1;
        }

        public bool ShouldDisplayDeliverableOnSummaryOfFunding(contractAllocationsContractAllocation contractAllocation, contractDeliverablesTypeContractDeliverable deliverable)
        {
            FspDeliverableKey fspDeliverableKey = new FspDeliverableKey(
                fundingStreamPeriodCode: contractAllocation.fundingStreamPeriodCode,
                deliverableCode: deliverable.deliverable.deliverableCode);

            return GetCacheFspDeliverable(fspDeliverableKey).DisplayOnSummaryOfFunding;
        }

        public bool ShouldDisplayDeliverableOnSummaryOfFunding(string fundingStreamPeriodCode, int deliverableCode)
        {
            FspDeliverableKey fspDeliverableKey = new FspDeliverableKey(
                fundingStreamPeriodCode: fundingStreamPeriodCode,
                deliverableCode: deliverableCode);

            return GetCacheFspDeliverable(fspDeliverableKey).DisplayOnSummaryOfFunding;
        }

        public string GetAllocationName(contractAllocationsContractAllocation allocation)
        {
            string displayNameFromConfig = GetCacheFundingStreamPeriod(allocation.GetFundingStreamPeriodCode())?.SummaryOfFundingDisplayName;

            if (string.IsNullOrEmpty(displayNameFromConfig))
            {
                return allocation.description;
            }

            return displayNameFromConfig;
        }

        public string GetDeliverableNameForSummaryOfFunding(contractAllocationsContractAllocation allocation, int deliverableCode)
        {
            string fspCode = allocation.fundingStreamPeriodCode;

            FspDeliverableKey fspDeliverableKey = new FspDeliverableKey(fspCode, deliverableCode);

            return GetCacheFspDeliverable(fspDeliverableKey).DisplayNameOnSummaryOfFunding ?? string.Empty;
        }

        public string GetDeliverableNameForSummaryOfFunding(string fundingStreamPeriodCode, int deliverableCode)
        {
            FspDeliverableKey fspDeliverableKey = new FspDeliverableKey(fundingStreamPeriodCode, deliverableCode);

            return GetCacheFspDeliverable(fspDeliverableKey).DisplayNameOnSummaryOfFunding ?? string.Empty;
        }

        public bool IsFundingAgreementRequiredForAllocation(contractAllocationsContractAllocation contractAllocation)
        {
            string fspCode = contractAllocation.fundingStreamPeriodCode;

            return GetCacheFundingStreamPeriod(fspCode).ShouldGenerateFundingAgreement;
        }

        public string GetFundingAgreementTitleFromAllocation(contractAllocationsContractAllocation contractAllocation)
        {
            string fspCode = contractAllocation.fundingStreamPeriodCode;

            string displayName = GetCacheFundingStreamPeriod(fspCode)?.FundingAgreementDisplayName;

            return string.IsNullOrEmpty(displayName) ? contractAllocation.description : displayName;
        }

        public DeliverableConfiguration GetDeliverableConfigurationForFundingAgreement(contractAllocationsContractAllocation contractAllocation, int deliverableCode)
        {
            string fspCode = contractAllocation.fundingStreamPeriodCode;

            // del code 0 is a "total" row - aggregate of all deliverables for which allow profile is true
            if (deliverableCode == 0) 
            {
                return _fspDeliverableRepository
                    .GetFspDeliverablesForFundingStreamPeriod(fspCode)
                    .Where(fspDel => fspDel.AllowProfile)
                    .ToAggregateDeliverableConfiguration();
            }

            FspDeliverableKey fspDeliverableKey = new FspDeliverableKey(fspCode, deliverableCode);

            return GetCacheFspDeliverable(fspDeliverableKey)?.ToDeliverableConfiguration() ?? DeliverableConfiguration.NullConfiguration;
        }

        public DeliverableConfiguration[] GetMandatoryDeliverablesOnFundingAgreementForAllocation(contractAllocationsContractAllocation contractAllocation)
        {
            var mandatoryDeliverables = _fspDeliverableRepository
                .GetFspDeliverablesForFundingStreamPeriod(contractAllocation.fundingStreamPeriodCode)
                .Where(cfg => cfg.MandatoryOnFundingAgreement)
                .ToList();
            
            mandatoryDeliverables.Add(GetTotalFspDeliverable(contractAllocation.fundingStreamPeriodCode));

            return mandatoryDeliverables
                .Select(cfg => GetDeliverableConfigurationForFundingAgreement(contractAllocation, cfg.DeliverableCode))
                .ToArray();
        }

        public FundingAgreementTemplate GetFundingAgreementTemplateNamesForAllocation(string fundingStream, string fundingStreamPeriodCode, string fundingType)
        {
            if (fundingStream == "APPS" && fundingType == "MAIN")
            {
                return new FundingAgreementTemplate("A2_MAIN{0}", string.Empty);
            }
            
            DataStore.Models.FundingStreamPeriod fsp = GetCacheFundingStreamPeriod(fundingStreamPeriodCode);

            return new FundingAgreementTemplate(fsp.Template, fsp.ExtraPagesTemplate);
        }

        public IEnumerable<DeliverableConfiguration> GetDeliverableConfigurationForSummaryOfFunding(contractType contract)
        {
            return contract.contractAllocations.Select(ca => ca.fundingStreamPeriodCode)
                .SelectMany(_fspDeliverableRepository.GetFspDeliverablesForFundingStreamPeriod)
                .Where(x => x.MandatoryOnFundingAgreement)
                .Select(x => x.ToDeliverableConfiguration());
        }

        public FundingTypeFundingPeriod GetFundingTypeFundingPeriod(string fundingTypeCode, string fundingPeriodName)
        {
            return _fundingTypeFundingPeriodRepository.Get(fundingTypeCode, fundingPeriodName);
        }

        private DataStore.Models.FundingStreamPeriod GetCacheFundingStreamPeriod(string fspCode)
        {
            return DocumentConfigurationCache.GetFundingStreamPeriod(fspCode, _fundingStreamPeriodRepository.GetByKey);
        }

        private FSPDeliverable GetCacheFspDeliverable(FspDeliverableKey fspDeliverableKey)
        {
            return DocumentConfigurationCache.GetFspDeliverable(fspDeliverableKey,
                k => _fspDeliverableRepository.GetFspDeliverable(k.FundingStreamPeriodCode, k.DeliverableCode));
        }

        private FSPDeliverable GetTotalFspDeliverable(string fspCode)
        {
            return new FSPDeliverable(
                deliverableCode: 0, 
                fundingStreamPeriodCode: fspCode, 
                allowProfile: true, 
                displayOnFundingAgreement: true, 
                mandatoryOnFundingAgreement: true, 
                displayOrderOnFundingAgreement: 0, 
                allowCustomDescription: false, 
                shouldDisplayValue: true, 
                shouldDisplayVolumeAndUnitCost: false, 
                displayNameOnSummaryOfFunding: string.Empty, 
                displayNameOnFundingAgreement: string.Empty, 
                displayOnSummaryOfFunding: false);
        }
    }
}