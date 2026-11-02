namespace FCT.Console.Config.Synchronizers.CRM
{
    using Excel;
    using Readers;
    using Writers;
    using Writers.CRM;

    public class CrmFundingStreamSynchronizer : FundingStreamSheetReader, ISynchronizeConfig
    {
        private readonly string _agencyCode;

        public CrmFundingStreamSynchronizer(string agencyCode) : base()
        {
            _agencyCode = agencyCode;
        }

        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            new CrmFundingStreamWriter().WriteToCrmDatabase(ReadConfig(worksheetReader, _agencyCode), WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            new CrmFundingStreamWriter().WriteToCrmDatabase(ReadConfig(worksheetReader, _agencyCode), WriterBehaviour.Delete);
        }
    }
}
