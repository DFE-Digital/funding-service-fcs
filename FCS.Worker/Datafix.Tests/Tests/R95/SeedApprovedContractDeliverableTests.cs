namespace Datafix.Tests.Tests.R95
{
    using Automation.Releases.R119b;
    using Automation.Releases.R121;
    using Automation.Releases.R123a;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class SeedApprovedContractDeliverableTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SeedApprovedContractDeliverable_ShouldCreateRows()
        {
            UkrlpUpdateFromApr2022Onwards seed = new UkrlpUpdateFromApr2022Onwards();

            seed.ApplyDataFix();
        }
    }
}
