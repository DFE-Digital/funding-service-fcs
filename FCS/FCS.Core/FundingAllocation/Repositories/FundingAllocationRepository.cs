namespace FundingAllocation.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using Dto;
    using Extensions;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.EntityFrameworkCore.Storage;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class FundingAllocationRepository : IFundingAllocationRepository
    {
        private readonly FundingAllocationContext _context;

        public FundingAllocationRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<IReadOnlyCollection<string>> GetExistingIdsForPage(IReadOnlyCollection<string> fundingIdsOnFeed)
        {
            return await _context.FundingAllocations
                .AsNoTracking()
                 .Where(fa => fundingIdsOnFeed.Contains(fa.FundingId))
                .Select(fa => fa.FundingId)
                .ToListAsync();
        }

        public async Task CreateFundingAllocations(IEnumerable<FundingAllocation> fundingAllocations)
        {
            var table = new DataTable("FundingAllocationsTable")
            {
                Columns =
                {
                    new DataColumn("FundingId", typeof(string)),
                    new DataColumn("FundingVersion", typeof(string)),
                    new DataColumn("Period", typeof(string)),
                    new DataColumn("AllocationFundingStream", typeof(string)),
                    new DataColumn("UKPRN", typeof(string)),
                    new DataColumn("Value", typeof(decimal)),
                    new DataColumn("PositionInPage", typeof(int)),
                    new DataColumn("PageNumber", typeof(int)),
                    new DataColumn("ProviderFundingCount", typeof(int)),
                    new DataColumn("ReadId", typeof(int)),
                    new DataColumn("FundingAllocationName", typeof(string)),
                }
            };

            fundingAllocations.ToList().ForEach(fa =>
            {
                var row = table.NewRow();
                row["FundingId"] = fa.FundingId;
                row["FundingVersion"] = fa.FundingVersion;
                row["Period"] = fa.Period;
                row["AllocationFundingStream"] = fa.AllocationFundingStream;
                row["UKPRN"] = fa.UKPRN;
                row["Value"] = fa.Value;
                row["PositionInPage"] = fa.PositionInPage;
                row["PageNumber"] = fa.PageNumber;
                row["ProviderFundingCount"] = fa.ProviderFundingCount;
                row["ReadId"] = fa.ReadId;
                row["FundingAllocationName"] = fa.FundingAllocationName;
                table.Rows.Add(row);
            });

            await using var command = new SqlCommand(
                "FundingAllocation.InsertFundingAllocations",
                (SqlConnection)_context.Database.GetDbConnection(),
                (SqlTransaction)_context.Database.CurrentTransaction.GetDbTransaction())
            {
                CommandType = CommandType.StoredProcedure
            };

            SqlParameter userDefinedTableParameter = command.Parameters.AddWithValue("@fundingAllocationsTable", table);
            userDefinedTableParameter.SqlDbType = SqlDbType.Structured;
            userDefinedTableParameter.TypeName = "FundingAllocation.FundingAllocationTableType";

            await command.ExecuteNonQueryAsync();
        }

        public async Task<FundingAllocation> GetFundingAllocation(string fundingId)
        {
            return await _context.FundingAllocations
                .AsNoTracking()
                .Include(fa => fa.ProviderFundingAllocations)
                .ThenInclude(pfa => pfa.ProviderFunding)
                .ThenInclude(pf => pf.FundingAllocationLines)
                .ThenInclude(fal => fal.FundingAllocationProfilePeriods)
                .SingleAsync(fa => fa.FundingId == fundingId);
        }

        public async Task<IReadOnlyCollection<FundingAllocation>> GetFundingAllocations(IEnumerable<string> fundingIds)
        {
            return await _context.FundingAllocations
                .AsNoTracking()
                .Include(fa => fa.ProviderFundingAllocations)
                .ThenInclude(pfa => pfa.ProviderFunding)
                .ThenInclude(pf => pf.FundingAllocationLines)
                .ThenInclude(fal => fal.FundingAllocationProfilePeriods)
                .Where(fa => fundingIds.Contains(fa.FundingId))
                .ToArrayAsync();
        }

        public async Task<IReadOnlyCollection<FundingAllocation>> GetFundingAllocationsIncludingProvidersAndLines(IEnumerable<string> fundingIds)
        {
            return await _context.FundingAllocations
                .AsNoTracking()
                .Include(fa => fa.ProviderFundingAllocations)
                .ThenInclude(pfa => pfa.ProviderFunding)
                .ThenInclude(pf => pf.FundingAllocationLines)
                .Where(fa => fundingIds.Contains(fa.FundingId))
                .ToArrayAsync();
        }

        public async Task<FundingAllocation> GetFundingAllocationIncludingProviders(string fundingId)
        {
            return await _context.FundingAllocations
                .AsNoTracking()
                .Include(fa => fa.ProviderFundingAllocations)
                .ThenInclude(pfa => pfa.ProviderFunding)
                .SingleAsync(fa => fa.FundingId == fundingId);
        }

        public async Task<IReadOnlyCollection<FundingAllocation>> GetFundingAllocationsIncludingProviders(IEnumerable<string> fundingIds)
        {
            return await _context.FundingAllocations
                .AsNoTracking()
                .Include(fa => fa.ProviderFundingAllocations)
                .ThenInclude(pfa => pfa.ProviderFunding)
                .Where(fa => fundingIds.Contains(fa.FundingId))
                .ToListAsync();
        }

        public async Task<Guid?> GetFundingAllocationCrmId(string fundingId)
        {
            return await _context.FundingAllocations
                .AsNoTracking()
                .Where(fa => fa.FundingId == fundingId)
                .Select(fa => fa.CrmEntityId)
                .SingleAsync();
        }

        public async Task UpdateReleaseGroupOnFundingAllocation(string fundingId, int? releaseGroupId)
        {
            var res = await _context.FundingAllocations.SingleOrDefaultAsync(fa => fa.FundingId == fundingId);
            if (res != null)
            {
                res.ReleaseGroupId = releaseGroupId;
                _context.FundingAllocations.Attach(res);
                _context.Entry(res).Property(r => r.ReleaseGroupId).IsModified = true;
                _context.FundingAllocations.Update(res);
                await _context.SaveChangesAsync();
            }
                
        }

        public async Task AddCrmEntityIdToFundingAllocation(string fundingId, Guid crmEntityId)
        {
            var entity =
                await _context.FundingAllocations.SingleAsync(fa => fa.FundingId == fundingId);

            entity.CrmEntityId = crmEntityId;

            await _context.SaveChangesAsync();
        }

        public async Task<IReadOnlyCollection<string>> GetReleaseGroupsThatCanNowBeSetToReleased(
            IReadOnlyCollection<string> fundingAllocationIds, int? releaseGroupId)
        {
            var schedulingStatus = FundingAllocationStatus.InRelease.ToString();
            var awaitingReleaseSubStatus = FundingAllocationSubStatus.Queued.ToString();
            var createdRelationship = RelationshipToFundingAllocationEnum.Created.ToString();

            fundingAllocationIds ??= new List<string>();

            var param = new DynamicParameters();
            param.Add("fundingAllocationIds", getFundingAllocationIdsTable(fundingAllocationIds).AsTableValuedParameter("FundingAllocationIdsUDT"));
            param.Add("schedulingStatus", schedulingStatus);
            param.Add("awaitingReleaseSubStatus", awaitingReleaseSubStatus);
            param.Add("releaseGroupId", releaseGroupId);
            param.Add("createdRelationship", createdRelationship);



            var releaseGrps = await _context.Database.GetDbConnection().QueryAsync<ReleaseGroupInfo>(
                 "FundingAllocation.GetReleaseGroupsThatCanNowBeSetToReleased", param, commandType: CommandType.StoredProcedure,
                transaction: _context.CurrentTransaction);

            return releaseGrps.Where(rg => rg.HaveAllFundingAllocationsGotAContractOrQueued)
                .Select(rg => rg.ReleaseGroupName)
                .ToList();
        }

        private static DataTable getFundingAllocationIdsTable(IReadOnlyCollection<string> fundingAllocationIds)
        {
            DataTable fundingAllocationIdDT = new DataTable();
            fundingAllocationIdDT.Columns.Add("FundingId");
            foreach (var fundingAllocationId in fundingAllocationIds)
            {
                fundingAllocationIdDT.Rows.Add(fundingAllocationId);
            }
            return fundingAllocationIdDT;
        }

        public async Task<IReadOnlyCollection<string>> GetFundingIdsForReadId(int readId)
        {
            var readIds = await (from res in _context.FundingAllocations
                                 where res.ReadId == readId
                                 select res.FundingId).ToListAsync();

            return readIds;
        }

        public async Task<IReadOnlyCollection<string>> GetFundingIdsWithStatusAndSubStatus(FundingAllocationStatus status, FundingAllocationSubStatus subStatus)
        {

            var statusString = status.ToString();
            var subStatusString = subStatus.ToString();
            var readIds = await (from res in _context.FundingAllocations
                                 where res.Status == statusString
                                 && res.SubStatus == subStatusString
                                 select res.FundingId).ToListAsync();

            return readIds.ToList();

        }

        public async Task<bool> IsFundingAllocationInReleaseGroup(string fundingId)
        {
            var count = await _context.Database.GetDbConnection().ExecuteScalarAsync<int>("sp_FA_IsFundingAllocationInReleaseGroup @fundingId", new { fundingId },
                transaction: _context.CurrentTransaction);

            return count == 1;
        }

        public async Task SetToReturnedToScheduling(string fundingId)
        {
            var res = await _context.FundingAllocations.SingleOrDefaultAsync(fa => fa.FundingId == fundingId);
            if (res != null)
            {
                res.ContractId = null;
                res.ReleaseGroupId = null;
                _context.FundingAllocations.Attach(res);
                _context.Entry(res).Property(r => r.ContractId).IsModified = true;
                _context.FundingAllocations.Update(res);
                await _context.SaveChangesAsync();
            }
        }

        public async Task RemoveContractFromFundingAllocations(IEnumerable<string> fundingIds)
        {
            var res = (from fa in _context.FundingAllocations
                       where fundingIds.Contains(fa.FundingId)
                       select fa).ToList();


            if (res != null)
            {
                res.ForEach(fa => { fa.ContractId = null; });
                _context.FundingAllocations.AttachRange(res);
                _context.FundingAllocations.UpdateRange(res);
                await _context.SaveChangesAsync();
            }
        }

        public async Task SetFundingAllocationStatusSubStatus(IEnumerable<string> fundingIds, FundingAllocationStatus newStatus, FundingAllocationSubStatus newSubStatus)
        {
            var status = newStatus == FundingAllocationStatus.NotSet ? null : newStatus.ToString();
            var subStatus = newSubStatus == FundingAllocationSubStatus.NotSet ? null : newSubStatus.ToString();

            var sql = @"UPDATE [FundingAllocation].[FundingAllocation] 
                         SET Status = @status,
                             SubStatus = @subStatus
                         WHERE FundingId in @fundingIds";

            await _context.Database
                .GetDbConnection()
                .ExecuteAsync(sql, transaction: _context.CurrentTransaction, param: new { fundingIds, status, subStatus });
        }

        private static DataTable getFundingIdsTable(IEnumerable<string> fundingIds)
        {
            DataTable fundingIdDT = new DataTable();
            fundingIdDT.Columns.Add("FundingIds");
            foreach (var fundingId in fundingIds)
            {
                fundingIdDT.Rows.Add(fundingId);
            }
            return fundingIdDT;
        }

        public async Task SetContractId(IEnumerable<string> fundingIds, int contractId)
        {

            var res = (from fa in _context.FundingAllocations
                       where fundingIds.Contains(fa.FundingId)
                       select fa).ToList();


            if (res != null)
            {
                res.ForEach(fa => { fa.ContractId = contractId; });
                _context.FundingAllocations.AttachRange(res);
                _context.FundingAllocations.UpdateRange(res);
                await _context.SaveChangesAsync();
            }
        }


        public async Task InsertOrUpdateParkingInfoLastDiscarded(IEnumerable<string> fundingIds, DateTime now)
        {

            foreach (var fundingId in fundingIds)
            {
                await _context.Database
                    .GetDbConnection()
                    .ExecuteAsync("sp_FA_InsertOrUpdateParkingInfoLastDiscarded @fundingId,@now", transaction: _context.CurrentTransaction, param: new { fundingId, now });
            };
        }

        public async Task SetFundingAllocationsParkedSubStatus(IReadOnlyCollection<string> fundingIds, FundingAllocationSubStatus newSubStatus)
        {
            var lastParked = DateTime.UtcNow;
            var allocationsToUpdate = await _context.FundingAllocations
                .Include(fa => fa.ParkingAndDiscardedInfo)
                .Where(fa => fundingIds.Contains(fa.FundingId) && fa.SubStatus != newSubStatus.ToString())
                .ToListAsync();

            allocationsToUpdate.ForEach(fa =>
            {
                if (fa.ParkingAndDiscardedInfo == null)
                {
                    fa.ParkingAndDiscardedInfo = new ParkingAndDiscardedInfo { FundingAllocationId = fa.FundingId };
                }

                fa.ParkingAndDiscardedInfo.LastParked = lastParked;
                fa.FundingAllocationSubStatus = newSubStatus;
                fa.FundingAllocationStatus = FundingAllocationStatus.Parked;
            });

            await _context.SaveChangesAsync();
        }

        public async Task<IReadOnlyCollection<string>> GetFundingAllocationNamesInContractControlWithoutOutcome(IEnumerable<string> fundingAllocationNames, int readIdToIgnore)
        {
            var queuedStatus = FundingAllocationStatus.InRelease.ToString();
            var queuedSubStatus = FundingAllocationSubStatus.Queued.ToString();
            const string sql = @"Select distinct FundingAllocationName
                                from  [FundingAllocation].[FundingAllocation]
                                where FundingAllocationName in @fundingAllocationNames
                                and (Status is null or (Status = @queuedStatus and SubStatus = @queuedSubStatus))
                                and ReadId != @ignoredReadId";

            var fundingAllocationNamesForParking = await _context.Database.GetDbConnection()
                .QueryAsync<string>(
                    sql,
                    transaction: _context.CurrentTransaction,
                    param: new
                    {
                        fundingAllocationNames,
                        ignoredReadId = readIdToIgnore,
                        queuedStatus,
                        queuedSubStatus
                    });

            return fundingAllocationNamesForParking.ToList();
        }

        public async Task<IReadOnlyCollection<FundingIdAndName>> GetLatestContractApprovedFundingAllocationIds(IEnumerable<string> fundingAllocationNames)
        {
            var contractApprovedStatus = FundingAllocationStatus.ContractApproved.ToString();

            const string sql = @" select fa.fundingId, fa.fundingVersion, fa.fundingAllocationName
                                  from [FundingAllocation].[FundingAllocation] fa
                                  where fa.Status = @contractApprovedStatus
                                  and fa.FundingAllocationName in @fundingAllocationNames";

            var fundingIds = await _context.Database.GetDbConnection().QueryAsync<FundingIdAndVersion>(sql, transaction: _context.CurrentTransaction,
                param: new { fundingAllocationNames, contractApprovedStatus });

            var lastApproved = fundingIds.ToList().GroupBy(fId => fId.FundingAllocationName).Select(grp =>
            {
                var latest = grp.Select(fid => fid.FundingId.ToFundingIdInfo())
                    .OrderByDescending(info => info.FundingIdVersion)
                    .First();

                return latest;
            });

            return lastApproved.Select(la => new FundingIdAndName(la.FundingId, la.FundingIdName)).ToList();
        }

        public async Task<IReadOnlyCollection<string>> GetFundingIdsForFundingNamesAndStatus(
            IEnumerable<string> fundingAllocationNames, FundingAllocationStatus status)
        {
            var statusString = status.ToString();

            const string sql = @" select fa.fundingId
                                  from [FundingAllocation].[FundingAllocation] fa
                                  where fa.FundingAllocationName in @fundingAllocationNames
                                  and fa.status = @statusString";

            var fundingIds = await _context.Database.GetDbConnection().QueryAsync<string>(sql, transaction: _context.CurrentTransaction,
                param: new { fundingAllocationNames, statusString });

            return fundingIds.ToList();
        }

        public async Task UpdateFundingAllocations(IEnumerable<string> fundingIds, int releaseGroupId, FundingAllocationStatus newStatus,
            FundingAllocationSubStatus newSubStatus)
        {
            var status = newStatus.ToString();
            var subStatus = newSubStatus.ToString();           

            var param = new DynamicParameters();
            param.Add("fundingIds", getFundingIdsTable(fundingIds).AsTableValuedParameter("FundingIdsUDT"));
            param.Add("releaseGroupId", releaseGroupId);
            param.Add("status", status);
            param.Add("subStatus", subStatus);

            await _context.Database
               .GetDbConnection()
               .ExecuteAsync("sp_FA_UpdateFundingAllocations", param, commandType: CommandType.StoredProcedure, transaction: _context.CurrentTransaction);

        }

        public async Task<IReadOnlyCollection<string>> GetAllParkedFundingIdsWithSubStatuses(params FundingAllocationSubStatus[] subStatuses)
        {
            var subStatusStrings = subStatuses.Select(subStatus => subStatus.ToString());
            var status = FundingAllocationStatus.Parked.ToString();

            var fundingIds = await (from res in _context.FundingAllocations
                                    where res.Status == status
                                    && subStatusStrings.Contains(res.SubStatus)
                                    select res.FundingId).ToListAsync();

            return fundingIds.ToList();
        }

        public async Task<IReadOnlyCollection<string>> GetAllFundingIdsAwaitingProviderNotInCurrentRead(int readId)
        {
            var subStatus = FundingAllocationSubStatus.AwaitingProvider.ToString();
            var status = FundingAllocationStatus.Parked.ToString();

            var fundingIds = await (from fa in _context.FundingAllocations
                                    where fa.SubStatus == subStatus
                                    && fa.ReadId != readId
                                    && fa.Status == status
                                    select fa.FundingId).ToListAsync();
            return fundingIds.ToList();
        }

        public async Task<IReadOnlyCollection<string>> GetReleaseGroupsWithQueuedFundingAllocationsForContract(
            string contractNumber)
        {
            var queuedSubStatus = FundingAllocationSubStatus.Queued.ToString();
            var queuedStatus = FundingAllocationStatus.InRelease.ToString();
            var queuedRelationship = RelationshipToFundingAllocationEnum.Queued.ToString();

            var fundingIds = await _context.Database.GetDbConnection().QueryAsync<string>("sp_FA_GetReleaseGroupsWithQueuedFundingAllocationsForContract @subStatus," +
                "@status,@contractNumber,@queuedRelationship", transaction: _context.CurrentTransaction,
                param: new
                {
                    subStatus = queuedSubStatus,
                    status = queuedStatus,
                    contractNumber,
                    queuedRelationship
                });

            return fundingIds.ToList();
        }
        public async Task SetFundingAllocationsToPublished(IEnumerable<string> fundingIds)
        {
            var res = (from fa in _context.FundingAllocations
                       where fundingIds.Contains(fa.FundingId)
                       select fa).ToList();

            if (res != null)
            {
                res.ForEach(fa => { fa.IsPublished = true; });
                _context.FundingAllocations.AttachRange(res);
                _context.FundingAllocations.UpdateRange(res);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IReadOnlyCollection<FundingAllocationLine>> GetLatestPublishedFundingLines(string fundingName, string fundingIdToIgnore)
        {

            var rows = await _context.Database.GetDbConnection().QueryAsync<(string providerFundingId, string fundingLineCode, string fundingId)>(
                "sp_FA_GetLatestPublishedFundingLines @fundingName,@fundingIdToIgnore",
                transaction: _context.CurrentTransaction,
                param: new { fundingName, fundingIdToIgnore });

            var latestFundingLines = rows.ToList()
                .GroupBy(r => r.fundingId.ToFundingIdInfo().FundingIdVersion)
                .OrderByDescending(grp => grp.Key)
                .FirstOrDefault()
                ?.ToList() ?? new List<(string providerFundingId, string fundingLineCode, string fundingId)>();

            return latestFundingLines.Select(l => new FundingAllocationLine(l.providerFundingId, l.fundingLineCode)).ToList();
        }

        public async Task SetLinesToIsOfNoInterest(IEnumerable<(string providerFundingId, string fundingLineCode)> fundingLinePKs)
        {

            foreach (var fundingLinePK in fundingLinePKs)
            {
                await _context.Database.GetDbConnection().ExecuteAsync("sp_FA_SetLinesToIsOfNoInterest @providerFundingId,@fundingLineCode", transaction: _context.CurrentTransaction,
                    param: new { fundingLinePK.providerFundingId, fundingLinePK.fundingLineCode });
            }
        }
        public async Task<IReadOnlyCollection<FundingLineValue>> GetFundingLinePlannedValueForFundingAllocationIds(IEnumerable<string> fundingAllocationIds)
        {
            try
            {
                const string sql = @"select sum(a.plannedvalue) FundingValue, a.FundingLineCode, b.FundingId 	
	                            from [FundingAllocation].[FundingAllocationProfilePeriod] a 
	                            join FundingAllocation.ProviderFundingAllocation b
	                                on a.providerfundingId = b.providerfundingId
	                            where 
	                            b.fundingId in @fundingAllocationIds
	                                group by 
	                                a.FundingLineCode, b.fundingId";

                var fundingLineValues = await _context.Database.GetDbConnection().QueryAsync<FundingLineValue>(sql, transaction: _context.CurrentTransaction,
                    param: new { fundingAllocationIds });

                return fundingLineValues.ToList();
            }
            catch (Exception ex) { }
            return null;
        }

        private class ReleaseGroupInfo
        {
            public ReleaseGroupInfo(string releaseGroupName, int totalInGroup, int numWithContract, int totalQueued)
            {
                ReleaseGroupName = releaseGroupName;
                TotalInGroup = totalInGroup;
                NumWithContract = numWithContract;
                TotalQueued = totalQueued;
            }

            public string ReleaseGroupName { get; }
            public int TotalInGroup { get; }
            public int NumWithContract { get; }
            public int TotalQueued { get; }
            public bool HaveAllFundingAllocationsGotAContractOrQueued => TotalInGroup == NumWithContract + TotalQueued;
        }

        private class FundingIdAndVersion
        {
            public FundingIdAndVersion(string fundingId, string fundingVersion, string fundingAllocationName)
            {
                FundingId = fundingId;
                FundingVersion = fundingVersion;
                FundingAllocationName = fundingAllocationName;
            }

            public string FundingId { get; }
            public string FundingVersion { get; }
            public string FundingAllocationName { get; }
        }
    }
}