namespace FCT.Console.Config.Json
{
    using Excel;
    using System.Collections.Generic;
    using System.Linq;
    using Synchronizers.Readers;
    using Newtonsoft.Json.Linq;
    using Dtos;

    public class WorkbookToJson : IWorkbookToJson
    {
        private readonly WorkbookReader _workbookReader;

        public WorkbookToJson(WorkbookReader workbookReader)
        {
            _workbookReader = workbookReader;
        }

        public string Transform()
        {
            var sheetToJObjectTransforms = GetSheetToRowsTransforms(_workbookReader);

            var completeJObject = new JObject();

            sheetToJObjectTransforms.ForEach(sheetToRowsTransform =>
            {
                var rows = sheetToRowsTransform.GetRows.Invoke(sheetToRowsTransform.SheetName);

                var sheetJObject = new JObject { { sheetToRowsTransform.SheetName, JArray.FromObject(rows) } };

                completeJObject.Merge(sheetJObject);
            });

            return completeJObject.ToString();
        }
       

        private static List<SheetToRowsTransform> GetSheetToRowsTransforms(WorkbookReader workbookReader)
        {
            var agencyCode = GetAgencyCode(workbookReader);

            return new List<SheetToRowsTransform>
            {
                new SheetToRowsTransform("Version History", sheetName => GetLatestVersion(workbookReader, sheetName)),
                new SheetToRowsTransform("Agency", sheetName => new AgencyReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Funding Type", sheetName => new FundingTypeReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Period Type", sheetName => new PeriodTypeReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Funding Period", sheetName => new FundingPeriodSheetTypeReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Funding Type Period", sheetName => new FundingTypePeriodReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Funding Stream", sheetName => new FundingStreamSheetReader().ReadConfig(workbookReader.WorksheetReader(sheetName), agencyCode)),
                new SheetToRowsTransform("FSP Groups", sheetName => new FspGroupReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Funding Stream Period", sheetName => new FundingStreamPeriodReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("FSP Capping Groups", sheetName => new FundingStreamPeriodCappingGroupsReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("FSP Pay Calc Policy", sheetName => new FundingStreamPeriodPayCalcPolicyReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("FSP CP Pay Calc Policy", sheetName => new FundingStreamPeriodCappingPeriodPayCalcPolicyReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Deliverable", sheetName => new DeliverablesReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Claim Types", sheetName => new ClaimTypeReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Claim Collections", sheetName => new ClaimCollectionsReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Claim Recon Alloc Groups", sheetName => new ClaimReconciliationAllocationGroupReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Claim Recon Alloc Group FSPs", sheetName => new ClaimReconAllocGroupFSPsReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Claim Reconciliation Behaviour", sheetName => new ClaimReconciliationBehaviourReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Claim Reconciliation Del Groups", sheetName => new ClaimReconciliationDelGroupsReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Claim Rec Ref Data - Profiles", sheetName => new ClaimReconciliationReferenceDataProfilesReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Claim Rec Ref Data - Exceptions", sheetName => new ClaimReconciliationPublicationExceptionReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Subnominal", sheetName =>  new SubnominalsReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Subnominal Payment Types", sheetName => new SubnominalPaymentTypesReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("FSP Deliverables", sheetName => new FundingStreamPeriodDeliverablesReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Region Types", sheetName => new RegionTypeReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("ESF Region Investment Priority", sheetName => new ESFRegionInvestmentPriorityReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Payment Timetables", sheetName => new PaymentTimetablesSheetReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Funding Type Stream Relationshi", sheetName => new FundingTypeStreamRelationshipReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Units of Procurement", sheetName => new UnitsOfProcurementReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Contract Type", sheetName => new ContractTypeReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("FTP-FSP", sheetName => new FundingTypePeriodFundingStreamPeriodReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("CDA Extracts", sheetName => new CdaExtractReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("CDA Extract FSPs", sheetName => new CdaExtractFspReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Actuals Collection Returns", sheetName => new ActualsCollectionReturnsReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("FSP Group Document Templates", sheetName => new FspGroupDocumentTemplateReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Contract Document Templates", sheetName => new ContractDocumentTemplateReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("FTP-CoT", sheetName => new FundingTypeFundingPeriodContractTypeReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("NLAP Contract Ref Data", sheetName => new NlapFundingConfigReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Contract Ref Data", sheetName => new ContractReferenceDataReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Allocation Provider Types", sheetName => new AllocationProviderTypesReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Allocation Lines", sheetName => new AllocationLinesReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Allocation Funding Streams", sheetName => new AllocationFundingStreamReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("PC-CT", sheetName => new CfsCodesToContractTypeReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Provider Category Exceptions", sheetName => new ProviderCategoryExceptionReader().ReadConfig(workbookReader.WorksheetReader(sheetName))),
                new SheetToRowsTransform("Claim Rec Ref Data - Recon Prof", sheetName => new ClaimReconciliationReferenceDataReconProfilingReader().ReadConfig(workbookReader.WorksheetReader(sheetName)))
            };
        }

        private static string GetAgencyCode(WorkbookReader workbookReader)
        {
            var worksheetReader = workbookReader.WorksheetReader("Agency");
            return new AgencyReader().ReadConfig(worksheetReader).First().AgencyShortCode;
        }

        private static IReadOnlyCollection<VersionHistory> GetLatestVersion(WorkbookReader workbookReader, string sheetName)
        {
            var worksheetReader = workbookReader.WorksheetReader(sheetName);
            return new List<VersionHistory>
            {
                new VersionHistory{ LatestVersion = worksheetReader.CellStringValue("B5") }
            };
        }

        private class VersionHistory
        {
            public string LatestVersion { get; set; }
        }
    }
}