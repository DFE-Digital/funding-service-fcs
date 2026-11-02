namespace ContractManagementService.Tests.Repositories
{
    using System.Linq;
    using ContractManagementService.Repositories;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CrmConfigurationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmConfigurationRepository_GetFundingConfiguration_ShouldGetData()
        {
            CrmConfigurationRepository repository = new CrmConfigurationRepository(new AppConfiguration());

            var fundingConfigurationType = repository.GetFundingConfiguration("1516", "AY", "24+Loans").Result;
            fundingConfigurationType.FundingConfigurationList.Length.Should().Be(3);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmConfigurationRepository_GetDeliverableConfiguration_ShouldGetData()
        {
            CrmConfigurationRepository repository = new CrmConfigurationRepository(new AppConfiguration());

            var dc = repository.GetDeliverableConfiguration("16-18NLAP2018").Result;
            dc.DeliverableStructureList.Count.Should().Be(5);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        [DataRow(4, "Volume and Value")]
        [DataRow(6, "Value")]
        public void CrmConfigurationRepository_GetDeliverableConfiguration_ShouldMapPlanningUnitForEsf(int deliverableCode, string expectedPlanningUnit)
        {
            CrmConfigurationRepository repository = new CrmConfigurationRepository(new AppConfiguration());
            var dc = repository.GetDeliverableConfiguration("ESF1420").Result;
            
            dc.DeliverableStructureList.Any().Should().BeTrue();
            var deliverableSettings = dc.DeliverableStructureList.Single(d => d.DeliverableCode == deliverableCode).Settings;
            
            deliverableSettings.Single(s => s.SettingCode == "planningunit")
                .SettingValue
                .Should()
                .Be(expectedPlanningUnit);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmConfigurationRepository_GetDeliverableConfiguration_ShouldMapAllowProfileForEsf()
        {
            CrmConfigurationRepository repository = new CrmConfigurationRepository(new AppConfiguration());
            var dc = repository.GetDeliverableConfiguration("ESF1420").Result;

            dc.DeliverableStructureList.Any().Should().BeTrue();
            var deliverableFourSettings = dc.DeliverableStructureList.Single(d => d.DeliverableCode == 4).Settings;

            deliverableFourSettings.Single(s => s.SettingCode == "allowprofile")
                .SettingValue
                .Should()
                .Be("Yes");
        }
    }
}
