namespace AllocationDeliveryDomain.Endpoint.ActualsPull
{
    using System;
    using Adapters;

    public static class DcAdapterExtensions
    {
        public static int GetNumPages(this IDcAdapter adapter, int totalNumberOfRows, int pageSize)
        {
            var remainder = (double) totalNumberOfRows % pageSize;

            var numWholePages = totalNumberOfRows / pageSize;

            if (remainder > 0)
            {
                return numWholePages + 1;
            }

            return numWholePages;
        }
    }
}
