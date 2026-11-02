namespace FundingAllocation.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class FundingNotificationApiTestImplTests
    {
        [TestMethod, TestCategory("Exploratory")]
        public void FundingNotificationApiTestImpl_ShouldReturnPageOfAtomItems()
        {
            // arrange
            var apiTestImpl = new FundingNotificationApiTestImpl(AppConfiguration.Configuration());

            // act
            IReadOnlyCollection<AtomItem> page1 = apiTestImpl.GetPage(1).Result;
            IReadOnlyCollection<AtomItem> page2 = apiTestImpl.GetPage(2).Result;
            IReadOnlyCollection<AtomItem> page3 = apiTestImpl.GetPage(3).Result;

            // assert
            page1.Should().NotBeEmpty();
            page1.Count.Should().Be(1);
            page1.Single().PageNumber.Should().Be(1);
            page1.Single().FundingId.Should().Be("1619-AS-2021-Contract-Provider-10017023-1_2");

            page2.Should().NotBeEmpty();
            page2.Count.Should().Be(1);
            page2.Single().PageNumber.Should().Be(2);
            page2.Single().FundingId.Should().Be("1619-AS-2021-Contract-Provider-10017024-3_6");

            page3.Should().NotBeEmpty();
            page3.Count.Should().Be(1);
            page3.Single().PageNumber.Should().Be(3);
            page3.Single().FundingId.Should().Be("1619-AS-2021-Contract-Provider-10017057-5_1");
        }

        [TestMethod, TestCategory("Exploratory")]
        public void FundingNotificationApiTestImpl_ShouldGetLatestPageData()
        {
            // arrange
            var apiTestImpl = new FundingNotificationApiTestImpl(AppConfiguration.Configuration());

            // act
            var latestPageData = apiTestImpl.GetLatestPageData().Result;

            // assert
            latestPageData.PageNumber.Should().Be(3);
            latestPageData.AtomItems.Length.Should().Be(1);
            latestPageData.AtomItems.Single().FundingId.Should().Be("1619-AS-2021-Contract-Provider-10017057-5_1");
        }

        [TestMethod, TestCategory("Exploratory")]
        public void FundingNotificationApiTestImpl_ShouldReturnProviderDto()
        {
            // arrange
            var apiTestImpl = new FundingNotificationApiTestImpl(AppConfiguration.Configuration());

            // act
            ProviderFundingAllocationApiDto provider = apiTestImpl.GetProviderFundingAllocation("1619-AS-2021-10017024-3_6").Result;

            // assert
            provider.Should().NotBeNull();
        }

        [TestMethod, TestCategory("Exploratory")]
        public void FundingNotificationApiTestImpl_ShouldReturnProviderDtoWithSomeAllocationLines()
        {
            // arrange
            var appConfiguration = AppConfiguration.Configuration();
            appConfiguration["StorageTableSuffix"] = "DAT";

            var apiTestImpl = new FundingNotificationApiTestImpl(appConfiguration);

            // act
            ProviderFundingAllocationApiDto provider = apiTestImpl.GetProviderFundingAllocation("1619-AS-2021-10014005-4_6").Result;

            // assert
            provider.Should().NotBeNull();
            provider.FundingAllocationLines.Length.Should().Be(4);
        }
    }
}
