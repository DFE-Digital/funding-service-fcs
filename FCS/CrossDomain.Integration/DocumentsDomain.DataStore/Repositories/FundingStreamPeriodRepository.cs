namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Models;
    using System.Collections.Concurrent;
    using System.Data.Entity;

    public class FundingStreamPeriodRepository : IFundingStreamPeriodRepository
    {
        private readonly DocumentsDomainDbContext _documentsDbContext;

        private static readonly ConcurrentDictionary<FspSetName, Lazy<IReadOnlyCollection<FundingStreamPeriod>>> CachedFsps =
            new ConcurrentDictionary<FspSetName, Lazy<IReadOnlyCollection<FundingStreamPeriod>>>();
           
        public FundingStreamPeriodRepository(DocumentsDomainDbContext documentsDbContext)
        {
            _documentsDbContext = documentsDbContext;
        }

        public FundingStreamPeriod GetByKey(string fundingStreamPeriodCode)
        {
            return GetCachedAllFsps().SingleOrDefault(f => f.FundingStreamPeriodCode == fundingStreamPeriodCode);
        }

        public IReadOnlyCollection<FundingStreamPeriod> GetAll()
        {
            return GetCachedAllFsps().ToList();
        }

        public IReadOnlyCollection<FundingStreamPeriod> GetFspsWithGroups(IEnumerable<string> fspCodes)
        {
            return GetCachedFspsWithGroups()
                .Where(f => fspCodes.Contains(f.FundingStreamPeriodCode))
                .ToList();
        }

        public IReadOnlyCollection<string> GetFspGroupDisplayNames(IReadOnlyCollection<string> fspCodes)
        {
            return GetCachedFspsWithGroups()
                .Where(fsp => fspCodes.Contains(fsp.FundingStreamPeriodCode))
                .OrderBy(fsp => fsp.FspGroup.DisplayOrder)
                .Select(f => f.FspGroup.ContractDocumentDisplayName)
                .Distinct()
                .ToList();
        }

        public IReadOnlyCollection<FSPGroup> GetFspGroups(IReadOnlyCollection<string> fspCodes)
        {
            return _documentsDbContext.FundingStreamPeriods
                .Where(fsp => fspCodes.Contains(fsp.FundingStreamPeriodCode) && fsp.FspGroup != null)
                .Select(fsp => fsp.FspGroup)
                .Distinct()
                .ToList();
        }

        private IReadOnlyCollection<FundingStreamPeriod> GetCachedFspsWithGroups()
        {
            const string fspsWithGroups = "FSPs_With_Groups";

            return CachedFsps.GetOrAdd(fspsWithGroups,
                _ => new Lazy<IReadOnlyCollection<FundingStreamPeriod>>(GetFspsWithGroupsFromDb))
                .Value;
        }

        private IReadOnlyCollection<FundingStreamPeriod> GetFspsWithGroupsFromDb()
        {
            return _documentsDbContext.FundingStreamPeriods
                .AsNoTracking()
                .Where(fsp => fsp.FSPGroupCode != null)
                .Include(fsp => fsp.FspGroup)
                .ToList();
        }

        private IReadOnlyCollection<FundingStreamPeriod> GetCachedAllFsps()
        {
            const string allFsps = "All_FSPs";

            return CachedFsps.GetOrAdd(allFsps,
                    _ => new Lazy<IReadOnlyCollection<FundingStreamPeriod>>(GetAllFspsFromDb))
                .Value;
        }

        private IReadOnlyCollection<FundingStreamPeriod> GetAllFspsFromDb()
        {
            return _documentsDbContext.FundingStreamPeriods.ToList();
        }

        /// <summary>
        /// This type behaves like a string
        /// </summary>
        private class FspSetName
        {
            private readonly string _text;
            private FspSetName(string text)
            {
                _text = text;
            }

            public static implicit operator FspSetName(string d)
            {
                return new FspSetName(d);
            }

            public override bool Equals(object obj)
            {
                return obj is FspSetName other && _text == other._text;
            }

            public override int GetHashCode()
            {
                return _text.GetHashCode();
            }
        }
    }
}
