namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using Dto;
    using FundingAllocation.Repositories;
    using Microsoft.Azure.Amqp.Framing;
    using Microsoft.EntityFrameworkCore;
    using SFA.FCT.CrossDomain.Integration.Common;
    using System.Linq;

    public class FundingTypeFundingPeriodRepository : IFundingTypeFundingPeriodRepository
    {
        private readonly FundingAllocationContext _context;
        private readonly IOverrideDateRepository _overrideDateRepository;
        public FundingTypeFundingPeriodRepository(FundingAllocationContext context, IOverrideDateRepository overrideDateRepository)
        {
            _context = context;
            _overrideDateRepository = overrideDateRepository; 
        }

        public async Task<IntentFundingTypeFundingPeriod> GetAmendmentInfo(string fundingTypeCode, string fundingPeriod)
        {
            var config = await (from ftfp in _context.FundingTypeFundingPeriodConfigRows
                          where ftfp.FundingTypeCode == fundingTypeCode && ftfp.FundingPeriod == fundingPeriod
                          select new IntentFundingTypeFundingPeriod(ftfp.AllowNewAmendment,
                              ftfp.PrecedingFtpFundingPeriod,
                              ftfp.PrecedingFtpFundingType,
                              ftfp.FtpGroupCode)).SingleAsync();
            return config;
        }

        public async Task<bool> DoAllAmendmentsRequireSigning(string fundingTypeCode, string fundingPeriod)
        {
            var allAmendmentsRequireSigning = await (from ftfp in _context.FundingTypeFundingPeriodConfigRows
                                where ftfp.FundingTypeCode == fundingTypeCode && ftfp.FundingPeriod == fundingPeriod
                                select ftfp.AllAmendmentsRequireSigning).SingleAsync();

            return allAmendmentsRequireSigning ?? false;
        }

        public async Task<bool> DoAmendmentTypeToNotificationOnExpiredContract(string fundingTypeCode, string fundingPeriod)
        {
            var result = false;
            var contractExpiredDate = await (from ftfp in _context.FundingTypeFundingPeriodConfigRows
                                                     where ftfp.FundingTypeCode == fundingTypeCode && ftfp.FundingPeriod == fundingPeriod
                                                     select ftfp.ContractExpiryDate).SingleAsync();
           
            if (contractExpiredDate != null)
            { 
                var actualExpireDate = contractExpiredDate;
                var currentDate =  await _overrideDateRepository.GetDate();
                result = actualExpireDate < currentDate;
            }
             return result;
        }
    }
}