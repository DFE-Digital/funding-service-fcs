namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using Transformers;

    public static class FspGroupWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FspGroupSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                var writer = new ConfigWriter<FspGroupSheetType, FSPGroup>(context, context.FSPGroups);

                writer.Write(
                    sheetConfigTypes: rows,
                    transformSheetTypes: TypeTransformer.TransformCollection<FspGroupSheetType, FSPGroup>,
                    getKey:r => new object[] {r.FSPGroupCode},
                    behaviour: behaviour);

                context.SaveChanges();
            }
        }
    }
}
