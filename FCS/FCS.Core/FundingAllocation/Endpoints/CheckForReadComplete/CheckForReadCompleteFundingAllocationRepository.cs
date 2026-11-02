namespace FundingAllocation.Endpoints.CheckForReadComplete
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using Microsoft.EntityFrameworkCore;
    using System.Linq;
    using System.Data;
    public class CheckForReadCompleteFundingAllocationRepository : ICheckForReadCompleteFundingAllocationRepository
    {
        private readonly FundingAllocationContext _context;

        public CheckForReadCompleteFundingAllocationRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<int> GetNumParkedNotAwaitingOutcome(int readId)
        {
            string parkedStatus = FundingAllocationStatus.Parked.ToString();
            string awaitingOutcomeSubStatus = FundingAllocationSubStatus.AwaitingOutcome.ToString();

            return await (from res in _context.FundingAllocations
                                where res.Status == parkedStatus
                                && res.ReadId == readId
                                && res.SubStatus != awaitingOutcomeSubStatus 
                                select res).CountAsync();
        }

        public async Task<int> SetToDiscardedSupersededWhereParked(IReadOnlyCollection<string> fundingNamesToDiscard, int readIdToIgnore)
        {
            string discardedStatus = FundingAllocationStatus.Discarded.ToString();
            string supersededSubStatus = FundingAllocationSubStatus.Superseded.ToString();
            string parkedStatus = FundingAllocationStatus.Parked.ToString();

            var res = await _context.FundingAllocations.Where(fa => fundingNamesToDiscard.Contains(fa.FundingAllocationName)
            && fa.Status == parkedStatus && fa.ReadId != readIdToIgnore).ToListAsync();
            foreach ( var item in res)
            {
                item.Status = discardedStatus;
                item.SubStatus = supersededSubStatus;
                _context.FundingAllocations.Attach(item);
                _context.Entry(item).Property(r => r.Status).IsModified = true;
                _context.FundingAllocations.Update(item);
                await _context.SaveChangesAsync();
            }           
            return 0;
        }

        public async Task UpdateParkingInfoForDiscarded(IReadOnlyCollection<string> fundingNamesToDiscard, int readIdToIgnore, DateTime now)
        {
            string discardedStatus = FundingAllocationStatus.Discarded.ToString();

            var param = new DynamicParameters();         
            
            param.Add("discardedStatus", discardedStatus);
            param.Add("now", now);
            param.Add("fundingAllocationNames", getFundingIdsTable(fundingNamesToDiscard).AsTableValuedParameter("FundingAllocationNamesUDT"));
            param.Add("readIdToIgnore", readIdToIgnore);

            await _context.Database.GetDbConnection().ExecuteAsync(
                "FundingAllocation.UpdateParkingInfoForDiscarded",param,commandType:CommandType.StoredProcedure,
                transaction: _context.CurrentTransaction);
        }

        private static DataTable getFundingIdsTable(IReadOnlyCollection<string> fundingNamesToDiscard)
        {
            DataTable fundingAllocationDT = new DataTable();
            fundingAllocationDT.Columns.Add("FundingAllocationName");
            foreach (var fundingAllocationName in fundingNamesToDiscard)
            {
                fundingAllocationDT.Rows.Add(fundingAllocationName);
            }
            return fundingAllocationDT;
        }
    }
}
