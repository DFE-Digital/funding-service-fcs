namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PolicyCachePolicyDeliverableSynchronizer : FundingStreamPeriodDeliverablesReader, ISynchronizeConfig
    {

        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverables = ReadConfig(worksheetReader);

            PolicyCachePolicyDeliverableWriter.WriteToPaaSDatabase(fundingStreamPeriodDeliverables, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverables = ReadConfig(worksheetReader);

            PolicyCachePolicyDeliverableWriter.WriteToPaaSDatabase(fundingStreamPeriodDeliverables, WriterBehaviour.Delete);
        }
    }
}