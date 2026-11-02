namespace Operations.Web.Dtos
{
    using System.Collections.Generic;

    public class CfsImportInfoResult
    {
        public CfsImportInfoResult(int totalRowsInTable, IReadOnlyCollection<CfsImportInfo> cfsImportInfos)
        {
            TotalRowsInTable = totalRowsInTable;
            CfsImportInfos = cfsImportInfos;
        }

        public int TotalRowsInTable { get; }
        public IReadOnlyCollection<CfsImportInfo> CfsImportInfos { get; }
    }
}