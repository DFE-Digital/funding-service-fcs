namespace SFA.FCT.CrossDomain.Integration.Common.Atom
{
    using System;
    using System.Collections.Generic;

    public class PageStorageResultSet<T>
    {
        public IList<T> Rows { get; set; }

        public DateTime? LatestRowUpdatedTime { get; set; }

        public string MediaType { get; set; }

        public int PageSize { get; set; }

        public string Host { get; set; }

        //public long NumberOfItems { get; set; }

        public int? PageNumber { get; set; }

        public int? NextPageNumber { get; set; }

        public int? PrevPageNumber { get; set; }

        public string RoutePrefix { get; set; }

        public string RouteSuffix { get; set; }
    }
}
