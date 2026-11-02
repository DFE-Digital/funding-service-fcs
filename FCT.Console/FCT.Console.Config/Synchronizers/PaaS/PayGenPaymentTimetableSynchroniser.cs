namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PayGenPaymentTimetableSynchroniser : PaymentTimetablesSheetReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<PaymentTimetablesSheetType> sheetObjects = ReadConfig(worksheetReader);

            PayGenPaymentTimetableWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<PaymentTimetablesSheetType> sheetObjects = ReadConfig(worksheetReader);

            PayGenPaymentTimetableWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.Delete);
        }
    }
}
