namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System;
    using Excel;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class FundingAllocationAllocationProviderTypesSynchronizer : AllocationProviderTypesReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            var sheetObjects = ReadConfig(worksheetReader);

            FundingAllocationProviderTypeWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            throw new NotImplementedException("DeleteConfig not implemented in FundingAllocationAllocationProviderTypesSynchronizer");
        }
    }
}
