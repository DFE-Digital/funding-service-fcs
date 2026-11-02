namespace ActualsPull.Adapters
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DTOs;

    public interface IDcAdapter
    {
        Task<IReadOnlyCollection<ClosedCollection>> GetClosedCollectionsSince(DateTime dateFrom);
    }
}