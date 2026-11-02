using SFA.FCT.AllocationDelivery.DataStore;
using SFA.FCT.AllocationDelivery.DataStore.Model;
using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Web;

namespace SFA.FCT.AllocationDeliveryDomain
{
    //TODO: rename to AllocationDeliveryPagedRepository, remove Add & Any
    public class Pager : IPager<AllocationDeliveryEntry>
    {
        private IAllocationDeliveryDbContext _context;
        private int _pageSize = 10;
        public int PageSize { get { return _pageSize; } }

        public Pager(IAllocationDeliveryDbContext allocationDeliveryDBContext)
        {
            _context = allocationDeliveryDBContext;
        }

        //public void Add(AllocationDeliveryEntry entity)
        //{
        //    _context.AllocationDeliveryEntries.Add(entity);
        //    _context.SaveChanges();
        //}

        //// Cannot be Mocked due to being an extension method.
        //[ExcludeFromCodeCoverage]
        //public bool Any()
        //{
        //    return _context.AllocationDeliveryEntries.Any();
        //}

        public StoragePage<AllocationDeliveryEntry> GetEntitiesForPage(int page)
        {
            int skip = page != 0 ? (page - 1) * _pageSize : 0;

            List<AllocationDeliveryEntry> deliveryFeed = _context.AllocationDeliveryEntries.OrderBy(ca => ca.ID).Skip(skip).Take(_pageSize).ToList();
            return new StoragePage<AllocationDeliveryEntry>()
            {
                PageNumber = page == 0 ? 1 : page,
                Rows = deliveryFeed
            };
        }

        public StoragePage<AllocationDeliveryEntry> GetEntitiesForLatestPage()
        {
            int pageCount = (int)Math.Ceiling((double)(_context.AllocationDeliveryEntries.Count() / (double)_pageSize));
            int skip = pageCount != 0 ? (pageCount - 1) * _pageSize : 0;


            List<AllocationDeliveryEntry> deliveryFeed = _context.AllocationDeliveryEntries.OrderBy(ca => ca.ID).Skip(skip).Take(_pageSize).ToList();
            return new StoragePage<AllocationDeliveryEntry>()
            {
                PageNumber = pageCount == 0 ? 1 : pageCount,
                Rows = deliveryFeed
            };
        }
    }
}