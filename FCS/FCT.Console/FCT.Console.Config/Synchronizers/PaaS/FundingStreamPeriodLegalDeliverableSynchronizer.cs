namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Services;
    using Writers;
    using Writers.PAAS;

    public class FundingStreamPeriodLegalDeliverableSynchronizer : FundingStreamPeriodDeliverablesReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<FundingStreamPeriodDeliverablesSheetType> sheetTypes = ReadConfig(worksheetReader);
            
            IReadOnlyCollection<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesSheetTypes =
                LegalDeliverableExtractor.ExtractLegalDeliverables(sheetTypes);
            
            FundingStreamPeriodLegalDeliverableWriter.WriteToPaaSDatabase(fundingStreamPeriodDeliverablesSheetTypes,
                WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            // Delete not required. 
            // AddOrUpdateConfig method resets the whole table and adds the necessary rows.
        }
    }
}
