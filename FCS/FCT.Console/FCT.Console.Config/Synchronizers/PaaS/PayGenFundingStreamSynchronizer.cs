namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PayGenFundingStreamSynchronizer : FundingStreamSheetReader, ISynchronizeConfig
    {
        private readonly string _agencyCode; 

        public PayGenFundingStreamSynchronizer(string agencyCode) : base()
        {
            _agencyCode = agencyCode;
        }

        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamSheetType> fundingStreams = ReadConfig(worksheetReader, _agencyCode);

            PayGenFundingStreamWriter.WriteToPaaSDatabase(fundingStreams, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamSheetType> fundingStreams = ReadConfig(worksheetReader, _agencyCode);

            PayGenFundingStreamWriter.WriteToPaaSDatabase(fundingStreams, WriterBehaviour.Delete);
        }
    }
}
