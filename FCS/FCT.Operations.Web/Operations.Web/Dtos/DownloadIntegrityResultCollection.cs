namespace Operations.Web.Dtos
{
    using System;

    public class DownloadIntegrityCheckerCollection
    {

        private DownloadIntegrityCheckerCollection()
        { }
        public DownloadIntegrityCheckerCollection(
            string checkerType,
            string status,
            DateTime startDate,
            DateTime finishDate,
            string outcome,
            string link,
            int totalRowsInTable)
        {
            CheckerType = checkerType;
            StartDate = startDate;
            FinishDate = finishDate;
            Status = status;
            Outcome = outcome;
            Link = link;
            TotalRowsInTable = totalRowsInTable;
        }

        public string CheckerType { get; set;}
        public DateTime StartDate { get; set; }
        public DateTime FinishDate { get; set; }
        public string Status { get; set; }
        public string Outcome { get; set; }
        public string Link { get; set; }
        public int TotalRowsInTable { get; set; }
    }
}