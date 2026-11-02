namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    public partial class period
    {
        public string GetFundingPeriodName()
        {
            return this.periodType.periodTypeCode.ToString() + period1;
        }
    }
}
