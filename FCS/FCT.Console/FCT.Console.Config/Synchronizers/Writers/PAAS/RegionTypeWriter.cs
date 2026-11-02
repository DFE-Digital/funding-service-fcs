namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Transformers;

    public class RegionTypeWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<RegionTypeSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new ContractManagementDbContext())
            {
                ConfigWriter<RegionTypeSheetType, RegionType> writer =
                    new ConfigWriter<RegionTypeSheetType, RegionType>(context, context.RegionTypes);

                writer.Write(rows, TypeTransformer.TransformCollection<RegionTypeSheetType, RegionType>, GetKeyForRegionType, behaviour);
                context.SaveChanges();
            }
        }

        private static object[] GetKeyForRegionType(RegionType regionTypeModel)
        {
            return new object[]
            {
                regionTypeModel.RegionTypeCode
            };
        }
    }
}
