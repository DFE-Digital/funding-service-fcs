namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    public partial class Period
    {
        public string GetFundingPeriodName()
        {
            return this.periodType.periodTypeCode.ToString() + period1;
        }
    }
}
