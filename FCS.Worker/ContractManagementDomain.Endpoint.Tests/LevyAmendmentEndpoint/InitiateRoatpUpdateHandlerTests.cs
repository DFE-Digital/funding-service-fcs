namespace ContractManagementDomain.Endpoint.Tests.LevyAmendmentEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Infrastructure;
    using ContractManagementDomain.Endpoint.LevyAmendmentEndpoint;
    using ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.DTOs;
    using ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class InitiateRoatpUpdateHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InitiateRoatpUpdateHandler_Handle_ShouldGetFromRoatpApiAndPersistUkrpnsToRepository()
        {
            // arrange
            IReadOnlyCollection<RoatpProvider> providersFromApi =
                Enumerable.Range(10000000, 20)
                    .Select(i => new RoatpProvider(i.ToString(), "MainProvider"))
                    .ToList();

            Mock<IRoatpApiHttpClient> roatpApiHttpClientMock = new Mock<IRoatpApiHttpClient>();
            Mock<IRoatpRepositoryService> roatpService = new Mock<IRoatpRepositoryService>();

            List<string> actualPersistedUkprns = new List<string>();

            roatpApiHttpClientMock.Setup(m => m.GetAllProviders()).ReturnsAsync(providersFromApi);
            roatpService.Setup(m => m.PopulateValidUkprnsFromRoatp(It.IsAny<IReadOnlyCollection<RoatpProvider>>(), It.IsAny<ConnectionInfo>()))
                .Callback((IReadOnlyCollection<RoatpProvider> roatpProviders, ConnectionInfo ci) => actualPersistedUkprns.AddRange(roatpProviders.Select(p => p.Ukprn).ToList()));

            InitiateRoatpUpdateHandler handler = new InitiateRoatpUpdateHandler(roatpApiHttpClientMock.Object, roatpService.Object, Mock.Of<ILogger>(), Mock.Of<ISessionConnectionFactory>());

            // act
            var handle = handler.Handle(new InitiateRoatpUpdateCommand(), Mock.Of<IMessageHandlerContext>());

            // assert
            Assert.AreEqual(providersFromApi.Count, actualPersistedUkprns.Count, "Count of persisted UKPRNs was incorrect");

            providersFromApi.ForEach(p =>
                Assert.IsNotNull(actualPersistedUkprns.SingleOrDefault(ukprn => ukprn == p.Ukprn), $"UKPRN {p.Ukprn} was not found"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateRoatpUpdateHandler_ShouldResolve()
        {
            using (IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            {
                container.Register(Component.For<InitiateRoatpUpdateHandler>());
                container.BeginScope();

                var handler = container.Resolve<InitiateRoatpUpdateHandler>();

                Assert.IsNotNull(handler, "Handler failed to resolve");
            }
        }
    }
}