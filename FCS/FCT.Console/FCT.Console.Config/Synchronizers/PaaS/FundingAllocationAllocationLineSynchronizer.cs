namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System;
    using Excel;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class FundingAllocationAllocationLineSynchronizer : AllocationLinesReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            var sheetObjects = ReadConfig(worksheetReader);

            FundingAllocationAllocationLineWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            var sheetObjects = ReadConfig(worksheetReader);

            FundingAllocationAllocationLineWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.Delete);
        }
    }
}
