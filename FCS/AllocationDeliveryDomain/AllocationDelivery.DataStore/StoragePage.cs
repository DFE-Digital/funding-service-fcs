namespace SFA.FCT.AllocationDelivery.DataStore
{
    using System.Collections.Generic;
    public class StoragePage<T>
    {
        public StoragePage()
        {
            Rows = new List<T>();
        }

        public IList<T> Rows { get; set; }

        public int PageNumber { get; set; }
    }
}
