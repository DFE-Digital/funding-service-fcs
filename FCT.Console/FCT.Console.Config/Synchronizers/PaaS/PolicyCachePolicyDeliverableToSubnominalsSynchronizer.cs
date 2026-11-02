namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PolicyCachePolicyDeliverableToSubnominalsSynchronizer : FundingStreamPeriodDeliverablesReader, ISynchronizeConfig
    {

        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverables = ReadConfig(worksheetReader);

            PolicyCachePolicyDeliverableToSubnominalsWriter.WriteToPaaSDatabase(fundingStreamPeriodDeliverables, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverables = ReadConfig(worksheetReader);

            PolicyCachePolicyDeliverableToSubnominalsWriter.WriteToPaaSDatabase(fundingStreamPeriodDeliverables, WriterBehaviour.Delete);
        }
    }
}
