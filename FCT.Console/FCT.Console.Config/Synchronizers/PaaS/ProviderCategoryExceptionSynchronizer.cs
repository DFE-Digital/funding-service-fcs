namespace FCT.Console.Config.Synchronizers.PaaS
{
    using Excel;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class ProviderCategoryExceptionSynchronizer: ProviderCategoryExceptionReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            var providerCategoryExceptions = ReadConfig(worksheetReader);
            ProviderCategoryExceptionWriter.WriteToPaas(providerCategoryExceptions, WriterBehaviour.AddOrUpdate).Wait();
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            var providerCategoryExceptions = ReadConfig(worksheetReader);
            ProviderCategoryExceptionWriter.WriteToPaas(providerCategoryExceptions, WriterBehaviour.Delete).Wait();
        }
    }
}
