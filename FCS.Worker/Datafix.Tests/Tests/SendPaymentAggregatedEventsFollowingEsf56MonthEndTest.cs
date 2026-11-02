namespace Datafix.Tests.Tests
{
    using Automation.Releases.R94e;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class SendPaymentAggregatedEventsFollowingEsf56MonthEndTest
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SendPaymentAggregatedEventsFollowingEsf56MonthEnd_ShouldWork()
        {
            SendPaymentAggregatedEventsFollowingEsf56MonthEnd dataFix = new SendPaymentAggregatedEventsFollowingEsf56MonthEnd();
            dataFix.ApplyDataFix();
        }
    }
}
