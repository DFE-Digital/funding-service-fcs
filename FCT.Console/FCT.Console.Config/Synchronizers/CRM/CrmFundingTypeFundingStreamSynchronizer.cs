
namespace FCT.Console.Config.Synchronizers.CRM
{
    using Excel;
    using Readers;
    using Writers;
    using Writers.CRM;

    public class CrmFundingTypeFundingStreamSynchronizer : FundingTypeStreamRelationshipReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            new CrmFundingTypeFundingStreamWriter().WriteToCrmDatabase(ReadConfig(worksheetReader), WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            new CrmFundingTypeFundingStreamWriter().WriteToCrmDatabase(ReadConfig(worksheetReader), WriterBehaviour.Delete);
        }
    }
}
