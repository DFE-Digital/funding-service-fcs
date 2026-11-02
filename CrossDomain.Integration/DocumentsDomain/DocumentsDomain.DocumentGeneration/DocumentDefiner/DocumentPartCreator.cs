namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentConfiguration;
    using Integration;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;

    public abstract class DocumentPartCreator
    {
        protected const string PeriodStringFormat = "{0:MMM} {0:yyyy}";

        protected const string EfaFundingTypeCode = "1619FUND";

        private readonly ITemplateRepository _templateRepository;

        protected IDocumentConfigurationSource DocumentConfigurationSource { get; private set; }

        protected ILogger Logger;

        protected DocumentPartCreator(ITemplateRepository templateRepository, IDocumentConfigurationSource documentConfigurationSource)
        {
            _templateRepository = templateRepository;
            DocumentConfigurationSource = documentConfigurationSource;
            Logger = new LoggerNullObject();
        }

        public abstract bool IsHeaderDocumentRequired { get; }

        public abstract string RequiredHeaderDocumentName { get; }

        public abstract bool IsDocumentPartRequired(contractType contract);

        public abstract IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(string masterContractNumber, contractType contract, string templateContainer);

        protected string GetNameOfTemplateActiveOnDate(string containerName, string startsWith, DateTime contractStartDate)
        {
            return _templateRepository.GetNameOfTemplateActiveOnDate(containerName, startsWith, contractStartDate);
        }

        protected int GetStartYearFromPeriod(period period)
        {
            string startYearString = period.period1.Substring(0, 2);
            int startYear;
            if (!int.TryParse(startYearString, out startYear))
            {
                throw new ApplicationException("Could not determine the start year from the period given");
            }

            startYear += 2000;
            return startYear;
        }
 
        protected int GetEndYearFromPeriod(period period)
        {
            string endYearString = period.period1.Substring(2, 2);
            int endYear;
            if (!int.TryParse(endYearString, out endYear))
            {
                throw new ApplicationException("Could not determine the end year from the period given");
            }

            endYear += 2000;
            return endYear;
        }

        protected int GetStartMonthFromPeriod(period period)
        {
            var startMonth = 8;
            switch (period.periodType.periodTypeCode)
            {
                case periodTypeCodeType.FY:
                case periodTypeCodeType.NONLEVY:
                    startMonth = 4;
                    break;
                case periodTypeCodeType.HTES:
                    startMonth = 1;
                    break;

                case periodTypeCodeType.HTES2:
                    startMonth = 11;
                    break;

                case periodTypeCodeType.ESF:
                    startMonth = 1;
                    break;
            }

            return startMonth;
        }

        protected int GetEndMonthFromPeriod(period period)
        {
            var endMonth = 7;
            switch (period.periodType.periodTypeCode)
            {
                case periodTypeCodeType.FY:
                case periodTypeCodeType.NONLEVY:
                    endMonth = 3;
                    break;
                case periodTypeCodeType.HTES:
                    endMonth = 3;
                    break;
                case periodTypeCodeType.HTES2:
                    endMonth = 12;
                    break;
                case periodTypeCodeType.ESF:
                    endMonth = 12;
                    break;
                case periodTypeCodeType.CTEC:
                    endMonth = 3;
                    break;
            }

            return endMonth;
        }

        protected bool IsInFyOne(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod, int periodStartYear, int periodEndYear)
        {
            return deliverablePeriod.year == periodStartYear || deliverablePeriod.period <= 3;
        }

        protected bool IsInFyTwo(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod, int periodStartYear, int periodEndYear)
        {
            return deliverablePeriod.year == periodEndYear && deliverablePeriod.period >= 4 && deliverablePeriod.period <= 7;
        }

        protected virtual string[] GetMonthsInPeriod(contractAllocationsContractAllocation contractAllocation)
        {
            int startYear = GetStartYearFromPeriod(contractAllocation.period);
            int startMonth = GetStartMonthFromPeriod(contractAllocation.period);
            int endYear = GetEndYearFromPeriod(contractAllocation.period);
            int endMonth = GetEndMonthFromPeriod(contractAllocation.period);
            var periodTypeCodesThatUseContractYearStartAndEnd = new List<periodTypeCodeType>
            {
                periodTypeCodeType.ESF,
                periodTypeCodeType.SB,
                periodTypeCodeType.HTES,
                periodTypeCodeType.HTES2,
                periodTypeCodeType.CTEC
            };

            if (periodTypeCodesThatUseContractYearStartAndEnd.Contains(contractAllocation.period.periodType.periodTypeCode))
            {
                startYear = contractAllocation.startDate.Year; 
                endYear = contractAllocation.endDate.Value.Year;
            }
            else if (contractAllocation.period.periodType.periodTypeCode == periodTypeCodeType.NONLEVY)
            {
                // Since the first period is Jan 18, but the contract documentation starts at Aug 17
                // use Year - 1
                startYear = contractAllocation.startDate.Year - 1; 
                endYear = contractAllocation.endDate.Value.Year;
            }

            List<string> result = new List<string>();

            while (startYear < endYear || (startYear == endYear && startMonth <= endMonth))
            {
                result.Add(string.Format(PeriodStringFormat, new DateTime(startYear, startMonth, 1)));
                startMonth++;
                if (startMonth == 13)
                {
                    startMonth = 1;
                    startYear++;
                }
            }

            return result.ToArray();
        }

        protected MergeFieldType[] GetMonthColumnHeaderMergeFields(string[] monthsInPeriod)
        {
            return monthsInPeriod
                .Select((m, i) => new MergeFieldType(string.Format("H{0}", i + 1), m))
                .ToArray();
        }

        protected List<MergeFieldType> GetDocumentHeaderFields(string masterContractNumber, contractType contract, contractAllocationsContractAllocation allocation)
        {
            contractor organisationDetails = allocation.HasDeliveryOrganisation() ? allocation.DeliveryOrganisationDetail : contract.contractor;

            List <MergeFieldType> mergeFields = new List<MergeFieldType>
            {
                new MergeFieldType("DocumentTitle", GetFundingAgreementDocumentTitleForAllocation(allocation)),
                new MergeFieldType("OrgName", organisationDetails.legalName),
                new MergeFieldType("MasterContractRef", masterContractNumber),
                new MergeFieldType("ContractRef", GetContractNumber(contract)),
                new MergeFieldType("UKPRN", organisationDetails.ukprn.ToString()),
                new MergeFieldType("HeaderText", allocation.fundingStream.fundingStreamCode == "AGE" ? "The AGE facility value is the value of grants you can use to support employers recruiting 16 to 18 apprentices and 19 to 24 apprentices. The value of the facility for each age group must be managed separately." : string.Empty),
                new MergeFieldType("AllocationStartDate", allocation.startDate.ToString("yyyy-MM-dd")),
                new MergeFieldType("AllocationEndDate", allocation.endDate?.ToString("yyyy-MM-dd") ?? string.Empty),
                new MergeFieldType("AllocationContractRef", allocation.contractAllocationNumber),
                new MergeFieldType("SpecificationTitle", allocation.SpecificationTitle),
                new MergeFieldType("LEP", allocation.LEPName),
                new MergeFieldType("TenderSpecificationRef", allocation.tenderSpecificationReference),
                new MergeFieldType("LOT", !String.IsNullOrWhiteSpace(allocation.lotReference) ? allocation.lotReference : "N/A"),
                new MergeFieldType("Agreement", allocation.AgreementNumber),
                new MergeFieldType("DeliveryOrgName", IsContractEfa(contract) ? allocation.description : null),
                new MergeFieldType("UPIN", organisationDetails.Upin)
            };

            return mergeFields;
        }

        protected virtual string GetContractNumber(contractType contract)
        {
            return $"{contract.contractNumber} v{contract.contractVersionNumber}";
        }

        protected bool IsContractEfa(contractType contract)
        {
            return contract.fundingType.fundingTypeCode == EfaFundingTypeCode;
        }

        protected string GetDeliverableNameForSummaryOfFunding(contractAllocationsContractAllocation contractAllocation, int deliverableCode)
        {
            return DocumentConfigurationSource.GetDeliverableNameForSummaryOfFunding(contractAllocation, deliverableCode);
        }

        private string GetFundingAgreementDocumentTitleForAllocation(contractAllocationsContractAllocation contractAllocation)
        {
            return DocumentConfigurationSource.GetFundingAgreementTitleFromAllocation(contractAllocation);
        }
    }
}
