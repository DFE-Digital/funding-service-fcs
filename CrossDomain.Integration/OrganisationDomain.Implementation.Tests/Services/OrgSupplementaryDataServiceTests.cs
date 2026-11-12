namespace OrganisationDomain.Implementation.Tests.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Implementation.Services;
    using Integration.Entities;
    using Integration.MainEndpoint.Ioc;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    //using UkrlpProviderQueryWS;
    using UnitTests.Common;

    [TestClass]
    public class OrgSupplementaryDataServiceTests
    {
        //[TestMethod, TestCategory("IntegrationTest")]
        //public void ProviderQueryServiceV5_ShouldConnectToService()
        //{
        //    // 10007154 - PD1 ukprn
        //    ProviderQueryServiceV5 providerQueryServiceV5 = new ProviderQueryServiceV5
        //    {
        //        Url = ConfigurationManager.AppSettings["UkrlpService:Url"]
        //    };

        //    string stakeholderId = ConfigurationManager.AppSettings["UkrlpService:StakeholderId"];

        //    ProviderQueryResponse providerQueryResponse = providerQueryServiceV5.retrieveAllProviders(new ProviderQueryStructure
        //    {
        //        QueryId = "1",
        //        SelectionCriteria = new SelectionCriteriaStructure
        //        {
        //            CriteriaCondition = QueryCriteriaConditionType.AND,
        //            CriteriaConditionSpecified = true,
        //            UnitedKingdomProviderReferenceNumberList = new []{ "10001463" },
        //            StakeholderId   = stakeholderId,
        //            ApprovedProvidersOnly = YesNoType.No,
        //            ApprovedProvidersOnlySpecified = true,
        //            ProviderStatus = "A"
        //        }
        //    });

        //    Assert.IsNotNull(providerQueryResponse, "the response is null");
        //    Assert.AreEqual(1, providerQueryResponse.MatchingProviderRecords.Length, "we have not found the provider");
        //}

        //[TestMethod, TestCategory("IntegrationTest")]
        //public void ProviderQueryServiceV5_ShouldBringBackProviderChanges()
        //{
        //    ProviderQueryServiceV5 providerQueryServiceV5 = new ProviderQueryServiceV5
        //    {
        //        Url = ConfigurationManager.AppSettings["UkrlpService:Url"]
        //    };

        //    string stakeholderId = ConfigurationManager.AppSettings["UkrlpService:StakeholderId"];

        //    ProviderQueryResponse providerQueryResponse = providerQueryServiceV5.retrieveAllProviders(new ProviderQueryStructure
        //    {
        //        QueryId = "1",
        //        SelectionCriteria = new SelectionCriteriaStructure
        //        {
        //            CriteriaCondition = QueryCriteriaConditionType.AND,
        //            CriteriaConditionSpecified = true,
        //            StakeholderId = stakeholderId,
        //            ApprovedProvidersOnly = YesNoType.No,
        //            ApprovedProvidersOnlySpecified = true,
        //            ProviderStatus = "A",
        //            ProviderUpdatedSince = DateTime.Now.AddDays(-7),
        //            ProviderUpdatedSinceSpecified = true
        //        }
        //    });

        //    Assert.IsNotNull(providerQueryResponse, "the response is null");
        //    Assert.IsTrue(providerQueryResponse.MatchingProviderRecords.Length > 0, "we have not found any changes");
        //}

        //[TestMethod, TestCategory("IntegrationTest")]
        //public void OrgSupplementaryDataService_ShouldResolveAndCallGetDataForUkprn()
        //{
        //    IOrgSupplementaryDataService supplementaryDataService =
        //        GetContainer().Resolve<IOrgSupplementaryDataService>();

        //    OrgSupplementaryDataServiceResult result = supplementaryDataService.GetDataForUkprn(10000937);

        //    Assert.AreEqual(true, result.IsSuccessful, "The call has not been successful");
        //    Assert.AreEqual("02154580", result.CompanyRegNumber, "The CompanyRegNumber is not correct");
        //}

        //[TestMethod, TestCategory("IntegrationTest")]
        //public void OrgSupplementaryDataService_ShouldGetDataForPd1Ukprn()
        //{
        //    IOrgSupplementaryDataService supplementaryDataService =
        //        GetContainer().Resolve<IOrgSupplementaryDataService>();

        //    OrgSupplementaryDataServiceResult result = supplementaryDataService.GetDataForUkprn(10007154);

        //    Assert.AreEqual(true, result.IsSuccessful, "The call has not been successful");
        //}

        //[TestMethod, TestCategory("IntegrationTest")]
        //public void OrgSupplementaryDataService_ShouldGetDataForPd2Ukprn()
        //{
        //    IOrgSupplementaryDataService supplementaryDataService =
        //        GetContainer().Resolve<IOrgSupplementaryDataService>();

        //    OrgSupplementaryDataServiceResult result = supplementaryDataService.GetDataForUkprn(10000009);

        //    Assert.AreEqual(true, result.IsSuccessful, "The call has not been successful");
        //}

        //[TestMethod, TestCategory("IntegrationTest")]
        //public void OrgSupplementaryDataService_ShouldReturnUnSuccessfulWhenUkprnIsNotInUkrlp()
        //{
        //    IOrgSupplementaryDataService supplementaryDataService =
        //        GetContainer().Resolve<IOrgSupplementaryDataService>();

        //    OrgSupplementaryDataServiceResult result = supplementaryDataService.GetDataForUkprn(1000);

        //    Assert.AreEqual(false, result.IsSuccessful, "The call has been successful");
        //}

        //[TestMethod, TestCategory("IntegrationTest")]
        //public void OrgSupplementaryDataService_ShouldGetLastSevenDaysOfChanges()
        //{
        //    const int lastSevenDays = -7;

        //    IOrgSupplementaryDataService supplementaryDataService =
        //        GetContainer().Resolve<IOrgSupplementaryDataService>();

        //    IReadOnlyCollection<OrgSupplementaryData> orgSupplementaryDataCollection =
        //        FunctionRetrier.RetryWhenExceptionThrown(() => supplementaryDataService.GetSupplementaryDataChanges(numberOfDaysToCheck: lastSevenDays));

        //    Assert.IsTrue(orgSupplementaryDataCollection.Count > 0, "We are not getting any changes back");
        //}

        //[TestMethod, TestCategory("IntegrationTest")]
        //public void OrgSupplementaryDataService_GetDataForUkprn_ShouldReturnAddressInformationForProviderWithLegalAddress()
        //{
        //    // arrange
        //    IWindsorContainer container = GetContainer();
        //    OrgSupplementaryDataService orgSupplementaryDataService = new OrgSupplementaryDataService(
        //        container.Resolve<ProviderQueryServiceV5>(),
        //        Mock.Of<ILogger>());

        //    // act
        //    OrgSupplementaryDataServiceResult result = orgSupplementaryDataService.GetDataForUkprn(10036006);

        //    // assert
        //    Assert.IsTrue(result.IsSuccessful, "The call has not been successful");
        //    Assert.IsNotNull(result.LegalAddress.Town, "The address has not been returned");
        //}

        //private IWindsorContainer GetContainer()
        //{
        //    ILoggerFactory loggerFactory = new LoggerFactory();
        //    var container = Bootstrapper.CreateContainer(loggerFactory);
        //    container.Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());
        //    container.BeginScope();

        //    return container;
        //}
    }
}
