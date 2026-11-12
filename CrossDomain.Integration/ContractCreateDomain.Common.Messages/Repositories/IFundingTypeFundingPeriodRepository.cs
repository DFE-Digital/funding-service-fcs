namespace SFA.FCT.ContractRequestDomain.DataStore.Repositories
{
    using System;

    public interface IFundingTypeFundingPeriodRepository
    {
        DateTime? GetActivityCloseDate(string fundingTypeCode, string fundingPeriodName);

        bool IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg(string fundingTypeCode, string fundingPeriodName);
    }
}