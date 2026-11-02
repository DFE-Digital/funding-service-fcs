namespace FCT.Operations.Cda.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class CdaConfigRepository : ICdaConfigRepository
    {
        private readonly IOverrideDateRepository _dateProvider;

        public CdaConfigRepository(IOverrideDateRepository dateProvider)
        {
            _dateProvider = dateProvider;
        }

        public async Task<IReadOnlyCollection<CdaExtract>> GetAllCdaExtracts(ConnectionInfo connectionInfo)
        {
            DateTime todayDate = await _dateProvider.GetDate(connectionInfo);
            todayDate = todayDate.Date;
            var rows = await connectionInfo.Connection.QueryAsync(
                "sp_Operation_GetAllCdaExtracts @todayDate",
                transaction: connectionInfo.Transaction,
                param: new { todayDate });

            return rows.GroupBy(r => new { r.ExtractName, r.ReportingCloseDate, r.ArchiveClosedContracts }).Select(extractNameGrp =>
            {
                return new CdaExtract(extractNameGrp.Key.ExtractName)
                {
                    ReportingCloseDate = extractNameGrp.Key.ReportingCloseDate,
                    ArchiveClosedContracts = extractNameGrp.Key.ArchiveClosedContracts,
                    CdaReportFundingStreamPeriods = extractNameGrp.Select(fsp =>
                            new CdaReportFundingStreamPeriod(extractNameGrp.Key.ExtractName,
                                fsp.FundingStreamPeriodCode))
                        .ToList()
                };
            }).ToList();
        }
    }
}