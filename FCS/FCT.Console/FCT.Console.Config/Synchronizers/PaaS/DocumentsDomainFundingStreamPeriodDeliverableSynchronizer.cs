namespace FCT.Console.Config.Synchronizers.PaaS
{
    using Excel;
    using Readers;
    using System.Collections.Generic;
    using ExcelTypes;
    using Writers;
    using Writers.PAAS;

    public class DocumentsDomainFundingStreamPeriodDeliverableSynchronizer : FundingStreamPeriodDeliverablesReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverables = ReadConfig(worksheetReader);

            DocumentsDomainFSPDeliverableWriter.WriteToPaaSDatabase(fundingStreamPeriodDeliverables, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverables = ReadConfig(worksheetReader);

            DocumentsDomainFSPDeliverableWriter.WriteToPaaSDatabase(fundingStreamPeriodDeliverables, WriterBehaviour.Delete);
        }
    }
}