namespace SFA.FCT.ContractRequestDomain.DataStore.Repositories
{
    using System;
    using Model;

    public class FundingTypeFundingPeriodRepository : IFundingTypeFundingPeriodRepository
    {
        private readonly IContractRequestDbContext _context;

        public FundingTypeFundingPeriodRepository(IContractRequestDbContext context)
        {
            _context = context;
        }

        public DateTime? GetActivityCloseDate(string fundingTypeCode, string fundingPeriodName)
        {
            FundingTypeFundingPeriod ftp = _context.FundingTypeFundingPeriods.Find(fundingTypeCode, fundingPeriodName);

            return ftp?.ContractingActivityCloseDate;
        }

        public bool IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg(string fundingTypeCode, string fundingPeriodName)
        {
            return _context.FundingTypeFundingPeriods.Find(fundingTypeCode, fundingPeriodName).AllowUseOfDeliveryOrgs;
        }
    }
}