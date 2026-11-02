namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix2
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Globalization;
    using System.Linq;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentConfiguration;
    using Extensions;
    using Integration;
    using contractType = CrossDomain.Integration.Entities.CorporateContract.contractType;

    public class EsfRound1Appendix2DocumentCreator : DocumentPartCreator
    {
        private const string TemplateName = "A2_ESF201420CLOSURE_2014-01-01.docx";
        public EsfRound1Appendix2DocumentCreator(ITemplateRepository templateRepository, IDocumentConfigurationSource documentConfigurationSource) : base(templateRepository, documentConfigurationSource)
        {
        }

        public override bool IsHeaderDocumentRequired => false;
        public override string RequiredHeaderDocumentName => Appendix2HeaderCreator.HeaderName;
        public override bool IsDocumentPartRequired(contractType contract)
        {
            return contract.IsRoundOneEsf();
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            var allocations = contract.contractAllocations
                .Where(a => DocumentConfigurationSource.IsFundingAgreementRequiredForAllocation(a)).ToList();

            var docGenerationRequests = allocations.Select(a => GetDocumentGenerationRequest(a, masterContractNumber, contract, templateContainer));

            return docGenerationRequests.ToDictionary(d => d.Order, d => d.DocumentGenerationRequest);
        }

        private DocumentGenerationRequestWithOrder GetDocumentGenerationRequest(
            contractAllocationsContractAllocation allocation,
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            int fspDisplayOrder = DocumentConfigurationSource.GetFundingStreamPeriodDisplayOrder(allocation);

            var mergeFields = new List<MergeFieldType>();
            mergeFields.AddRange(GetDocumentHeaderFields(masterContractNumber, contract, allocation));

            List<RepeatingSectionType> repeatingSections = GetDeliverablesRepeatingSection(allocation);

            DocumentGenerationRequest docGenRequest = new DocumentGenerationRequest
            {
                TemplateContainer = templateContainer,
                TemplateFilename = TemplateName,
                GroupId = allocation.contractAllocationNumber,
                MergeData = new DocumentGenerationRequestMergeData()
                {
                    MergeFields = mergeFields,
                    RepeatingSections = repeatingSections
                }
            };

            return new DocumentGenerationRequestWithOrder(docGenRequest, $"200{fspDisplayOrder}{allocation.contractAllocationNumber}");
        }

        private List<RepeatingSectionType> GetDeliverablesRepeatingSection(contractAllocationsContractAllocation allocation)
        {
            List<RowTypeWithCashValue> rowTypeWithCashValues = allocation.contractDeliverables
                .Select(d => new
                {
                    Deliverable = d,
                    Config = DocumentConfigurationSource.GetDeliverableConfigurationForFundingAgreement(allocation,
                        d.deliverable.deliverableCode)
                })
                .Where(d => d.Config.IncludeOnFundingAgreement)
                .Select(d =>
                    GetRowTypeForDeliverable(d.Deliverable, d.Config.DisplayName, d.Config.ShouldDisplayUnitCost))
                .ToList();

            AddTotalRow(rowTypeWithCashValues);

            return new List<RepeatingSectionType>
            {
                new RepeatingSectionType
                {
                    Name = "MainTable",
                    Rows = rowTypeWithCashValues.Select(rt => rt.RowType).ToList()
                }
            };
        }

        private static void AddTotalRow(IList<RowTypeWithCashValue> rowTypeWithCashValues)
        {
            decimal total = rowTypeWithCashValues.Sum(r => r.CashValue);

            rowTypeWithCashValues.Add(new RowTypeWithCashValue(new RowType
            {
                MergeFields = new List<MergeFieldType>
                {
                    new MergeFieldType("Name", "Total Funding").MakeValueBold(),
                    new MergeFieldType("UnitCost", string.Empty),
                    new MergeFieldType("Volume", string.Empty),
                    new MergeFieldType("Cash", total.ToString(CultureInfo.InvariantCulture))
                }
            }, 0));
        }

        private static RowTypeWithCashValue GetRowTypeForDeliverable(contractDeliverablesTypeContractDeliverable deliverable, string displayName, bool displayVolAndUnitCost)
        {
            string formatString = ConfigurationManager.AppSettings["DocumentGeneration.UnitCostFormat"];

            string FormatUnitCost(decimal d) => string.Format(formatString, d);
            decimal cashTotal = displayVolAndUnitCost ? deliverable.GetDeliverableVolumeCost() : deliverable.GetDeliverableValue();

            return new RowTypeWithCashValue(
                rowType: new RowType
                {
                    MergeFields = new List<MergeFieldType>
                    {
                        new MergeFieldType("Name",
                            deliverable.deliverableDescription.GetValueOrDefault(displayName)),
                        new MergeFieldType("UnitCost",
                            displayVolAndUnitCost ? FormatUnitCost(deliverable.GetDeliverableUnitCost()) : "N/A"),
                        new MergeFieldType("Volume",
                            displayVolAndUnitCost
                                ? deliverable.GetDeliverableVolume().ToString(CultureInfo.InvariantCulture)
                                : "N/A"),
                        new MergeFieldType("Cash", cashTotal.ToString(CultureInfo.InvariantCulture))
                    }
                },
                cashValue: cashTotal);
        }

        private class DocumentGenerationRequestWithOrder
        {
            public DocumentGenerationRequest DocumentGenerationRequest { get; }

            public string Order { get; }

            public DocumentGenerationRequestWithOrder(DocumentGenerationRequest documentGenerationRequest, string order)
            {
                DocumentGenerationRequest = documentGenerationRequest;
                Order = order;
            }
        }

        private class RowTypeWithCashValue
        {
            public RowType RowType { get; }

            public decimal CashValue { get; }

            public RowTypeWithCashValue(RowType rowType, decimal cashValue)
            {
                RowType = rowType;
                CashValue = cashValue;
            }
        }
    }
}
