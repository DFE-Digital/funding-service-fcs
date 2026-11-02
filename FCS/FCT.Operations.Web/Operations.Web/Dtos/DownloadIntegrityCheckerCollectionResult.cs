namespace Operations.Web.Dtos
{
    using System.Collections.Generic;

    public class DownloadIntegrityCheckerCollectionResult
    {
        public DownloadIntegrityCheckerCollectionResult(int totalRowsInTable, IReadOnlyCollection<DownloadIntegrityCheckerCollection> downloadIntegrityResultCollection)
        {
            TotalRowsInTable = totalRowsInTable;
            DownloadIntegrityResultCollection = downloadIntegrityResultCollection;
        }

        public int TotalRowsInTable { get; }
        public IReadOnlyCollection<DownloadIntegrityCheckerCollection> DownloadIntegrityResultCollection { get; }
    }
}