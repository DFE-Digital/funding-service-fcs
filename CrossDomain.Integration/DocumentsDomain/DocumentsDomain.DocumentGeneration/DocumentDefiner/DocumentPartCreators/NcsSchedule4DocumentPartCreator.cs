namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Models;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentConfiguration;
    using Extensions;
    using Integration;

    public class NcsSchedule4DocumentPartCreator : DocumentPartCreator
    {
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;

        public NcsSchedule4DocumentPartCreator(ITemplateRepository templateRepository,
                            IDocumentConfigurationSource documentConfigurationSource,
                            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository)
            : base(templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName
        {
            get
            {
                 throw new InvalidOperationException("NcsSchedule4DocumentPartCreator was asked for a header document name but said it didn't need one.");
            }
        }

        public override bool IsDocumentPartRequired(contractType contract)
        {
            return contract.fundingType.fundingTypeCode == "NCS" && IsNotASchedule6Period(contract.period.period1);
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(string masterContractNumber, contractType contract, string templateContainer)
        {
            Dictionary<string, contractAllocationsContractAllocation> allocationByFundingStream =
                new Dictionary<string, contractAllocationsContractAllocation>
                {
                    { "NCSC",     GetContractAllocationByFsps(contract, "NCS-C1718", "NCS-C2018") },
                    { "NCSP",     GetContractAllocationByFsps(contract, "NCS-P1718") },
                    { "NCSI",     GetContractAllocationByFsps(contract, "NCS-I1718", "NCS-I2018") },
                    { "NCSIC",    GetContractAllocationByFsps(contract, "NCS-IC1718") },
                    { "NCSEA",    GetContractAllocationByFsps(contract, "NCS-EA1718") },
                    { "NCSFW",    GetContractAllocationByFsps(contract, "NCS-FWL1718") },
                    { "NCSASIST", GetContractAllocationByFsps(contract, "NCS-ASIST1718") },
                    { "NCSSEED",  GetContractAllocationByFsps(contract, "NCS-SEEDIC1718") },
                };

            string contractDocTemplatePrefix =
                _fundingTypeFundingPeriodQueryRepository.Get(
                    contract.fundingType.fundingTypeCode,
                    contract.GetFundingPeriod())
                .TemplateName;

            DocumentGenerationRequest documentGenerationRequest = new DocumentGenerationRequest
            {
                TemplateContainer = templateContainer,
                TemplateFilename = GetNameOfTemplateActiveOnDate(templateContainer, contractDocTemplatePrefix, contract.startDate.GetValueOrDefault()),
                MergeData = new DocumentGenerationRequestMergeData
                {
                    MergeFields = new List<MergeFieldType>
                    {
                        new MergeFieldType("ContractDescription", contract.description),
                        new MergeFieldType("ContractTotal",      contract.contractValue.ToString()),
                        new MergeFieldType("ProviderName",       contract.GetProviderName()),

                        new MergeFieldType("NCSCValue",          allocationByFundingStream["NCSC"].GetAllocationValue()), 
                        new MergeFieldType("NCSCDel6Volume",     allocationByFundingStream["NCSC"].GetDeliverableVolume(6)),
                        new MergeFieldType("NCSCMar18Value",     allocationByFundingStream["NCSC"].GetMar18Value()),
                        new MergeFieldType("NCSCTotalValue",     allocationByFundingStream["NCSC"].GetAllocationValue()),

                        new MergeFieldType("NCSPValue",          allocationByFundingStream["NCSP"].GetAllocationValue()),
                        new MergeFieldType("NCSPDel6Volume",     allocationByFundingStream["NCSP"].GetDeliverableVolume(6)),

                        new MergeFieldType("NCSIMay17Value",     allocationByFundingStream["NCSI"].GetMay17Value()),
                        new MergeFieldType("NCSISep18Value",     allocationByFundingStream["NCSI"].GetSep18Value()),
                        new MergeFieldType("NCSIOct17Value",     allocationByFundingStream["NCSI"].GetOct17Value()),
                        new MergeFieldType("NCSIMar18Value",     allocationByFundingStream["NCSI"].GetMar18Value()),
                        new MergeFieldType("NCSIApr18Value",     allocationByFundingStream["NCSI"].GetApr18Value()),
                        new MergeFieldType("NCSITotalValue",     allocationByFundingStream["NCSI"].GetAllocationValue()),
                                                                                            
                        new MergeFieldType("NCSICJuly17Value",   allocationByFundingStream["NCSIC"].GetJul17Value()),
                        new MergeFieldType("NCSICSept17Value",   allocationByFundingStream["NCSIC"].GetSept17Value()),
                        new MergeFieldType("NCSICDec17Value",    allocationByFundingStream["NCSIC"].GetDec17Value()),
                        new MergeFieldType("NCSICMar18Value",    allocationByFundingStream["NCSIC"].GetMar18Value()),
                        new MergeFieldType("NCSICTotalValue",    allocationByFundingStream["NCSIC"].GetAllocationValue()),

                        new MergeFieldType("NCSEANov17Value",    allocationByFundingStream["NCSEA"].GetNov17Value()),
                        new MergeFieldType("NCSEADec17Value",    allocationByFundingStream["NCSEA"].GetDec17Value()),
                        new MergeFieldType("NCSEAMar18Value",    allocationByFundingStream["NCSEA"].GetMar18Value()),
                        new MergeFieldType("NCSEATotalValue",    allocationByFundingStream["NCSEA"].GetAllocationValue()),

                        new MergeFieldType("NCSFWLDec17Value",    allocationByFundingStream["NCSFW"].GetDec17Value()),
                        new MergeFieldType("NCSFWLMar18Value",    allocationByFundingStream["NCSFW"].GetMar18Value()),
                        new MergeFieldType("NCSFWLTotalValue",    allocationByFundingStream["NCSFW"].GetAllocationValue()),

                        new MergeFieldType("NCSASISTFeb18Value", allocationByFundingStream["NCSASIST"].GetFeb18Value()),
                        new MergeFieldType("NCSASISTMar18Value", allocationByFundingStream["NCSASIST"].GetMar18Value()),
                        new MergeFieldType("NCSASISTTotalValue", allocationByFundingStream["NCSASIST"].GetAllocationValue()),

                        new MergeFieldType("NCSSEEDICFeb18Value",  allocationByFundingStream["NCSSEED"].GetFeb18Value()),
                        new MergeFieldType("NCSSEEDICMar18Value",  allocationByFundingStream["NCSSEED"].GetMar18Value()),
                        new MergeFieldType("NCSSEEDICTotalValue",  allocationByFundingStream["NCSSEED"].GetAllocationValue())
                    }
                }
            };

            return new Dictionary<string, DocumentGenerationRequest>()
            {
                { "1000", documentGenerationRequest }
            };
        }

        private static bool IsNotASchedule6Period(string period)
        {
            return NcsSchedule6DocumentPartCreator.Schedule6Periods.Contains(period) == false;
        }
        
        private static contractAllocationsContractAllocation GetContractAllocationByFsps(contractType contract, params string[] fsps)
        {
            return fsps.Select(fsp => GetContractAllocationByFsp(fsp, contract)).FirstOrDefault(ca => ca != null);
        }

        private static contractAllocationsContractAllocation GetContractAllocationByFsp(string fundingStreamPeriodCode, contractType contract)
        {
            return contract.contractAllocations.SingleOrDefault(ca => ca.fundingStreamPeriodCode == fundingStreamPeriodCode);
        }
    }
}
