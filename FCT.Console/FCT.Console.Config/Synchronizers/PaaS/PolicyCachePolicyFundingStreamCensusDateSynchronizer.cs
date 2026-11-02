namespace FCT.Console.Config.Synchronizers.PaaS
{
    using Excel;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PolicyCachePolicyFundingStreamCensusDateSynchronizer : PaymentTimetablesSheetReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            var fundingStreamCensusDates = ReadConfig(worksheetReader);
            PolicyCacheFundingStreamCensusDateWriter.WriteToPaaSDatabase(fundingStreamCensusDates, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            var fundingStreamCensusDates = ReadConfig(worksheetReader);
            PolicyCacheFundingStreamCensusDateWriter.WriteToPaaSDatabase(fundingStreamCensusDates, WriterBehaviour.Delete);
        }
    }
}
